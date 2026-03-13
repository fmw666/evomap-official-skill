const fs = require('fs');
const path = require('path');

function render() {
    const templateName = process.argv[2];
    const lang = process.argv[3] || 'en';
    
    const templatePath = path.join(__dirname, '..', 'assets', 'templates', templateName);
    
    if (!fs.existsSync(templatePath)) {
        process.stdout.write(`Template ${templateName} not found.`);
        return;
    }

    const content = fs.readFileSync(templatePath, 'utf8');
    const lines = content.split('\n');

    let outputLines = [];
    let capture = false;
    
    for (const line of lines) {
        if (line.trim() === `## ${lang}`) {
            capture = true;
            continue;
        } else if (line.startsWith('## ') && capture) {
            break;
        }
        
        if (capture) {
            outputLines.push(line);
        }
    }

    let template = outputLines.join('\n');
    
    // Replace all EVO_ environment variables
    for (const key in process.env) {
        if (key.startsWith('EVO_')) {
            const varName = key.substring(4);
            const regex = new RegExp(`{{${varName}}}`, 'g');
            template = template.replace(regex, process.env[key]);
        }
    }
    
    // Default variables
    template = template.replace(/{{TIME}}/g, new Date().toISOString().replace('T', ' ').substring(0, 19));

    process.stdout.write(template.trim() + '\n');
}

render();
