const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

/**
 * Archon Configuration Manager
 * - Persistent storage with YAML format.
 * - Schema-driven validation.
 * - Atomic updates.
 */

const CONFIG_PATH = path.join(__dirname, '..', 'config.yaml');

const SCHEMA = {
    language: { 
        options: ['en', 'zh'], 
        desc: 'Interface language' 
    },
    default_node: { 
        type: 'string', 
        desc: 'Default Node ID' 
    }
};

const DEFAULTS = {
    language: 'en',
    default_node: 'node_nietzsche_ddb_001'
};

function readConfig() {
    if (!fs.existsSync(CONFIG_PATH)) return { ...DEFAULTS };
    try {
        const content = fs.readFileSync(CONFIG_PATH, 'utf8');
        return content.split('\n').reduce((acc, line) => {
            const [key, ...val] = line.split(':');
            if (key && val.length) acc[key.trim()] = val.join(':').trim();
            return acc;
        }, {});
    } catch (e) {
        return { ...DEFAULTS };
    }
}

function writeConfig(config) {
    const yaml = Object.entries(config).map(([k, v]) => `${k}: ${v}`).join('\n');
    fs.writeFileSync(CONFIG_PATH, yaml);
}

function performAction() {
    const [,, action, key, val] = process.argv;
    let config = readConfig();

    if (action === 'set' && key && val) {
        let normalizedVal = key === 'language' ? val.toLowerCase() : val;

        if (!SCHEMA[key]) return error(`Invalid field: ${key}`);
        if (SCHEMA[key].options && !SCHEMA[key].options.includes(normalizedVal)) {
            return error(`Invalid value for ${key}. Use: ${SCHEMA[key].options.join('/')}`);
        }

        config[key] = normalizedVal;
        writeConfig(config);
        
        process.env.EVO_MODIFIED_KEY = key;
        process.env.EVO_NEW_VALUE = normalizedVal;
        render('config_update.md', config.language);
    } else {
        process.env.EVO_SCHEMA_DESC = Object.entries(SCHEMA)
            .map(([k, v]) => `- ${k}: ${v.desc}${v.options ? ` [${v.options.join('/')}]` : ''}`)
            .join('\n');
        render('config.md', config.language);
    }
}

function render(template, lang) {
    try {
        const output = execSync(`${process.argv[0]} ${path.join(__dirname, 'render_template.js')} ${template} ${lang}`, { env: process.env });
        process.stdout.write(output);
    } catch (e) {
        process.stdout.write("Fatal: Rendering pipeline failed.\n");
    }
}

function error(msg) {
    process.env.EVO_ERROR_MSG = msg;
    const config = readConfig();
    render('config_error.md', config.language);
}

performAction();
