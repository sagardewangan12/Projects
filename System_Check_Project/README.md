# System Check Tool (Python)

Simple Python project that collects system information and saves it as a JSON report.

## Features
- Fetch system details: OS, Node Name, Release, Version, Machine, Processor, RAM  
- Save report in `Downloads` folder with timestamp  
- View last saved report  

## Files
- `system_check.py` – Main Python script  
- `last_report.json` – Stores last report path automatically  
- `README.md` – Project documentation  

## How to run
```bash
pip install psutil
python system_check.py
