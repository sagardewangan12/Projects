import platform
import psutil
import os
import json
from datetime import datetime

# --- Step 1: Get system info ---
def get_system_info():
    info = {}
    info['System'] = platform.system()
    info['Node Name'] = platform.node()
    info['Release'] = platform.release()
    info['Version'] = platform.version()
    info['Machine'] = platform.machine()
    info['Processor'] = platform.processor()
    info['RAM'] = f"{round(psutil.virtual_memory().total / (1024 ** 3), 2)} GB"
    return info

# --- Step 2: Save report to Downloads ---
def save_report(info):
    downloads_path = os.path.join(os.path.expanduser("~"), "Downloads")
    filename = f"System_Report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    file_path = os.path.join(downloads_path, filename)
    
    # Save system report
    with open(file_path, 'w') as f:
        json.dump(info, f, indent=4)
    
    # Update last report mapping
    with open("last_report.json", 'w') as f:
        json.dump({"last_project": file_path}, f)
    
    print(f"\nReport saved as {file_path}")

# --- Step 3: Load last report if exists ---
def load_last_report():
    try:
        with open("last_report.json", 'r') as f:
            data = json.load(f)
            last_file = data.get("last_project")
            if last_file and os.path.exists(last_file):
                print("\n=== Last Saved Report ===")
                with open(last_file, 'r') as lf:
                    last_data = json.load(lf)
                    for k, v in last_data.items():
                        print(f"{k}: {v}")
                print("\n(To generate new report, press Enter...)")
                input()
    except FileNotFoundError:
        pass

# --- Step 4: Main function ---
def main():
    load_last_report()
    print("\n=== System Check Tool ===")
    system_info = get_system_info()
    for k, v in system_info.items():
        print(f"{k}: {v}")
    save_report(system_info)

if __name__ == "__main__":
    main()
