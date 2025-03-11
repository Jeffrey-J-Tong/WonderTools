import subprocess

def check_load_windows():
    try:
        result = subprocess.run(["wmic", "cpu", "get", "loadpercentage"], capture_output=True, text=True)
        lines = result.stdout.splitlines()
        cpu_loads = [int(s) for s in lines if s.strip().isdigit()]
        cpu_idle = 100 - cpu_loads[0] if cpu_loads else 100
    except Exception:
        cpu_idle = 100
    return cpu_idle

c_idle = check_load_windows()
print(f'System resource is {c_idle}%.')

# command = 'powershell -Command "Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage"'
# result = subprocess.run(command, capture_output=True, text=True, shell=True)
# cpu_load = int(result.stdout.strip())  # 提取 CPU 负载
# cpu_idle = 100 - cpu_load  # 计算 CPU 空闲率