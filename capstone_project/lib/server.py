import numpy as np
from scipy import butter, filtfilt, find_peaks
from flask import Flask, jsonify, request

app = Flask(__name__)

json_file = {"counter": 0}

@app.route('/')
def firstLoad():
    json_file['counter'] = 0
    return jsonify(json_file)

@app.route('/postData', methods=['POST'])
def receive_post_data():
    if request.method == 'POST':
        data_from_post = request.json.get('counter')
        json_file['counter'] = data_from_post
        return jsonify(json_file)
    
@app.route('/current')
def curr():
    return jsonify(json_file)

@app.route('/incre')
def increment():
    json_file['counter'] += 1
    return jsonify(json_file)

@app.route('/zero')
def zero():
    json_file['counter'] = 0
    return jsonify(json_file)

@app.route('/timeToStability')
def timeToStability(DataAcc, DataRot, Fs):
    accNorm = np.linalg.norm(DataAcc, axis=1)
    rotNorm = np.linalg.norm(DataRot, axis=1)

    b, a = butter(2, 10 / (Fs / 2))

    #Foot Movement: 9.81*1.07; % based on El-Gohary Threshold for foot movement
    qaF = filtfilt(b, a, accNorm) < 9.81*1.07
    #Rotational Foot Movement: 14/180*pi; % based on El-Gohary Threshold for foot movement* this should be 7 deg/sec?
    qrf = filtfilt(b, a, rotNorm) < 14/180*np.pi
    qf = np.logical_and(qaF, qrf)

    #find t0
    peaks, _ = find_peaks(np.flip(accNorm)[Fs * 3:], height=5)
    movementF = Fs * 3 + peaks[-1]
    release = np.argmax(qf[movementF:]) #reverse of qf? reverse done in movementF?
    release = movementF+release
    t0 = len(accNorm)-release

    #find TTS
    movementReg = len(accNorm)-movementF
    EndTTS = np.argmax(qf[movementReg:])
    EndTTS = EndTTS+movementReg

    TTS = (EndTTS - t0)/Fs

    return jsonify({'t0': t0, 'EndTTS': EndTTS, 'TTS': TTS})

# Run the developement server
if __name__ == '__main__':
    app.run()

# This is to run as a WSGI server, which essentially means
# no default logging or hot reload. comment out the  development server code
# above then uncomment the code below.
# You will need to install waitress with this command
# python -m pip install waitress
"""
if __name__ == "__main__":
    from waitress import serve
    serve(app, host="127.0.0.1", port=5000)
"""