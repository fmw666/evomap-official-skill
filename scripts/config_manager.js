const fs = require('fs');
const path = require('path');

const configPath = path.join(__dirname, '..', 'config.yaml');

const SCHEMA = {
    language: { 
        options: ['en', 'zh'], 
        desc_en: 'Display language', 
        desc_zh: '显示语言' 
    },
    default_node: { 
        type: 'string', 
        desc_en: 'Default Node ID for queries', 
        desc_zh: '默认查询的节点ID' 
    }
};

const DEFAULT_CONFIG = {
    language: 'en',
    default_node: 'node_nietzsche_ddb_001'
};

function readYaml() {
    if (!fs.existsSync(configPath)) return { ...DEFAULT_CONFIG };
    try {
        const content = fs.readFileSync(configPath, 'utf8');
        const config = {};
        content.split('\n').forEach(line => {
            const parts = line.split(':');
            if (parts.length >= 2) {
                config[parts[0].trim()] = parts.slice(1).join(':').trim();
            }
        });
        // Validate if critical keys exist, if not, use defaults
        if (Object.keys(config).length === 0) return { ...DEFAULT_CONFIG };
        return config;
    } catch (e) {
        return { ...DEFAULT_CONFIG };
    }
}

function writeYaml(config) {
    const content = Object.keys(config)
        .map(key => `${key}: ${config[key]}`)
        .join('\n');
    fs.writeFileSync(configPath, content);
}

function main() {
    const action = process.argv[2]; // 'get' or 'set'
    let key = process.argv[3];
    let value = process.argv[4];

    let config = readYaml();

    if (action === 'set' && key && value) {
        // 2. Schema Depth - Case Sensitivity Correction
        if (key === 'language') value = value.toLowerCase();

        // Validation logic
        if (!SCHEMA[key]) {
            process.env.EVO_ERROR_MSG = `Invalid key: ${key}`;
            return render('config_error.md', config.language || 'en');
        }
        if (SCHEMA[key].options && !SCHEMA[key].options.includes(value)) {
            process.env.EVO_ERROR_MSG = `Invalid value for ${key}. Options: ${SCHEMA[key].options.join(', ')}`;
            return render('config_error.md', config.language || 'en');
        }

        config[key] = value;
        writeYaml(config);
        process.env.EVO_MODIFIED_KEY = key;
        process.env.EVO_NEW_VALUE = value;
        render('config_update.md', config.language || 'en');
    } else {
        let schemaStr = "";
        for (const k in SCHEMA) {
            const options = SCHEMA[k].options ? ` [${SCHEMA[k].options.join('/')}]` : '';
            schemaStr += `- ${k}: ${SCHEMA[k].desc_zh}${options}\n`;
        }
        process.env.EVO_SCHEMA_DESC = schemaStr.trim();
        render('config.md', config.language || 'en');
    }
}

function render(templateName, lang) {
    const { execSync } = require('child_process');
    const nodeBin = process.argv[0];
    const scriptPath = path.join(__dirname, 'render_template.js');
    try {
        const output = execSync(`${nodeBin} ${scriptPath} ${templateName} ${lang}`, { env: process.env });
        process.stdout.write(output);
    } catch (e) {
        process.stdout.write("Rendering failed.\n");
    }
}

main();
