import json
import datetime
import numpy as np
from scipy import signal
from flask import Flask, jsonify, request, Response
from mysql import connector
from waitress import serve
from collections import OrderedDict
# pip install numpy
# pip install scipy
# pip install flask
# pip install mysql-connector-python
# pip install waitress
# pip install aws-secretsmanager-caching
# pip install boto3

# needed to set up a secret key for my user
# needed to run aws configure
import botocore 
import botocore.session 
from aws_secretsmanager_caching import SecretCache, SecretCacheConfig 

client = botocore.session.get_session().create_client('secretsmanager')
cache_config = SecretCacheConfig()
cache = SecretCache( config = cache_config, client = client)
secret = cache.get_secret_string('prod/kines')
CONFID = json.loads(secret)
# database connection
def connectSql():
    mydb = connector.connect(
    host=CONFID['host'],
    user=CONFID['username'],
    password=CONFID['password'],
    database=CONFID['dbName']
    )
    return mydb

app = Flask(__name__)
app.json.sort_keys = False # make the order same as construction 

print("Server has started: ")
# ctrl-shift U - uppercase

# --------------------------------------------------------------- PATIENT ---------------------------------------------------------------

@app.route('/mysql/getAllPatients', methods=['GET'])
def getAllPatients():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        mycursor.execute("SELECT * FROM Patient")
        myresult = mycursor.fetchall()

        returnList = []
        for x in myresult:
            returnList.append(OrderedDict({"pID": x[0], "firstName": x[1], "lastName": x[2]}))
        return jsonify(returnList) 

@app.route('/mysql/getOnePatient', methods=['GET'])
def getOnePatient():
    # ?ID=1 need to add a value to key1 that is the patient pID in the url
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor() 

        data = request.args.get('ID')
        sql = "SELECT * FROM Patient WHERE pID=%s"
        val = [(data)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        # Get the patient we are looking for
        patient = OrderedDict()
        for x in myresult:
            patient = OrderedDict({"pID": x[0], "firstName": x[1], "lastName": x[2], "dOB": str(x[3]), "height": x[4], "weight": x[5], 
                "sport": x[6], "gender": x[7], "thirdPartyID": x[8], "incidents": []})  

        # Get the Incidents that that patient has
        sql = "SELECT * FROM Incident WHERE pID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            patient['incidents'].append(OrderedDict({"iID": x[0], "iName": x[1], "iDate": str(x[2]), "pID": x[4]}))
        
        returnList.append(patient)
        return jsonify(returnList) 

# RIGHT NOW, YOU MUST INPUT ALL VALUES (front end is handling this)
@app.route('/mysql/createNewPatient', methods=['POST'])
def createNewPatient():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        data = request.json
        sql = "INSERT INTO Patient (pFirstName, pLastName, dOB, height, weight, sport, gender, thirdPartyID) VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"
        val = (data['firstName'], data['lastName'], data['dOB'], data['height'], data['weight'], data['sport'], data['gender'], data['thirdPartyID'])
        mycursor.execute(sql, val)
        mydb.commit()

        pID = mycursor.lastrowid
        returnPatient = {"pID": pID, "firstName": data['firstName'], "lastName": data['lastName'], "dOB": str(data['dOB']), "height": data['height'], 
            "weight": data['weight'], "sport": data['sport'], "gender": data['gender'], "thirdPartyID": data['thirdPartyID']}
        return jsonify(returnPatient)

@app.route('/mysql/updatePatient', methods=['PUT'])
def updatePatient():
    if request.method == 'PUT':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        data = request.json
        sql = "UPDATE Patient SET " + updatePatientHelper(data)
        print(sql)
        mycursor.execute(sql)
        mydb.commit()

        pID = [(data['pID'])]
        sql = "SELECT * FROM Patient WHERE pID=%s"
        mycursor.execute(sql, pID)
        myresult = mycursor.fetchall()

        returnList = {}
        # Get the patient we are looking for
        for x in myresult:
            returnList = {"pID": x[0], "firstName": x[1], "lastName": x[2], "dOB": str(x[3]), "height": x[4], "weight": x[5], 
                "sport": x[6], "gender": x[7], "thirdPartyID": x[8]}
        return jsonify(returnList)

def updatePatientHelper(data):
    sql = ""
    firstBool=lastBool=dBool=hBool=wBool=sBool=gBool = False
    if 'firstName' in data:
        firstBool = True
        sql += "pFirstName='" + data['firstName'] + "'"
    if 'lastName' in data:
        if firstBool == True:
            sql += ", "
        lastBool = True
        sql += "pLastName='" + data['lastName'] + "'"
    if 'dOB' in data:
        if (firstBool or lastBool) == True:
            sql += ", "
        dBool = True
        sql += "dOB='" + str(data['dOB']) + "'"
    if 'height' in data:
        if (firstBool or lastBool or dBool) == True:
            sql += ", "
        hBool = True
        sql += "height=" + str(data['height'])
    if 'weight' in data:
        if (firstBool or lastBool or dBool or hBool) == True:
            sql += ", "
        wBool = True
        sql += "weight=" + str(data['weight'])
    if 'sport' in data:
        if (firstBool or lastBool or dBool or hBool or wBool) == True:
            sql += ", "
        sBool = True
        sql += "sport='" + data['sport']  + "'"
    if 'gender' in data:
        if (firstBool or lastBool or dBool or hBool or wBool or sBool) == True:
            sql += ", "
        gBool = True
        sql += "gender='" + data['gender'] + "'"
    if 'thirdPartyID' in data:
        if (firstBool or lastBool or dBool or hBool or wBool or sBool or gBool) == True:
            sql += ", "
        sql += "thirdPartyID='" + data['thirdPartyID'] + "'"

    sql += " WHERE pID=" + str(data['pID'])
    return sql


@app.route('/mysql/deletePatient', methods=['DELETE'])
def deletePatient():
    if request.method == 'DELETE':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        data = request.json
        sql = "Delete from Patient where pID = %s"
        val = [(data["pID"])]
        mycursor.execute(sql, val) 
        mydb.commit()

        sql = "SELECT * FROM Patient WHERE pID=%s"
        mycursor.execute(sql,val)
        patientExist = mycursor.fetchall()

        if len(patientExist) == 0:
            return jsonify({"Status": True})
        else:
            # make sure you pass in a valid pID
            return jsonify({"Status": False})


# --------------------------------------------------------------- INCIDENT --------------------------------------------------------------
@app.route('/mysql/getIncident', methods=['GET'])
def getIncident():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        data = request.args.get('ID')
        sql = "SELECT * FROM Incident WHERE iID=%s"
        val = [(data)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        # Get the Incident we are looking for
        incident = OrderedDict()
        for x in myresult:
            incident = OrderedDict({"iID": x[0], "iName": x[1], "iDate": str(x[2]), "iNotes": x[3], "pID": x[4], "tests": []})

        # Get the Tests that that patient has
        sql = "SELECT * FROM Test WHERE iID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            incident['tests'].append(OrderedDict({"tID": x[0], "tDate": str(x[2]), "tName": x[1], "iID": x[4]}))

        returnList.append(incident)
        return jsonify(returnList)

# RIGHT NOW, YOU MUST INPUT ALL VALUES (front end is handling this)
@app.route('/mysql/createIncident', methods=['POST'])
def createIncident():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO Incident (iName, iDate, iNotes, pID) VALUES(%s, %s, %s, %s)"
        val = (data['iName'], data['iDate'], data['iNotes'], data['pID'])
        mycursor.execute(sql, val)
        mydb.commit()

        iID = mycursor.lastrowid
        returnIncident = {"iID": iID, "iName": data['iName'], "iDate": str(data['iDate']), "iNotes": data['iNotes'], "pID": data['pID']}
        return jsonify(returnIncident)

@app.route('/mysql/updateIncident', methods=['PUT'])
def updateIncident():
    if request.method == 'PUT':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "UPDATE Incident SET " + updateIncidentHelper(data)
        print(sql) 
        mycursor.execute(sql)
        mydb.commit()

        iID = [(data['iID'])]
        sql = "SELECT * FROM Incident WHERE iID=%s"
        mycursor.execute(sql, iID)
        myresult = mycursor.fetchall()

        returnList = {}
        # Get the incident we are looking for
        for x in myresult:
            returnList = {"iID": x[0], "iName": x[1], "iDate": str(x[2]), "iNotes": x[3], "pID": x[4]}
        return jsonify(returnList)

def updateIncidentHelper(data):
    sql = ""
    nameBool=dateBool = False
    if 'iName' in data:
        nameBool = True
        sql += "iName='" + data['iName'] + "'"
    if 'iDate' in data:
        if nameBool == True:
            sql += ", "
        dateBool = True
        sql += "iDate='" + str(data['iDate']) + "'"
    if 'iNotes' in data:
        if (nameBool or dateBool) == True:
            sql += ", "
        dBool = True
        sql += "iNotes='" + str(data['iNotes']) + "'"

    sql += " WHERE iID=" + str(data['iID'])
    return sql

@app.route('/mysql/deleteIncident', methods=['DELETE'])
def deleteIncident():
    if request.method == 'DELETE':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "Delete from Incident where iID = %s"
        val = [(data["iID"])]
        mycursor.execute(sql, val) 
        mydb.commit()

        sql = "SELECT * FROM Incident WHERE iID=%s"
        mycursor.execute(sql,val)
        patientExist = mycursor.fetchall()

        if len(patientExist) == 0:
            return jsonify({"Status": True})
        else:
            # make sure you pass in a valid iID
            return jsonify({"Status": False})


# ---------------------------------------------------------------  TEST ------------------------------------------------------------------

@app.route('/mysql/getTest', methods=['GET'])
def getTest():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.args.get('ID')
        sql = "SELECT * FROM Test WHERE tID=%s"
        val = [(data)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        # Get the Incident we are looking for
        test = OrderedDict()
        for x in myresult:
            test = OrderedDict({"tID": x[0], "tName": x[1], "tDate": str(x[2]), "tNotes": x[3], "iID": x[4]})

        # Get the ReactiveTests that that patient has
        sql = "SELECT * FROM ReactiveTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult != []:
            test["reactive"] = {}
        for x in myresult:
            test['reactive'] = {"rID": x[0], "fTime": x[1], "bTime": x[2], "lTime": x[3], "rTime": x[4], "mTime": x[5], "tID": x[6]}

        returnList.append(test)
        return jsonify(returnList)

# RIGHT NOW, YOU MUST INPUT ALL VALUES (front end is handling this)
@app.route('/mysql/createTest', methods=['POST'])
def createTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO Test (tName, tDate, tNotes, iID) VALUES(%s, %s, %s, %s)"
        val = (data['tName'], data['tDate'], data['tNotes'], data['iID'])
        mycursor.execute(sql, val)
        mydb.commit()

        tID = mycursor.lastrowid
        returnTest = {"tID": tID, "tName": data['tName'], "tDate": str(data['tDate']), "tNotes": data['tNotes'], "iID": data['iID']} #, "dynamic": {}, "static": {}, "reactive": {}}
        return jsonify(returnTest)

# --------------------------------------------------------------- REACTIVE TEST ------------------------------------------------------------------

@app.route('/mysql/createReactiveTest', methods=['POST'])
def createReactiveTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO ReactiveTest (fTime, bTime, lTime, rTime, mTime, tID) VALUES(%s, %s, %s, %s, %s, %s)"
        val = (data['fTime'], data['bTime'], 
               data['lTime'], data['rTime'], data['mTime'], data['tID'])
        mycursor.execute(sql, val)
        mydb.commit()
        
        rID = mycursor.lastrowid
        returnRTest = {"rID": rID, "fTime": data['fTime'], "bTime": data['bTime'], "lTime": data['lTime'], "rTime": data['rTime'], "mTime": data['mTime'], "tID": data['tID']}
        return jsonify(returnRTest)

# --------------------------------------------------------------- DYNAMIC TEST ------------------------------------------------------------------

@app.route('/mysql/createDynamicTest', methods=['POST'])
def createDynamicTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = """INSERT INTO DynamicTest (t1Duration, t1TurnSpeed, t1MLSway, 
                                        t2Duration, t2TurnSpeed, t2MLSway, 
                                        t3Duration, t3TurnSpeed, t3MLSway,
                                        dMax, dMin, dMean, dMedian,
                                        tsMax, tsMin, tsMean, tsMedian,
                                        mlMax, mlMin, mlMean, mlMedian, tID) 
                                        VALUES(%s, %s, %s, 
                                               %s, %s, %s, 
                                               %s, %s, %s, 
                                               %s, %s, %s, %s,
                                               %s, %s, %s, %s,
                                               %s, %s, %s, %s, %s)"""
        val = (data['t1Duration'], data['t1TurnSpeed'], data['t1MLSway'], 
               data['t2Duration'], data['t2TurnSpeed'], data['t2MLSway'], 
               data['t3Duration'], data['t3TurnSpeed'], data['t3MLSway'],

               data['dMax'], data['dMin'], data['dMean'], data['dMedian'],
               data['tsMax'], data['tsMin'], data['tsMean'], data['tsMedian'],
               data['mlMax'], data['mlMin'], data['mlMean'], data['mlMedian'],
               data['tID'])
        mycursor.execute(sql, val)
        mydb.commit()
        
        dID = mycursor.lastrowid
        returnRTest = {"dID": dID, 
        "t1Duration": data['t1Duration'], "t1TurnSpeed": data['t1TurnSpeed'], "t1MLSway": data['t1MLSway'], 
        "t2Duration": data['t2Duration'], "t2TurnSpeed": data['t2TurnSpeed'], "t2MLSway": data['t2MLSway'], 
        "t3Duration": data['t3Duration'], "t3TurnSpeed": data['t3TurnSpeed'], "t3MLSway": data['t3MLSway'], 
        
        "dMax": data['dMax'], "dMin": data['dMin'], "dMean": data['dMean'], "dMedian": data['dMedian'],
        "tsMax": data['tsMax'], "tsMin": data['tsMin'], "tsMean": data['tsMean'], "tsMedian": data['tsMedian'],
        "mlMax": data['mlMax'], "mlMin": data['mlMin'], "mlMean": data['mlMean'], "mlMedian": data['mlMedian'],

        "tID": data['tID']}
        return jsonify(returnRTest)


# --------------------------------------------------------------- STATIC TEST -------------------------------------------------------------------

@app.route('/mysql/createStaticTest', methods=['POST'])
def createStaticTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO StaticTest (tlSolidML, tlFoamML, slSolidML, slFoamML, tandSolidML, tandFoamML, tID) VALUES(%s, %s, %s, %s, %s, %s, %s)"
        val = (data['tlSolidML'], data['tlFoamML'], 
               data['slSolidML'], data['slFoamML'], 
               data['tandSolidML'], data['tandFoamML'], data['tID'])
        mycursor.execute(sql, val)
        mydb.commit()
        
        sID = mycursor.lastrowid
        returnRTest = {"sID": sID, 
        "tlSolidML": data['tlSolidML'], "tlFoamML": data['tlFoamML'], 
        "slSolidML": data['slSolidML'], "slFoamML": data['slFoamML'], 
        "tandSolidML": data['tandSolidML'], "tandFoamML": data['tandFoamML'], "tID": data['tID']}
        return jsonify(returnRTest)

# --------------------------------------------------------------- EXPORTING ---------------------------------------------------------------------

@app.route('/mysql/exportSinglePatient', methods=['GET'])
def exportSinglePatient():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        data = request.args.get('ID')
        sql = "SELECT thirdPartyID FROM Patient WHERE pID=%s;"
        val = [(data)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        for x in myresult:
            returnList.append({"thirdPartyID": x[0], "incidents": []})

        sql = "select i.iName, i.iDate, i.iNotes, t.tDate, rt.mTime, i.iID from Incident as i left join Test as t on i.iID=t.iID left join ReactiveTest as rt on t.tID=rt.tID where i.pID=%s;"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        # Get the Incidents we are looking for
        incident = {}
        for x in myresult:
            incident = {"iName": x[0], "iDate": str(x[1]), "iNotes": x[2], "iID": x[5], "tests": []}
            # hande the case that an incident may have multiple tests
            flag = False
            for i in returnList[0]['incidents']:
                if i["iID"] == x[5]:
                    # If the desired iID is found, append a new test to its tests list
                    i['tests'].append({"tDate": str(x[3]), "reactive": {"mTime": x[4]}})
                    flag = True
                    break
            
            if flag == False:
                if(str(x[3]) != "None"):
                    incident['tests'].append({"tDate": str(x[3]), "reactive": {"mTime": x[4]}})
                    returnList[0]['incidents'].append(incident)
                else:
                    returnList[0]['incidents'].append(incident)
        
        return jsonify(returnList)
# --------------------------------------------------------------- TEST SCRIPTS ------------------------------------------------------------------

@app.route('/timeToStability', methods=['POST'])
def timeToStability():
    dataAcc = request.json.get('dataAcc')
    dataRot = request.json.get('dataRot')
    fs = request.json.get('fs')

    accNorm = np.linalg.norm(dataAcc, axis=0)
    rotNorm = np.linalg.norm(dataRot, axis=0)

    b, a = signal.butter(2, 10 / (fs / 2))

    #Foot Movement: 9.81*1.07; % based on El-Gohary Threshold for foot movement
    qaF = signal.filtfilt(b, a, accNorm) < 9.81*1.07
    #Rotational Foot Movement: 14/180*pi; % based on El-Gohary Threshold for foot movement* this should be 7 deg/sec?
    qrf = signal.filtfilt(b, a, rotNorm) < 14/180*np.pi
    qf = np.logical_and(qaF, qrf)

    #find t0
    peaks, _ = signal.find_peaks(np.flip(accNorm[fs * 3:]), height=14.6)

    movementF = peaks[-1]
    flipQf = qf[::-1]

    # find the index of release point
    release = 0
    for i, j in enumerate(flipQf[movementF:]):
        if (j == 1):
            release = i
            break

    # adding 2 accounts for index differences between matlab and python
    release = movementF+release + 2
    t0 = len(accNorm)-release

    #find TTS with adjustment for indexing differences
    movementReg = len(accNorm) - (movementF + 2)

    # find the index of release point
    EndTTS = 0
    for i, j in enumerate(qf[movementReg:]):
        if (j == 1):
            EndTTS = i
            break

    EndTTS = EndTTS+movementReg + 2

    TTS = (EndTTS - t0)/fs

    return jsonify(t0 = int(t0), EndTTS = int(EndTTS), TTS = TTS)

@app.route('/sway', methods=['POST'])
def sway():
    dataAcc = request.json.get('dataAcc')
    dataRot = request.json.get('dataRot')
    fs = request.json.get('fs')

    Fc = 3.5

    # Filters[data] data using butterworth filter with specified [order] order,
    # [Fc] cuttoff frequency and [Fs] sampling frequency.

    [b,a] = signal.butter(4,(Fc/(fs/2)))
    Sway_ml = signal.filtfilt(b,a, dataAcc[2])/9.81 # z-direction
    Sway_ap = signal.filtfilt(b,a, dataAcc[1])/9.81 # y-direction
    Sway_v = signal.filtfilt(b,a, dataAcc[0])/9.81 # x-direction

    rms_ml = rms(Sway_ml)
    rms_ap = rms(Sway_ap)
    rms_v = rms(Sway_v)

    return jsonify(rmsMl = rms_ml, rmsAp = rms_ap, rmsV = rms_v)

# root mean square
def rms(arr):
    square = 0
    mean = 0.0
    root = 0.0
     
    #Calculate square
    for i in range(0,len(arr)):
        square += (arr[i]**2)
     
    #Calculate Mean 
    mean = (square / (float)(len(arr)))
     
    #Calculate Root
    return np.sqrt(mean)


# --------------------------------------------------------------- SERVER ----------------------------------------------------------------

# Run the developement server
# if __name__ == '__main__':
#     app.run()

# This is to run as a WSGI server, which essentially means
# no default logging or hot reload. comment out the  development server code
# above then uncomment the code below.
# You will need to install waitress with this command
# python -m pip install waitress

if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=8000)


# CHANGE THE DAMN PORT BACK TO 8000 for updating this
# CHANGE THE DAMN PORT BACK TO 8111 for testing this
# DELETE THE TEST PORT AT THE END OF THE YEAR