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