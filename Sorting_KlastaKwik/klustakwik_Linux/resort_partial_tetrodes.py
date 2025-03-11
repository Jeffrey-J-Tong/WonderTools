import subprocess
import os

f_kwik = "/mnt/h/KlustaKwik"

cwd = os.getcwd()
os.chdir('/mnt/h/data/LE16_240126_2')
command = f'{f_kwik} LE16_240126_2 12  -MinClusters 20 -MaxClusters 30 -MaxPossibleClusters 50 &'
subprocess.run(command, shell=True)
command = f'{f_kwik} LE16_240126_2 13  -MinClusters 20 -MaxClusters 30 -MaxPossibleClusters 50 &'
subprocess.run(command, shell=True)
command = f'{f_kwik} LE16_240126_2 14  -MinClusters 20 -MaxClusters 30 -MaxPossibleClusters 50 &'
subprocess.run(command, shell=True)
os.chdir(cwd)
