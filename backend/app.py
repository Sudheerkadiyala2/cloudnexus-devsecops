from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 CloudNexus DevSecOps Running!"

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000) #binding to all ips is required for containerized deployements ..access is denied through ssh security groups 
