import os
import time
import psutil
from flask import Flask, jsonify
from redis import Redis

app = Flask(__name__)
# الربط مع Redis باستخدام المتغيرات اللي اتفقنا عليها
db = Redis(host=os.getenv('REDIS_HOST', 'localhost'), port=6379)

@app.route('/')
def monitor():
    stats = {
        "cpu_usage": psutil.cpu_percent(),
        "ram_usage": psutil.virtual_memory().percent,
        "status": "Healthy"
    }
    # تخزين آخر قراءة في راديس
    db.set('last_check', str(stats))
    return jsonify(stats)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
