import requests
import time
from datetime import datetime
from auto_heal import heal_service

TARGET_URL = "http://127.0.0.1:5000/health"
CHECK_INTERVAL = 10  # seconds

def current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def check_health():
    try:
        response = requests.get(TARGET_URL, timeout=3)
        if response.status_code == 200:
            print(f"[{current_time()}] Health check OK - {response.json()}")
            return True
        else:
            print(f"[{current_time()}] Health check FAILED with status {response.status_code}")
            return False
    except Exception as e:
        print(f"[{current_time()}] Health check ERROR: {e}")
        return False

def main():
    print(f"[{current_time()}] Monitoring started for {TARGET_URL}")
    while True:
        healthy = check_health()
        if not healthy:
            heal_service()
        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
