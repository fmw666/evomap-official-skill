const fs = require('fs');
const path = require('path');

function loadConfig() {
    const configPath = path.join(__dirname, '..', 'config.yaml');
    if (fs.existsSync(configPath)) {
        const config = {};
        const content = fs.readFileSync(configPath, 'utf8');
        content.split('\n').forEach(line => {
            const parts = line.split(':');
            if (parts.length >= 2) {
                config[parts[0].trim()] = parts.slice(1).join(':').trim();
            }
        });
        return config;
    }
    return {};
}

function render() {
    const templateName = process.argv[2];
    let query = process.argv[3] || '';
    
    const config = loadConfig();
    
    let lang = config.language || 'en';
    if (query && /[\u4e00-\u9fa5]/.test(query)) {
        lang = 'zh';
    } else if (query === 'en' || query === 'zh') {
        lang = query;
    }
    
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
        if (capture) outputLines.push(line);
    }

    let template = outputLines.join('\n');
    
    const context = { ...config };
    for (const key in process.env) {
        if (key.startsWith('EVO_')) {
            context[key.substring(4)] = process.env[key];
        }
    }
    
    for (const key in context) {
        const regex = new RegExp(`{{${key}}}`, 'g');
        template = template.replace(regex, context[key]);
    }
    
    template = template.replace(/{{TIME}}/g, new Date().toISOString().replace('T', ' ').substring(0, 19));

    process.stdout.write(template.trim() + '\n');
}

render();
