import os
import time
import subprocess


# 所有文件夹
folders = [
    '/mnt/h/data/LE16_240124/LE16_240124',
    '/mnt/h/data/LE16_240125/LE16_240125'
]
interval = 0  # 在处理下一个文件夹前的间隔时间

def check_load_linux():
    try:
        result = subprocess.run(['iostat', '-c', '1', '2'], capture_output=True, text=True)
        if result.returncode == 0:
            lines = result.stdout.splitlines()
            # 提取最后一行的 CPU 空闲百分比
            cpu_idle = float(lines[-1].split()[-1])
        else:
            cpu_idle = 100
    except Exception as e:
        cpu_idle = 100
    return cpu_idle

cwd = os.getcwd()
for folder in folders:
    os.chdir(folder)
    fet_files = [f for f in os.listdir(folder) if f.endswith('.fet')]
    
    for i, fet_file in enumerate(fet_files, start=1):
        c_idle = check_load_linux()
        while c_idle < 10:
            print(f'System resource is low now({c_idle}%), will wait for 10 seconds to resubmit the job.')
            time.sleep(10)
            c_idle = check_load_linux()
        
        loc = fet_file.rfind('.')
        command = f'KlustaKwik {fet_file[:loc]} {i} -MinClusters 20 -MaxClusters 30 -MaxPossibleClusters 50 &'
        subprocess.run(command, shell=True)
        print(f'Job submitted {i}/{len(fet_files)} current system resource: {c_idle}%')
    
    time.sleep(interval)

os.chdir(cwd)
