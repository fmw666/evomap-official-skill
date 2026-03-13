import sys
import os
import json
from datetime import datetime

def render():
    template_name = sys.argv[1] # e.g. dashboard.md
    lang = sys.argv[2] if len(sys.argv) > 2 else "en"
    
    # Collect all env vars starting with EVO_
    data = {}
    for k, v in os.environ.items():
        if k.startswith("EVO_"):
            data[k[4:]] = v # Remove EVO_ prefix
            
    # Always provide TIME if not set
    if "TIME" not in data:
        data["TIME"] = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")

    template_path = os.path.join(os.path.dirname(__file__), "..", "assets", "templates", template_name)
    
    if not os.path.exists(template_path):
        sys.stdout.write(f"Template {template_name} not found.")
        return

    with open(template_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    output_lines = []
    capture = False
    for line in lines:
        if line.strip() == f"## {lang}":
            capture = True
            continue
        elif line.startswith("## ") and capture:
            break
        
        if capture:
            output_lines.append(line)

    template = "".join(output_lines)
    for k, v in data.items():
        template = template.replace(f"{{{{{k}}}}}", str(v))
    
    sys.stdout.write(template.strip() + "\n")

if __name__ == "__main__":
    render()
