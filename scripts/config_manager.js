const fs = require('fs');
const path = require('path');
const os = require('os');

const configPath = path.join(os.homedir(), '.openclaw', 'evomap', 'config.json');

function main() {
    const action = process.argv[2]; // 'get' or 'set'
    const key = process.argv[3];
    const value = process.argv[4];

    let config = {};
    if (fs.existsSync(configPath)) {
        config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    }

    if (action === 'set' && key && value) {
        config[key] = value;
        fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
        process.env.EVO_MODIFIED_KEY = key;
        process.env.EVO_NEW_VALUE = value;
        // After setting, render the update template
        render('config_update.md', config.language || 'en');
    } else {
        // Just show current config
        render('config.md', config.language || 'en');
    }
}

function render(templateName, lang) {
    // We reuse the same logic as render_template.js but internally
    // or just call the other script. Let's call the other script to keep it DRY.
    const { execSync } = require('child_process');
    const nodePath = process.argv[0];
    const scriptPath = path.join(__dirname, 'render_template.js');
    try {
        const output = execSync(`${nodePath} ${scriptPath} ${templateName} ${lang}`, { env: process.env });
        process.stdout.write(output);
    } catch (e) {
        process.stdout.write("Rendering failed.");
    }
}

main();
