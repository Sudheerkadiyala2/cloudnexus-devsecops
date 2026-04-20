from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 CloudNexus DevSecOps Running!"

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(host="49.206.9.238", port=5000)
