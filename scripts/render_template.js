const fs = require('fs');
const path = require('path');

function loadConfig() {
    // Look for config.json in the skill root (one level up from scripts/)
    const configPath = path.join(__dirname, '..', 'config.json');
    if (fs.existsSync(configPath)) {
        try {
            return JSON.parse(fs.readFileSync(configPath, 'utf8'));
        } catch (e) {
            return {};
        }
    }
    return {};
}

function render() {
    const templateName = process.argv[2];
    let query = process.argv[3] || '';
    
    // 1. Load Persisted Config
    const config = loadConfig();
    
    // 2. Determine Language (Priority: Query > Config > Default)
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
    
    // 3. Prepare Data Context (Config + Env)
    const context = { ...config };
    for (const key in process.env) {
        if (key.startsWith('EVO_')) {
            context[key.substring(4)] = process.env[key];
        }
    }
    
    // 4. Inject Variables
    for (const key in context) {
        const regex = new RegExp(`{{${key}}}`, 'g');
        template = template.replace(regex, context[key]);
    }
    
    template = template.replace(/{{TIME}}/g, new Date().toISOString().replace('T', ' ').substring(0, 19));

    process.stdout.write(template.trim() + '\n');
}

render();
