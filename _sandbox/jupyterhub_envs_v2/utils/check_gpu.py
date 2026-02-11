#!/usr/bin/env python3
import subprocess, sys
def has_nvidia_smi():
    try:
        out = subprocess.check_output(['nvidia-smi','--query-gpu=name,memory.total,driver_version','--format=csv,noheader,nounits'], stderr=subprocess.DEVNULL)
        print(out.decode())
        return True
    except Exception:
        return False
if __name__ == '__main__':
    if has_nvidia_smi():
        print('NVIDIA GPU appears present.')
    else:
        print('nvidia-smi not available or no NVIDIA GPU present.')
