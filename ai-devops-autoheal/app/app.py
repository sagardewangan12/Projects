from flask import Flask, jsonify
import time
import os

app = Flask(__name__)
start_time = time.time()

@app.route("/")
def home():
    return jsonify({
        "message": "AI DevOps Auto-Healing App Running",
        "status": "ok",
        "version": os.getenv("APP_VERSION", "1.0")
    })

@app.route("/health")
def health():
    return jsonify({
        "health": "healthy",
        "uptime_seconds": int(time.time() - start_time)
    }), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
