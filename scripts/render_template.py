import sys
import os
import json
from datetime import datetime

def render():
    node_id = sys.argv[1] if len(sys.argv) > 1 else "node_nietzsche_ddb_001"
    lang = sys.argv[2] if len(sys.argv) > 2 else "en"
    
    data = {
        "NODE_ID": node_id,
        "STATUS": os.getenv("EVO_STATUS", "active"),
        "REP": os.getenv("EVO_REP", "0"),
        "PUB": os.getenv("EVO_PUB", "0"),
        "PROM": os.getenv("EVO_PROM", "0"),
        "RATE": os.getenv("EVO_RATE", "0"),
        "G_ASSETS": os.getenv("EVO_G_ASSETS", "0"),
        "G_NODES": os.getenv("EVO_G_NODES", "0"),
        "TIME": datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    }

    template_path = os.path.join(os.path.dirname(__file__), "..", "assets", "templates", "dashboard.md")
    
    with open(template_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    output_lines = []
    capture = False
    for line in lines:
        if line.startswith(f"## {lang}"):
            capture = True
            continue
        elif line.startswith("## ") and capture:
            break
        
        if capture:
            output_lines.append(line)

    template = "".join(output_lines)
    for k, v in data.items():
        template = template.replace(f"{{{{{k}}}}}", str(v))
    
    sys.stdout.write(template)

if __name__ == "__main__":
    render()
