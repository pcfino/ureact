import numpy as np
from scipy import signal
from flask import Flask, jsonify, request
from mysql import connector

import socket
# pip install numpy
# pip install scipy
# pip install flask
# pip install mysql-connector-python
# pip install waitress

app = Flask(__name__)

print("Server has started: ")

json_file = {"TTS": 0}
#@app.route('/postData', methods=['POST'])
#def receive_post_data():
#    if request.method == 'POST':
#        data_from_post = request.json.get('counter')
#        json_file['counter'] = data_from_post
#        return jsonify(json_file)

@app.route('/mysql/getResults')
def getMysql():
    mydb = connector.connect(
    host="kinesiology-db.c9yuqs8kqmi6.us-west-1.rds.amazonaws.com",
    user="admin",
    password="Kines2024"
    )
    mycursor = mydb.cursor()
    mycursor.execute("use Kinesiology-App") 
    mycursor.execute("SELECT * FROM test_table")
    myresult = mycursor.fetchone()[0]
    return jsonify({'TTS': str(myresult)})

@app.route('/mysql/setResults', methods=['POST'])
def setMysql():
    if request.method == 'POST':
        data_from_post = request.json.get('TTS')    
        mydb = connector.connect(
        host="kinesiology-db.c9yuqs8kqmi6.us-west-1.rds.amazonaws.com",
        user="admin",
        password="Kines2024"
        )
        mycursor = mydb.cursor()
        mycursor.execute("use Kinesiology-App") 
        sql = "INSERT INTO test_table VALUES(%s)"
        val = [(data_from_post)]
        mycursor.execute(sql, val)
        mydb.commit()
        json_file['TTS'] = data_from_post
        return jsonify(json_file)

@app.route('/timeToStability', methods=['POST'])
def timeToStability():
    print("I am here")
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

# Run the developement server
# if __name__ == '__main__':
#     app.run()

# This is to run as a WSGI server, which essentially means
# no default logging or hot reload. comment out the  development server code
# above then uncomment the code below.
# You will need to install waitress with this command
# python -m pip install waitress

if __name__ == "__main__":
    from waitress import serve
    serve(app, host="0.0.0.0", port=8000)
