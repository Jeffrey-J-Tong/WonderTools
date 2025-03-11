import os
import time
import subprocess
import re

# 所有路径
f_kwik = r"C:\path\to\KlustaKwik"
folders = [
    r"C:\path\to\data\LE16_240124",
    r"C:\path\to\data\LE16_240125"
]
interval = 0  # 处理下一个文件夹前的间隔时间

def check_load_windows():
    try:
        result = subprocess.run(["wmic", "cpu", "get", "loadpercentage"], capture_output=True, text=True)
        lines = result.stdout.splitlines()
        cpu_loads = [int(s) for s in lines if s.strip().isdigit()]
        cpu_idle = 100 - cpu_loads[0] if cpu_loads else 100
    except Exception:
        cpu_idle = 100
    return cpu_idle

cwd = os.getcwd()
for folder in folders:
    os.chdir(folder)
    fet_files = [f for f in os.listdir(folder) if re.match(r'.+\.fet\.\d+$', f)]
    
    for i, fet_file in enumerate(fet_files, start=1):
        c_idle = check_load_windows()
        while c_idle < 10:
            print(f'System resource is low now ({c_idle}%), will wait for 10 seconds to resubmit the job.')
            time.sleep(10)
            c_idle = check_load_windows()
        
        base_name = fet_file.rsplit('.', 2)[0]  # 截取到 .fet 之前的部分
        command = f'{f_kwik} {base_name} {i} -MinClusters 20 -MaxClusters 30 -MaxPossibleClusters 50 &'
        subprocess.run(command, shell=True)
        print(f'Job submitted {i}/{len(fet_files)} current system resource: {c_idle}%')
    
    time.sleep(interval)

os.chdir(cwd)
