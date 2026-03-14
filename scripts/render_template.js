const fs = require('fs');
const path = require('path');

/**
 * Archon Render Engine
 * - Zero-dependency template injection.
 * - Multi-language support via Markdown headers.
 * - Strictly configuration-driven.
 */

const CONFIG_PATH = path.join(__dirname, '..', 'config.yaml');
const TEMPLATES_BASE = path.join(__dirname, '..', 'assets', 'templates');

function loadConfig() {
    if (!fs.existsSync(CONFIG_PATH)) return { language: 'en' };
    const content = fs.readFileSync(CONFIG_PATH, 'utf8');
    return content.split('\n').reduce((acc, line) => {
        const [key, ...val] = line.split(':');
        if (key && val.length) acc[key.trim()] = val.join(':').trim();
        return acc;
    }, {});
}

function extractTemplateBlock(content, lang) {
    const lines = content.split('\n');
    let output = [], capture = false;
    for (const line of lines) {
        if (line.trim() === `## ${lang}`) { capture = true; continue; }
        if (line.startsWith('## ') && capture) break;
        if (capture) output.push(line);
    }
    return output.join('\n').trim();
}

function render() {
    const templateName = process.argv[2];
    if (!templateName) return;

    const config = loadConfig();
    const lang = config.language || 'en';
    const templatePath = path.join(TEMPLATES_BASE, templateName);

    if (!fs.existsSync(templatePath)) {
        return process.stdout.write(`Template ${templateName} not found.\n`);
    }

    const rawContent = fs.readFileSync(templatePath, 'utf8');
    let template = extractTemplateBlock(rawContent, lang);

    // Fallback to English if requested block is empty
    if (!template && lang !== 'en') {
        template = extractTemplateBlock(rawContent, 'en');
    }

    // Merge Config + Environment variables (EVO_ prefix)
    const context = { 
        ...config,
        TIME: new Date().toISOString().replace('T', ' ').substring(0, 19)
    };
    Object.keys(process.env).filter(k => k.startsWith('EVO_')).forEach(k => {
        context[k.substring(4)] = process.env[k];
    });

    // Precise Variable Injection
    const rendered = Object.keys(context).reduce((acc, key) => {
        return acc.replace(new RegExp(`{{${key}}}`, 'g'), context[key]);
    }, template);

    process.stdout.write(rendered + '\n');
}

render();
