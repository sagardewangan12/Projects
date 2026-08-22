import os
from datetime import datetime

def current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def heal_service():
    print(f"[{current_time()}] Auto-heal triggered!")
    print(f"[{current_time()}] Service seems down. Recovery action should run here.")
