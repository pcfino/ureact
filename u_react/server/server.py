import json
import datetime
import numpy as np
import math
from scipy import signal
from flask import Flask, jsonify, request, Response
from mysql import connector
from waitress import serve
from collections import OrderedDict
import subprocess
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

import cognito

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

cognitoSecret =CONFID['cognito_secret']

app = Flask(__name__)
app.json.sort_keys = False # make the order same as construction 

import boto3

client_idp = boto3.client('cognito-idp')
CIPW = cognito.CognitoIdentityProviderWrapper(cognito_idp_client=client_idp, user_pool_id = 'us-west-1_zdY5m4TBN', client_id= '4i7eebuhb2feg2kl01lub9e3uv', client_secret = cognitoSecret)

currentUser = None

# ctrl-shift U - uppercase

# --------------------------------------------------------------- PATIENT ---------------------------------------------------------------

@app.route('/mysql/getAllPatients', methods=['GET'])
def getAllPatients():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        data = request.args.get('ID')
        val = [(data)]
        sql = "SELECT * FROM Patient where orgID=%s"
        mycursor.execute(sql, val)
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
        sql = "INSERT INTO Patient (pFirstName, pLastName, dOB, height, weight, sport, gender, thirdPartyID, orgID) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        val = (data['firstName'], data['lastName'], data['dOB'], data['height'], data['weight'], data['sport'], data['gender'], data['thirdPartyID'], data['orgID'])
        mycursor.execute(sql, val)
        mydb.commit()

        pID = mycursor.lastrowid
        returnPatient = {"pID": pID, "firstName": data['firstName'], "lastName": data['lastName'], "dOB": str(data['dOB']), "height": data['height'], 
            "weight": data['weight'], "sport": data['sport'], "gender": data['gender'], "thirdPartyID": data['thirdPartyID'], "orgID": data['orgID']}
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

@app.route('/mysql/getBaseline', methods=['GET'])
def getBaseline():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        data = request.args.get('ID')
        sql = "select * from Test as t join Incident as i on t.iID=i.iID where tID=%s"
        val = [(data)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        pID = 0
        for x in myresult:
            pID = x[9]
            break

        sql = "select * from Incident where iName = 'Baseline' and pID=%s order by iDate desc"
        val = [(pID)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        iID = 0
        # get the iID
        for x in myresult:
            iID = x[0]
            break

        # Get the Tests that that patient has
        sql = "SELECT * FROM Test WHERE iID=%s"
        mycursor.execute(sql, [(iID)])
        myresult = mycursor.fetchall()
        tID = 0
        for x in myresult:
            tID = x[0]
            break

        if tID == 0:
            return jsonify(returnList)
        
        # Get the ReactiveTests that the patient has
        val = [(tID)]
        sql = "SELECT * FROM ReactiveTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        test = OrderedDict()
        if myresult == []:
            test['reactiveTest'] = {}
        else:
            for x in myresult:
                test['reactiveTest'] = {"rID": x[0], "fTime": x[1], "bTime": x[2], "lTime": x[3], "rTime": x[4], "mTime": x[5], "tID": x[6], "administeredBy": x[7]}

        # Get the DynamicTest that the patient has
        sql = "SELECT * FROM DynamicTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult == []:
            test["dynamicTest"] = {}
        else:
            for x in myresult:
                test['dynamicTest'] = {"dID": x[0], 
                                "t1Duration": x[1], "t1TurnSpeed": x[2], "t1MLSway": x[3], 
                                "t2Duration": x[4], "t2TurnSpeed": x[5], "t2MLSway": x[6], 
                                "t3Duration": x[7], "t3TurnSpeed": x[8], "t3MLSway": x[9], 
                                    
                                "dMax": x[10], "dMin": x[11], "dMean": x[12], "dMedian": x[13],
                                "tsMax": x[14], "tsMin": x[15], "tsMean": x[16], "tsMedian": x[17],
                                "mlMax": x[18], "mlMin": x[19], "mlMean": x[20], "mlMedian": x[21],

                                "tID": x[22], 
                                "administeredBy": x[23]}

        # Get the StaticTests that the patient has
        sql = "SELECT * FROM StaticTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult == []:
            test['staticTest'] = {}
        else:
            for x in myresult:
                test['staticTest'] = {"sID": x[0], 
                                "tlSolidML": x[1], "tlFoamML": x[2], 
                                "slSolidML": x[3], "slFoamML": x[4], 
                                "tandSolidML": x[5], "tandFoamML": x[6], "tID": x[7], "administeredBy": x[8]}  
        returnList.append(test)
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
            test['reactive'] = {"rID": x[0], "fTime": x[1], "bTime": x[2], "lTime": x[3], "rTime": x[4], "mTime": x[5], "tID": x[6], "administeredBy": x[7]}

        returnList.append(test)
        return jsonify(returnList)

@app.route('/mysql/getAllTests', methods=['GET'])
def getAllTests():
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

        # Get the ReactiveTests that the patient has
        sql = "SELECT * FROM ReactiveTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult == []:
            test['reactiveTest'] = {}
        else:
            for x in myresult:
                test['reactiveTest'] = {"rID": x[0], "fTime": x[1], "bTime": x[2], "lTime": x[3], "rTime": x[4], "mTime": x[5], "tID": x[6], "administeredBy": x[7]}

        # Get the DynamicTest that the patient has
        sql = "SELECT * FROM DynamicTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult == []:
            test["dynamicTest"] = {}
        else:
            for x in myresult:
                test['dynamicTest'] = {"dID": x[0], 
                                "t1Duration": x[1], "t1TurnSpeed": x[2], "t1MLSway": x[3], 
                                "t2Duration": x[4], "t2TurnSpeed": x[5], "t2MLSway": x[6], 
                                "t3Duration": x[7], "t3TurnSpeed": x[8], "t3MLSway": x[9], 
                                    
                                "dMax": x[10], "dMin": x[11], "dMean": x[12], "dMedian": x[13],
                                "tsMax": x[14], "tsMin": x[15], "tsMean": x[16], "tsMedian": x[17],
                                "mlMax": x[18], "mlMin": x[19], "mlMean": x[20], "mlMedian": x[21],

                                "tID": x[22],
                                "administeredBy": x[23]}

        # Get the StaticTests that the patient has
        sql = "SELECT * FROM StaticTest WHERE tID=%s"
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        if myresult == []:
            test['staticTest'] = {}
        else:
            for x in myresult:
                test['staticTest'] = {"sID": x[0], 
                                "tlSolidML": x[1], "tlFoamML": x[2], 
                                "slSolidML": x[3], "slFoamML": x[4], 
                                "tandSolidML": x[5], "tandFoamML": x[6], "tID": x[7], "administeredBy": x[8]}        

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

@app.route('/mysql/updateTest', methods=['PUT'])
def updateTest():
    if request.method == 'PUT':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "UPDATE Test SET " + updateTestHelper(data)
        print(sql) 
        mycursor.execute(sql)
        mydb.commit()

        tID = [(data['tID'])]
        sql = "SELECT * FROM Test WHERE tID=%s"
        mycursor.execute(sql, tID)
        myresult = mycursor.fetchall()

        returnList = {}
        # Get the incident we are looking for
        for x in myresult:
            returnList = {"tID": x[0], "tName": x[1], "tDate": str(x[2]), "tNotes": x[3], "iID": x[4]}
        return jsonify(returnList)

def updateTestHelper(data):
    sql = ""
    nameBool=dateBool = False
    if 'tName' in data:
        nameBool = True
        sql += "tName='" + data['tName'] + "'"
    if 'tDate' in data:
        if nameBool == True:
            sql += ", "
        dateBool = True
        sql += "tDate='" + str(data['tDate']) + "'"
    if 'tNotes' in data:
        if (nameBool or dateBool) == True:
            sql += ", "
        dBool = True
        sql += "tNotes='" + str(data['tNotes']) + "'"

    sql += " WHERE tID=" + str(data['tID'])
    return sql

@app.route('/mysql/deleteTest', methods=['DELETE'])
def deleteTest():
    if request.method == 'DELETE':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "Delete from Test where tID = %s"
        val = [(data["tID"])]
        mycursor.execute(sql, val) 
        mydb.commit()

        sql = "SELECT * FROM Test WHERE tID=%s"
        mycursor.execute(sql,val)
        testExist = mycursor.fetchall()

        if len(testExist) == 0:
            return jsonify({"Status": True})
        else:
            # make sure you pass in a valid iID
            return jsonify({"Status": False})

# --------------------------------------------------------------- REACTIVE TEST ------------------------------------------------------------------

@app.route('/mysql/createReactiveTest', methods=['POST'])
def createReactiveTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO ReactiveTest (fTime, bTime, lTime, rTime, mTime, tID, administeredBy) VALUES(%s, %s, %s, %s, %s, %s, %s)"
        val = (data['fTime'], data['bTime'], 
               data['lTime'], data['rTime'], data['mTime'], data['tID'], data['administeredBy'])
        mycursor.execute(sql, val)
        mydb.commit()
        
        rID = mycursor.lastrowid
        returnRTest = {"rID": rID, "fTime": data['fTime'], "bTime": data['bTime'], "lTime": data['lTime'], "rTime": data['rTime'], "mTime": data['mTime'], "tID": data['tID'], 
            "administeredBy": data['administeredBy']}
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
                                        mlMax, mlMin, mlMean, mlMedian, tID, administeredBy)
                                        VALUES(%s, %s, %s, 
                                               %s, %s, %s, 
                                               %s, %s, %s, 
                                               %s, %s, %s, %s,
                                               %s, %s, %s, %s,
                                               %s, %s, %s, %s, %s, %s)"""
        val = (data['t1Duration'], data['t1TurnSpeed'], data['t1MLSway'], 
               data['t2Duration'], data['t2TurnSpeed'], data['t2MLSway'], 
               data['t3Duration'], data['t3TurnSpeed'], data['t3MLSway'],

               data['dMax'], data['dMin'], data['dMean'], data['dMedian'],
               data['tsMax'], data['tsMin'], data['tsMean'], data['tsMedian'],
               data['mlMax'], data['mlMin'], data['mlMean'], data['mlMedian'],
               data['tID'], data['administeredBy'])
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

        "tID": data['tID'], "administeredBy": data['administeredBy']}
        return jsonify(returnRTest)


# --------------------------------------------------------------- STATIC TEST -------------------------------------------------------------------

@app.route('/mysql/createStaticTest', methods=['POST'])
def createStaticTest():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
 
        data = request.json
        sql = "INSERT INTO StaticTest (tlSolidML, tlFoamML, slSolidML, slFoamML, tandSolidML, tandFoamML, tID, administeredBy) VALUES(%s, %s, %s, %s, %s, %s, %s, %s)"
        val = (data['tlSolidML'], data['tlFoamML'], 
               data['slSolidML'], data['slFoamML'], 
               data['tandSolidML'], data['tandFoamML'], data['tID'], data['administeredBy'])
        mycursor.execute(sql, val)
        mydb.commit()
        
        sID = mycursor.lastrowid
        returnRTest = {"sID": sID, 
        "tlSolidML": data['tlSolidML'], "tlFoamML": data['tlFoamML'], 
        "slSolidML": data['slSolidML'], "slFoamML": data['slFoamML'], 
        "tandSolidML": data['tandSolidML'], "tandFoamML": data['tandFoamML'], "tID": data['tID'], "administeredBy": data['administeredBy']}
        return jsonify(returnRTest)

# --------------------------------------------------------------- IMU DATA ---------------------------------------------------------------------
@app.route('/mysql/insertIMU', methods=['POST'])
def insertIMU():
    if request.method == 'POST':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        id_val = 0
        type_of_id = ""
        data = request.json

        # Check if the "id" field is present
        if "dID" in data:
            id_val = data["dID"]
            type_of_id = "dID"
            data.pop(type_of_id)
        elif "rID" in data:
            id_val = data["rID"]
            type_of_id = "rID"
            data.pop(type_of_id)
        elif "sID" in data:
            id_val = data["sID"]
            type_of_id = "sID"
            data.pop(type_of_id)
        else:
            return jsonify({"Status": False})

        sql = "INSERT INTO IMUData (imuData, " + type_of_id + ") VALUES (%s, %s)"
        result_json_str = json.dumps(data)
        val = [result_json_str, id_val]

        try:
            mycursor.execute(sql, val)
            mydb.commit()
        except connector.Error as err:
            print("MySQL Cursor Error:", err)
            return jsonify({"Status": False})

        return jsonify({"Status": True})



@app.route('/mysql/getIMU', methods=['GET'])
def getIMU():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        rID = ""
        sID = ""
        dID = ""
        if request.args.get('rID') != None:
            rID = request.args.get('rID')
        if request.args.get('sID') != None:
            sID = request.args.get('sID')
        if request.args.get('dID') != None:
            dID = request.args.get('dID')

        sql = "SELECT * FROM IMUData WHERE "
        # start by trying to add an rID
        if rID != "":
            sql += "rID=" + rID

        # now lets see if we can add an sID
        if sID != "":
            # check if we added an rID or not
            if rID != "":
                sql += " or sID=" + sID
            else:
                sql += "sID=" + sID
        
        # finally try to add a dID
        if dID != "":
            # check did we add an sID and an rID
            if sID != "" and rID != "":
                sql += " or dID=" + dID
            elif sID == "" and rID != "":
                sql += " or dID=" + dID
            elif sID != "" and rID == "":
                sql += " or dID=" + dID
            else:
                sql += "dID=" + dID
        
        mycursor.execute(sql)
        myresult = mycursor.fetchall()

        returnList = []
        for x in myresult:
            parsed_data = json.loads(x[1])
            returnList.append({"imuID": x[0], "imuData": parsed_data, "dID": x[2], "rID": x[3], "sID": x[4]})
        return jsonify(returnList)

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

        sql = """select i.iName, i.iDate, i.iNotes, t.tDate, 
	             rt.mTime, rt.tID,
                 i.iID,
                 rt.fTime, rt.bTime, rt.lTime, rt.rTime
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join ReactiveTest as rt on t.tID=rt.tID
                 where i.pID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        # Get the Incidents we are looking for and their reactive tests
        incident = {}
        pid = int(data)
        for x in myresult:
            incident = {"iName": x[0], "iDate": str(x[1]), "iNotes": x[2], "iID": x[6], "pID": pid, "tests": []}
            # hande the case that an incident may have multiple tests
            flag = False

            # check if a test has been made yet for that incident, it will be none if there are no tests for that incident
            if x[5] is None:
                # check if there is any incident that has been input yet, if not, and there is no test with that incident, input the incident
                if returnList[0]['incidents']:
                    if x[6] not in returnList[0]['incidents']:
                        # no test taken yet, does the incident exist in the list
                        returnList[0]['incidents'].append(incident)
            
            #  check if in the incidents part of the json, that iID is not already there
            for i in returnList[0]['incidents']:
                if i["iID"] == x[6]:
                    # If the desired iID is found, append a new test to its tests list
                    # if the test is none, append empty test
                    if x[5] is None:
                        i['tests'].append({"tDate": str(x[3]), "tID": x[5], "reactive": {}})
                    else:
                        i['tests'].append({"tDate": str(x[3]), "tID": x[5], "reactive": {"mTime": x[4], "fTime": x[7], "bTime": x[8], "lTime": x[9], "rTime": x[10]}})
                    flag = True
                    break
            
            # if we did not add a test to an existing incident
            if flag == False:
                # if there is a test to add
                if x[5] is not None:
                    incident['tests'].append({"tDate": str(x[3]), "tID": x[5], "reactive": {"mTime": x[4], "fTime": x[7], "bTime": x[8], "lTime": x[9], "rTime": x[10]}})
                    returnList[0]['incidents'].append(incident)
                else:
                    returnList[0]['incidents'].append(incident)
            
        # Get the Incidents we are looking for and their static tests
        incident = {}
        sql = """select i.iID, t.tDate, st.tID, 
                 st.tlSolidML, st.tlFoamML, st.slSolidML, st.slFoamML, st.tandSolidML, st.tandFoamML
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join StaticTest as st on t.tID=st.tID
                 where i.pID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            #  check if in the incidents part of the json, that iID is not already there
            for i in returnList[0]['incidents']:
                if x[2] is None:
                    # is there is no static test yet, append this
                    if i["iID"] == x[0]: #iID
                        i['tests'].append({"tDate": str(x[1]), "tID": x[2], "static": {}})
                        continue
                if i["iID"] == x[0]:
                    # If the desired iID is found, append a new test to its tests list
                    i['tests'].append({"tDate": str(x[1]),"tID": x[2], "static": {"tlSolidML": x[3], "tlFoamML": x[4],
                                                                      "slSolidML": x[5], "slFoamML": x[6],
                                                                      "tandSolidML": x[7], "tandFoamML": x[8]}})
                    break

        # Get the Incidents we are looking for and their dynamic tests
        sql = """select i.iID, t.tDate, dt.tID,
                        dt.dMax, dt.dMin, dt.dMean, dt.dMedian, 
                        dt.tsMax, dt.tsMin, dt.tsMean, dt.tsMedian, 
                        dt.mlMax, dt.mlMin, dt.mlMean, dt.mlMedian
                        from Incident as i left join Test as t on i.iID=t.iID
                        left join DynamicTest as dt on t.tID=dt.tID
                        where i.pID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            #  check if in the incidents part of the json, that iID is not already there
            for i in returnList[0]['incidents']:
                if x[2] is None:
                    # is there is no static test yet, append this
                    if i["iID"] == x[0]: #iID
                        i['tests'].append({"tDate": str(x[1]), "tID": x[2], "dynamic": {}})
                        continue
                if i["iID"] == x[0]:
                    # If the desired iID is found, append a new test to its tests list
                    i['tests'].append({"tDate": str(x[1]), "tID": x[2], "dynamic": {"dMax": x[3], "dMin": x[4], "dMean": x[5], "dMedian": x[6],
                                                                       "tsMax": x[7], "tsMin": x[8], "tsMean": x[9], "tsMedian": x[10],
                                                                       "mlMax": x[11], "mlMin": x[12], "mlMean": x[13], "mlMedian": x[14],}})
                    break
        
        return jsonify(returnList)

@app.route('/mysql/exportSingleIncident', methods=['GET'])
def exportSingleIncident():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        pID = request.args.get('pID')
        iID = request.args.get('iID')
        sql = "SELECT thirdPartyID FROM Patient WHERE pID=%s;"
        val = [(pID)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        thirdPartyID = ""
        for x in myresult:
            thirdPartyID = x[0]

        sql = """select i.iName, i.iDate, i.iNotes, i.iID, 
                        t.tDate, rt.tID,
                        rt.mTime, rt.fTime, rt.bTime, rt.lTime, rt.rTime
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join ReactiveTest as rt on t.tID=rt.tID
                 where i.pID=%s and i.iID=%s;"""
        val = [(pID), iID]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        # Get the Incident we are looking for and its reactive tests
        incident = {}
        pid = int(pID)
        for x in myresult:
            incident = {"thirdPartyID": thirdPartyID, "iName": x[0], "iDate": str(x[1]), "iNotes": x[2], "iID": x[3], "pID": pid, "tests": []}
            returnList.append(incident)
            break
        
        for x in myresult:
            # if there is a test to add
            if x[5] is not None:
                returnList[0]['tests'].append({"tDate": str(x[4]), "tID": x[5], "reactive": {"mTime": x[6], "fTime": x[7], "bTime": x[8], "lTime": x[9], "rTime": x[10]}})
            
            
        # Get the Incident we are looking for and the static tests
        incident = {}
        sql = """select t.tDate, st.tID, 
                 st.tlSolidML, st.tlFoamML, st.slSolidML, st.slFoamML, st.tandSolidML, st.tandFoamML
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join StaticTest as st on t.tID=st.tID
                 where i.pID=%s and i.iID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            if x[1] is not None:
                # If the desired tID is found, append a new test to its tests list
                returnList[0]['tests'].append({"tDate": str(x[0]),"tID": x[1], "static": {"tlSolidML": x[2], "tlFoamML": x[3],
                                                                    "slSolidML": x[4], "slFoamML": x[5],
                                                                    "tandSolidML": x[6], "tandFoamML": x[7]}})

        # Get the Incidents we are looking for and their dynamic tests
        sql = """select t.tDate, dt.tID,
                        dt.dMax, dt.dMin, dt.dMean, dt.dMedian, 
                        dt.tsMax, dt.tsMin, dt.tsMean, dt.tsMedian, 
                        dt.mlMax, dt.mlMin, dt.mlMean, dt.mlMedian
                        from Incident as i left join Test as t on i.iID=t.iID
                        left join DynamicTest as dt on t.tID=dt.tID
                        where i.pID=%s and i.iID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            #  check if in the incidents part of the json, that iID is not already there
            if x[1] is not None:
                returnList[0]['tests'].append({"tDate": str(x[0]), "tID": x[1], "dynamic": {"dMax": x[2], "dMin": x[3], "dMean": x[4], "dMedian": x[5],
                                                                       "tsMax": x[6], "tsMin": x[7], "tsMean": x[8], "tsMedian": x[9],
                                                                       "mlMax": x[10], "mlMin": x[11], "mlMean": x[12], "mlMedian": x[13],}})
        
        return jsonify(returnList)

@app.route('/mysql/exportSingleTest', methods=['GET'])
def exportSingleTest():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()
        
        pID = request.args.get('pID')
        iID = request.args.get('tID')
        sql = "SELECT thirdPartyID FROM Patient WHERE pID=%s;"
        val = [(pID)]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        returnList = []
        thirdPartyID = ""
        for x in myresult:
            thirdPartyID = x[0]

        sql = """select i.iName, i.iDate, i.iNotes, i.iID, 
                        t.tDate, rt.tID,
                        rt.mTime, rt.fTime, rt.bTime, rt.lTime, rt.rTime
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join ReactiveTest as rt on t.tID=rt.tID
                 where i.pID=%s and t.tID=%s;"""
        val = [(pID), iID]
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()

        # Get the Incident we are looking for and its reactive tests
        incident = {}
        pid = int(pID)
        for x in myresult:
            incident = {"thirdPartyID": thirdPartyID, "iName": x[0], "iDate": str(x[1]), "iNotes": x[2], "iID": x[3], "pID": pid, "tests": []}
            returnList.append(incident)
            break
        
        for x in myresult:
            # if there is a test to add
            if x[5] is not None:
                returnList[0]['tests'].append({"tDate": str(x[4]), "tID": x[5], "reactive": {"mTime": x[6], "fTime": x[7], "bTime": x[8], "lTime": x[9], "rTime": x[10]}})
            
            
        # Get the Incident we are looking for and the static tests
        incident = {}
        sql = """select t.tDate, st.tID, 
                 st.tlSolidML, st.tlFoamML, st.slSolidML, st.slFoamML, st.tandSolidML, st.tandFoamML
                 from Incident as i left join Test as t on i.iID=t.iID
                 left join StaticTest as st on t.tID=st.tID
                 where i.pID=%s and t.tID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            if x[1] is not None:
                # If the desired tID is found, append a new test to its tests list
                returnList[0]['tests'].append({"tDate": str(x[0]),"tID": x[1], "static": {"tlSolidML": x[2], "tlFoamML": x[3],
                                                                    "slSolidML": x[4], "slFoamML": x[5],
                                                                    "tandSolidML": x[6], "tandFoamML": x[7]}})

        # Get the Incidents we are looking for and their dynamic tests
        sql = """select t.tDate, dt.tID,
                        dt.dMax, dt.dMin, dt.dMean, dt.dMedian, 
                        dt.tsMax, dt.tsMin, dt.tsMean, dt.tsMedian, 
                        dt.mlMax, dt.mlMin, dt.mlMean, dt.mlMedian
                        from Incident as i left join Test as t on i.iID=t.iID
                        left join DynamicTest as dt on t.tID=dt.tID
                        where i.pID=%s and t.tID=%s;"""
        mycursor.execute(sql, val)
        myresult = mycursor.fetchall()
        for x in myresult:
            #  check if in the incidents part of the json, that iID is not already there
            if x[1] is not None:
                returnList[0]['tests'].append({"tDate": str(x[0]), "tID": x[1], "dynamic": {"dMax": x[2], "dMin": x[3], "dMean": x[4], "dMedian": x[5],
                                                                       "tsMax": x[6], "tsMin": x[7], "tsMean": x[8], "tsMedian": x[9],
                                                                       "mlMax": x[10], "mlMin": x[11], "mlMean": x[12], "mlMedian": x[13],}})
        
        return jsonify(returnList)
# --------------------------------------------------------------- TEST SCRIPTS ------------------------------------------------------------------

@app.route('/timeToStability', methods=['POST'])
def timeToStability():
    dataAcc = request.json.get('dataAcc')
    dataRot = request.json.get('dataRot')
    fs = request.json.get('fs')

    # print("DataAcc:", dataAcc)
    # print()
    # print("DataRot:", dataRot)
    # print()
    # print("fs:", fs)
    # print()


    accNorm = np.linalg.norm(dataAcc, axis=0)
    rotNorm = np.linalg.norm(dataRot, axis=0)

    b, a = signal.butter(2, 10 / (fs / 2))

    #Foot Movement: 9.81*1.07; % based on El-Gohary Threshold for foot movement
    qaF = signal.filtfilt(b, a, accNorm) < 9.81*1.07
    #Rotational Foot Movement: 14/180*pi; % based on El-Gohary Threshold for foot movement* this should be 7 deg/sec?
    qrf = signal.filtfilt(b, a, rotNorm) < 14/180*np.pi
    qf = np.logical_and(qaF, qrf)

    
    peaks = []

    peaks, _ = signal.find_peaks(np.flip(accNorm), prominence=5)

    # THIS SHOULD PRINT THE PEAKS WE JUST GOT FROM THIS DATA
    # print(accNorm[len(accNorm) - peaks[0] - 1], accNorm[len(accNorm) - peaks[-1] - 1])

    # extract peaks
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

    if TTS < 0.3 or TTS > 3.5:
        return jsonify(t0 = int(t0), EndTTS = int(EndTTS), TTS = 0)


    return jsonify(t0 = int(t0), EndTTS = int(EndTTS), TTS = TTS)

@app.route('/sway', methods=['POST'])
def sway():
    # static - stand still
    dataAcc = request.json.get('dataAcc')
    dataRot = request.json.get('dataRot')
    fs = request.json.get('fs')

    dataRot, dataAcc = alignData(dataRot, dataAcc, fs)

    Fc = 3.5

    # Filters[data] data using butterworth filter with specified [order] order,
    # [Fc] cuttoff frequency and [Fs] sampling frequency.

    [b,a] = signal.butter(4,(Fc/(fs/2)))
    Sway_ml = signal.filtfilt(b,a, dataAcc[1]) #/ 9.81 # z-direction
    Sway_ap = signal.filtfilt(b,a, dataAcc[0]) #/ 9.81 # y-direction
    Sway_v = signal.filtfilt(b,a, dataAcc[2]) #/ 9.81 # x-direction

    rms_ml = rms(Sway_ml)
    rms_ap = rms(Sway_ap)
    rms_v = rms(Sway_v)
    # print("right before the return in sway")

    return jsonify(rmsMl = rms_ml, rmsAp = rms_ap, rmsV = rms_v)

@app.route('/tandemGait', methods=['POST'])
def tandemGait():
    # dynamic - walking
    dataAcc = request.json.get('dataAcc')
    dataRot = request.json.get('dataRot')
    fs = request.json.get('fs')
    timeStamp = request.json.get('timeStamps')
    # print("DataRot 0:", dataRot[0])
    # print("DataRot 1:", dataRot[1])
    # print("DataRot 2:", dataRot[2])

    dataRot, dataAcc = alignData(dataRot, dataAcc, fs)

    # find the beginning and end
    peaks, _ = signal.find_peaks(dataRot[2], height=0.1)

    begin = peaks[0]
    end = peaks[len(peaks)-1]

    duration = (timeStamp[end] - timeStamp[begin]) / 1000
    # print("duration as it was:", duration)
    # print("updated maybe to seconds (durr/1000):", duration / 1000)
    # print("timestamp end:", timeStamp[end], "timestamp 0:", timeStamp[0])
    # print("begin:", begin, "end:", end)
    
    # find global minima - peak turn
    peakTurnsLoc, _ = signal.find_peaks(dataRot[2])
    peakTurns = list(map(lambda x: dataRot[2][x], peakTurnsLoc))
    maxTurn = max(peakTurns)

    maxTurnIndex = peakTurns.index(maxTurn)
    
    # find closest right and left
    negetiveZList = [-x for x in dataRot[2]]
    sideIndex, _ = signal.find_peaks(negetiveZList, height=-0.1)
    valueLeft = max(filter(lambda x: x<peakTurnsLoc[maxTurnIndex], sideIndex))
    indexLeft = list(sideIndex).index(valueLeft)
    valueRight = sideIndex[indexLeft+1]

    # trim going and return
    goingZ = dataRot[2][begin:valueLeft+1]
    returningZ = dataRot[2][valueRight:end+1]
    goingX = dataRot[0][begin:valueLeft+1]
    returningX = dataRot[0][valueRight:end+1]

    turningSpeed = maxTurn * 180.0 / np.pi

    # print("right before the return in dynamic")

    return jsonify(rmsMlGoing = rms(goingZ), rmsApGoing = rms(goingX), rmsMlReturn = rms(returningZ), rmsApReturn = rms(returningX), duration = duration, turningSpeed = turningSpeed)

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

def alignData(dataRot, dataAcc, fs):
    gR = resample(dataRot, 180 / np.pi)
    accR = resample(dataAcc, 1 / 9.81)

    acceleration, q = rotateAcc(accR, fs * 2)
    rotation = rotateVec(gR, q)

    rotation = np.array(rotation) * np.pi / 180.0
    acceleration = np.array(acceleration) * 9.81

    return rotation, acceleration

def resample(data, coeff):
    gr = [0] * 3 
    gr[0] = list(map(lambda x: x * coeff, signal.resample(data[0], len(data[0]))))
    gr[1] = list(map(lambda x: x * coeff, signal.resample(data[1], len(data[1]))))
    gr[2] = list(map(lambda x: x * coeff, signal.resample(data[2], len(data[2]))))

    return gr

def rotateAcc(acc, t):
    acc = np.array(acc)
    avgAcc = [0] * 3 
    avgAcc[0] = sum(acc[0][0:t]) / t
    avgAcc[1] = sum(acc[1][0:t]) / t
    avgAcc[2] = sum(acc[2][0:t]) / t

    avgNorm = pow(pow(avgAcc[0], 2) + pow(avgAcc[1], 2) + pow(avgAcc[2], 2), 0.5)

    v = [0, 0, avgNorm]
    normV = pow(pow(v[0], 2) + pow(v[1], 2) + pow(v[2], 2), 0.5)
    u = np.cross(avgAcc, v)
    normU = pow(pow(u[0], 2) + pow(u[1], 2) + pow(u[2], 2), 0.5)
    u = list(map(lambda x: x / normU, u))
    
    theta = math.acos(np.dot(avgAcc, v) / (avgNorm * normV))
    
    q0 = [math.cos(theta/2)]
    q123 = list(map(lambda x: math.sin(theta/2) * x, u))

    q = q0 + q123

    return rotateVec(acc, q), q

def rotateVec(v, q):
    v = np.array(v)
    q = np.array(q)

    if np.size(q) == 4 and np.size(v) == 3:
        vr = MultiplyQuaternions(q, np.insert(v, 0, 0))
        vr = MultiplyQuaternions(vr, np.insert(-v[1:], 0, v[0]))
        return [vr[1], vr[2], vr[3]]
    
    vr = MultiplyQuaternions(q, np.insert(v, 0, np.zeros(len(v[0])), 0))
    vr = MultiplyQuaternions(vr, np.insert(-q[1:], 0, q[0]))

    return [vr[1], vr[2], vr[3]]

def MultiplyQuaternions(q0,q1):
    if (np.size(q0) == 4 and np.size(q1) == 4):
        qr = [0] * 4
        qr[0] = q0[0]*q1[0] - q0[1]*q1[1] - q0[2]*q1[2] - q0[3]*q1[3]
        qr[1] = q0[0]*q1[1] + q0[1]*q1[0] + q0[2]*q1[3] - q0[3]*q1[2]
        qr[2] = q0[0]*q1[2] - q0[1]*q1[3] + q0[2]*q1[0] + q0[3]*q1[1]
        qr[3] = q0[0]*q1[3] + q0[1]*q1[2] - q0[2]*q1[1] + q0[3]*q1[0]
        return qr
    
    if np.size(q0) == 4:
        if np.shape(q1)[0] != 4:
            q1 = np.transpose(q1)
        qr = np.zeros((len(q1), len(q1[0])))
        for c1 in  range(len(q1[0])):
            qr[0][c1] = q0[0]*q1[0][c1] - q0[1]*q1[1][c1] - q0[2]*q1[2][c1] - q0[3]*q1[3][c1]
            qr[1][c1] = q0[0]*q1[1][c1] + q0[1]*q1[0][c1] + q0[2]*q1[3][c1] - q0[3]*q1[2][c1]
            qr[2][c1] = q0[0]*q1[2][c1] - q0[1]*q1[3][c1] + q0[2]*q1[0][c1] + q0[3]*q1[1][c1]
            qr[3][c1] = q0[0]*q1[3][c1] + q0[1]*q1[2][c1] - q0[2]*q1[1][c1] + q0[3]*q1[0][c1]      
        return qr
    
    if np.size(q1) == 4:
        if np.shape(q0)[0] != 4:
            q0 = np.transpose(q0)
        qr = np.zeros((len(q0), len(q0[0])))
        for c1 in range(len(q0[0])):
            qr[0][c1] = q0[0][c1]*q1[0] - q0[1][c1]*q1[1] - q0[2][c1]*q1[2] - q0[3][c1]*q1[3]
            qr[1][c1] = q0[0][c1]*q1[1] + q0[1][c1]*q1[0] + q0[2][c1]*q1[3] - q0[3][c1]*q1[2]
            qr[2][c1] = q0[0][c1]*q1[2] - q0[1][c1]*q1[3] + q0[2][c1]*q1[0] + q0[3][c1]*q1[1]
            qr[3][c1] = q0[0][c1]*q1[3] + q0[1][c1]*q1[2] - q0[2][c1]*q1[1] + q0[3][c1]*q1[0]
        return qr
    
    if len(q0) != 4:
        q0 = np.transpose(q0)

    if len(q1) != 4:
        q1 = np.transpose(q1)

    qr = np.zeros(len(q0))
    for c1 in range(len(q0)):
        qr[0][c1] = q0[0][c1]*q1[0][c1] - q0[1][c1]*q1[1][c1] - q0[2][c1]*q1[2][c1] - q0[3][c1]*q1[3][c1];
        qr[1][c1] = q0[0][c1]*q1[1][c1] + q0[1][c1]*q1[0][c1] + q0[2][c1]*q1[3][c1] - q0[3][c1]*q1[2][c1];
        qr[2][c1] = q0[0][c1]*q1[2][c1] - q0[1][c1]*q1[3][c1] + q0[2][c1]*q1[0][c1] + q0[3][c1]*q1[1][c1];
        qr[3][c1] = q0[0][c1]*q1[3][c1] + q0[1][c1]*q1[2][c1] - q0[2][c1]*q1[1][c1] + q0[3][c1]*q1[0][c1];  

    return qr

# --------------------------------------------------------------- Login ----------------------------------------------------------

#Signs up a user in thier selected orginization using cognito user pools
@app.route('/signUp', methods=['POST'])
def signUp():
    authToken = request.json.get('authToken')
    if authToken is None:
        authToken = ""
    userName = request.json.get('userName')
    password = request.json.get('password')
    email = request.json.get('email')
    firstName = request.json.get('firstName')
    lastName = request.json.get('lastName')
    success = CIPW.sign_up_user(user_name= userName, user_email= email, 
                                password= password, first_name=firstName, last_Name = lastName, auth_token = authToken)
    #thinking about how to evaluate return -- if false then we need to confirm sign up
    return jsonify(status = success)

#Confirms the user's signup with a token from an email sent to them
@app.route('/confirmSignUp', methods=['POST'])
def confirmSignUp():
    userName = request.json.get('userName')
    confrimation = request.json.get('confirmationCode')
    success = CIPW.confirm_user_sign_up(user_name= userName, confirmation_code= confrimation)
    return jsonify(status = success)

#signs the user in to thier selected orginization
@app.route('/signIn', methods=['POST'])
def signIp():
    userName = request.json.get('userName')
    password = request.json.get('password')
    accessToken = CIPW.start_sign_in(user_name= userName, password= password)
    #what is the token for?
    if accessToken["AuthenticationResult"]["AccessToken"] != None:
        return jsonify(status = True, accessToken = accessToken["AuthenticationResult"]["AccessToken"])
    return jsonify(status = accessToken)

#SignOut the User
@app.route('/log_out', methods=['POST'])
def signOut():
    currUserToken = request.json.get('AccessToken')
    status = CIPW.log_out(currUserToken)
    #CIPW.log_out(currentUser)
    if status == None: status = True
    return jsonify(status = status)

#sends message delcaring password is forgotten, sends email acces code
#response if good is the email sent
@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    userName = request.json.get('userName')
    accessToken = CIPW.forgot_password(user_name= userName)
    if accessToken["CodeDeliveryDetails"]["DeliveryMedium"] == "EMAIL":
        return jsonify(status = "emailed")
    return jsonify(status = accessToken)

#use access token to reset password
@app.route('/confirm_forgot_password', methods=['POST'])
def confirm_forgot_password():
    userName = request.json.get('userName')
    password = request.json.get('password')
    token = request.json.get('confirmation_code')
    accessToken = CIPW.confirm_forgot_Password(user_name= userName, password = password, confirmation_code = token)
    return jsonify(status = accessToken)

#Gets all users within a selected orginization
@app.route('/getUsers', methods=['GET'])
def getUsers():
    return jsonify(CIPW.list_users())

@app.route('/getUsersNames', methods=['GET'])
def getUserNames():
    results = []
    for user in CIPW.list_users():
        for attr in user["Attributes"]:
            if attr["Name"] == "name":
                results.append(attr["Value"])
    return jsonify(results)

#Gets a list of all Orginizations
@app.route('/getOrgNames', methods=['GET'])
def getAllOrgNames():
    if request.method == 'GET':
        # connection to database
        mydb = connectSql()
        mycursor = mydb.cursor()

        mycursor.execute("SELECT organizationName FROM Organization")
        myresult = mycursor.fetchall()

        returnList = []
        for x in myresult:
            returnList.append(OrderedDict({"orgName": x[0]}))
        return jsonify(returnList) 


#sets the current working orginization
@app.route('/setOrginization', methods=['POST'])
def setOrg():
    global CIPW
    orgName = request.json.get('orgName')
    # connection to database
    mydb = connectSql()
    mycursor = mydb.cursor()
 
    sql = "SELECT * FROM Organization WHERE organizationName=%s"
    val = [(orgName)]
    mycursor.execute(sql, val)
    myresult = mycursor.fetchall()

    returnList = []
    #checks if the orginization exists
    if len(myresult) != 1:
        #default to test group
        CIPW = cognito.CognitoIdentityProviderWrapper(cognito_idp_client=client_idp, user_pool_id = 'us-west-1_zdY5m4TBN', client_id= '4i7eebuhb2feg2kl01lub9e3uv', client_secret = cognitoSecret)
        return jsonify(status = 'not found', orgID = 0)
    
    #if the orginization exists it sets the current orginization to that one
    myresult = myresult[0]
    userPoolId = str(myresult[1])
    clientId = str(myresult[4])
    clientName = str(myresult[3])

    #Secrets manager that holds app secret
    secret_name = "prod/Orgs"
    region_name = "us-west-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    #Get the value of the secret
    secret_value_response = client.get_secret_value(SecretId=secret_name)
    cognitoSecretNew = json.loads(secret_value_response["SecretString"])[clientName]

    CIPW = cognito.CognitoIdentityProviderWrapper(cognito_idp_client=client_idp, user_pool_id = userPoolId, client_id= clientId, client_secret = cognitoSecretNew)

    return jsonify(status = 'succsess', orgID = myresult[0])


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
    # Run the tests
    # result = subprocess.run(['python3', '-m', 'unittest', 'test_server.py'])

    # Check the return code of the test execution
    # if result.returncode == 0:
    # move inside the if when trying to run tests first
    print("All tests passed. Starting the server...")
    serve(app, host="0.0.0.0", port=8000)
    # else:
        # Tests failed
        # print("Some tests failed. The server will not start.")


# CHANGE THE DAMN PORT BACK TO 8000 for updating this
# CHANGE THE DAMN PORT BACK TO 8111 for testing this
# DELETE THE TEST PORT AT THE END OF THE YEAR