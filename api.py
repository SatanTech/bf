import re
import subprocess
import requests
from flask import Flask, request, abort, jsonify

app = Flask(__name__)

# IP yang diizinkan (whitelist)
ALLOWED_IPS = {"47.84.55.97"}  

def is_allowed_ip(ip):
    return ip in ALLOWED_IPS

@app.before_request
def restrict_ip():
    if not is_allowed_ip(request.remote_addr):
        abort(403) 

@app.errorhandler(403)
def forbidden(error):
    return jsonify({"status": "forbidden", "message": "NYARI APA MONYET!!"}), 403

@app.route("/create-vmess")
def create_vmess():
	user = request.args.get("user")
	exp = request.args.get("exp")
	qu = request.args.get("quota")
	lim = request.args.get("limitip")
	cmd = f"printf '%s\n' '{user}' '{exp}' '{qu}' '{lim}' | add-ws"
	try:
		x = subprocess.check_output(cmd,shell=True).decode("utf-8")
		a = [x.group() for x in re.finditer("vmess://(.*)",x)]
	except:
		return "error"
	else:
		return(a)

@app.route("/create-ssh")
def add_user_exp():
	u = request.args.get("user")
	p = request.args.get("password")
	exp = request.args.get("exp")
	lim = request.args.get("limitip")
	cmd = f"printf '%s\n' '{u}' '{p}' '{exp}' '{lim}' | add-ssh"
	try:
		x = subprocess.check_output(cmd,shell=True).decode("utf-8")
	except:
		return "error"
	else:
		return "success"

@app.route("/create-trojan")
def create_trojan():
	user = request.args.get("user")
	exp = request.args.get("exp")
	qu = request.args.get("quota")
	lim = request.args.get("limitip")
	cmd = f"printf '%s\n' '{user}' '{exp}' '{qu}' '{lim}' | add-tr"
	try:
		x = subprocess.check_output(cmd,shell=True).decode("utf-8")
		a = [x.group() for x in re.finditer("trojan://(.*)",x)]
	except:
		return "error"
	else:
		return(a)

@app.route("/create-vless")
def create_vless():
	user = request.args.get("user")
	exp = request.args.get("exp")
	qu = request.args.get("quota")
	lim = request.args.get("limitip")
	cmd = f"printf '%s\n' '{user}' '{exp}' '{qu}' '{lim}' | add-vless"
	try:
		x = subprocess.check_output(cmd,shell=True).decode("utf-8")
		a = [x.group() for x in re.finditer("vless://(.*)",x)]
	except:
		return "error"
	else:
		return(a)

def get_vps_ip():
    response = requests.get('https://ipinfo.io')
    data = response.json()
    ip = data['ip']
    return ip

app.run(host=get_vps_ip(), port=1000)