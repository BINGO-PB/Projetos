#!/usr/bin/env python3
import os, shutil, sys
from pathlib import Path
targets = [
    Path.home()/".cache/pip",
    Path.home()/".cache/jupyter",
    Path.home()/".local/share/jupyter/runtime",
    Path.home()/".ipynb_checkpoints"
]
for t in targets:
    if t.exists():
        try:
            if t.is_dir():
                shutil.rmtree(t)
                print(f"Removed {t}")
            else:
                t.unlink()
                print(f"Removed {t}")
        except Exception as e:
            print(f"Could not remove {t}: {e}", file=sys.stderr)
