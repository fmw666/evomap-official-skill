#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const https = require('https');

/**
 * Archon Render & Logic Engine (Pure Node.js Edition)
 * - Zero-dependency template injection.
 * - Multi-language support via Markdown headers.
 * - Dependency-free HTTPS client (replacing curl/jq).
 * - Automatic Error Isolation.
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

async function apiFetch(url, token) {
    if (process.env.EVO_MOCK === "1") return null; // Skip real API in mock mode
    return new Promise((resolve) => {
        const options = {
            headers: { 'Authorization': `Bearer ${token}` },
            timeout: 5000
        };
        https.get(url, options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try { resolve(JSON.parse(data)); }
                catch (e) { resolve(null); }
            });
        }).on('error', () => resolve(null));
    });
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

async function main() {
    const templateName = process.argv[2];
    const langOverride = process.argv[3]; // Optional override for testing
    if (!templateName) return;

    const config = loadConfig();
    const lang = langOverride || config.language || 'en';
    const token = config.evomap_token || process.env.EVOMAP_TOKEN;

    // Prepare Initial Context
    let context = { 
        ...config,
        TIME: new Date().toISOString().replace('T', ' ').substring(0, 19)
    };

    let targetTemplate = templateName;

    // 🚀 Logic Layer
    if (process.env.EVO_MOCK !== "1") {
        if (templateName === 'dashboard.md' || templateName === 'node.md' || templateName === 'work.md') {
            const nodeId = (templateName === 'work.md') ? config.default_node : (langOverride || config.default_node);
            context.NODE_ID = nodeId;
            
            const nodeData = await apiFetch(`https://evomap.ai/a2a/nodes/${nodeId}`, token);
            
            if (!nodeData || !nodeData.node_id) {
                if (templateName !== 'work.md') {
                    const searchRes = await apiFetch(`https://evomap.ai/a2a/nodes/search?q=${nodeId}`, token);
                    if (searchRes && searchRes.nodes && searchRes.nodes.length > 0) {
                        targetTemplate = 'select_node.md';
                        context.NODE_LIST = searchRes.nodes.slice(0, 5).map((n, i) => `${i + 1}. \`${n.node_id}\` (${n.status})`).join('\n');
                    } else {
                        targetTemplate = 'error_node.md';
                    }
                }
            } else {
                Object.keys(nodeData).forEach(k => context[k] = nodeData[k]);
                context.REP = nodeData.reputation_score;
                context.PUB = nodeData.total_published;
                context.PROM = nodeData.total_promoted;
                context.CONF = nodeData.avg_confidence;
                context.SYM = nodeData.symbiosis_score;
                context.ONLINE = nodeData.online;
                context.LAST_SEEN = nodeData.last_seen_at;
                context.EARNINGS = nodeData.earnings || 0;
                
                if (templateName === 'dashboard.md') {
                    const stats = await apiFetch('https://evomap.ai/a2a/stats', token);
                    if (stats) {
                        context.G_ASSETS = stats.total_assets;
                        context.G_NODES = stats.total_nodes;
                        context.RATE = (context.PUB > 0) ? (context.PROM * 100 / context.PUB).toFixed(1) : "0.0";
                    }
                } else if (templateName === 'work.md') {
                    const myWork = await apiFetch(`https://evomap.ai/a2a/work/my?node_id=${nodeId}`, token);
                    const availWork = await apiFetch(`https://evomap.ai/a2a/work/available?node_id=${nodeId}`, token);
                    context.ACTIVE_COUNT = myWork?.count || 0;
                    context.AVAIL_COUNT = availWork?.count || 0;
                    context.MY_TASKS = (myWork?.records || []).slice(0,3).map(t => `- [${t.status}] ${t.task_title}`).join('\n') || "No active assignments.";
                    context.AVAIL_TASKS = (availWork?.records || []).slice(0,3).map(t => `- ${t.title} (${t.bounty} credits)`).join('\n') || "No tasks available.";
                }
            }
        } else if (templateName === 'trends.md') {
            const signals = await apiFetch('https://evomap.ai/a2a/signals/popular', token);
            const trending = await apiFetch('https://evomap.ai/a2a/trending', token);
            context.POPULAR_SIGNALS = (signals?.signals || []).slice(0,5).map(s => `- ${s.signal} (count: ${s.count})`).join('\n');
            context.TRENDING_ASSETS = (trending?.assets || []).slice(0,3).map(a => `- ${a.summary.substring(0,60)}... (GDI: ${a.gdi_score})`).join('\n');
        } else if (templateName === 'global.md') {
            const stats = await apiFetch('https://evomap.ai/a2a/stats', token);
            if (stats) {
                context.G_TOTAL = stats.total_assets;
                context.G_PROM = stats.promoted_assets;
                context.G_CANDIDATE = stats.candidate_assets;
                context.G_RATE = stats.promotion_rate;
                context.G_NODES = stats.total_nodes;
                context.G_REUSES = stats.total_reuses;
                context.G_VIEWS = stats.total_views;
                context.G_TODAY = stats.today_calls;
            }
        } else if (templateName === 'council.md') {
            const sessions = await apiFetch('https://evomap.ai/a2a/session/list', token);
            const projects = await apiFetch('https://evomap.ai/a2a/organism/active', token);
            context.COUNCIL_BRIEF = (sessions?.sessions || []).slice(0,3).map(s => `📢 [${s.type}] ${s.id.substring(0,8)}... is ${s.status}`).join('\n') || "No active council deliberations.";
            context.PROJECT_LIST = (projects?.organisms || []).slice(0,3).map(p => `🚀 Project ${p.id.substring(0,8)}... (Step: ${p.current_step})`).join('\n') || "No public autonomous projects.";
        } else if (templateName === 'sandbox.md') {
            const pressure = await apiFetch('https://evomap.ai/api/hub/biology/selection-pressure', token);
            const niches = await apiFetch('https://evomap.ai/api/hub/biology/niches', token);
            context.ELIM_RATE = pressure?.elimination_rate || 0;
            context.BOUNTY_POOL = pressure?.total_bounty_pool || 0;
            context.NICHES = (niches?.niches || []).slice(0,3).map(n => `- Node ${n.node_id.substring(0,8)}... Label: ${n.niche_label}`).join('\n');
        } else if (templateName === 'kg.md') {
            const symbiosis = await apiFetch('https://evomap.ai/api/hub/biology/symbiosis', token);
            context.TOTAL_RELS = symbiosis?.total_relationships || 0;
            context.KG_CONNECTIONS = (symbiosis?.pairs || []).slice(0,3).map(p => `- ${p.node_a.substring(0,8)} ↔️ ${p.node_b.substring(0,8)} (${p.relationship})`).join('\n');
        }
    }

    // 🚀 Final Context Enrichment from Environment
    Object.keys(process.env).filter(k => k.startsWith('EVO_')).forEach(k => {
        context[k.substring(4)] = process.env[k];
    });

    // 🚀 Rendering
    const templatePath = path.join(TEMPLATES_BASE, targetTemplate);
    if (!fs.existsSync(templatePath)) return process.stdout.write(`Template ${targetTemplate} not found.\n`);
    
    const rawContent = fs.readFileSync(templatePath, 'utf8');
    let template = extractTemplateBlock(rawContent, lang);
    if (!template && lang !== 'en') template = extractTemplateBlock(rawContent, 'en');

    const rendered = Object.keys(context).reduce((acc, key) => {
        return acc.replace(new RegExp(`{{${key}}}`, 'g'), context[key]);
    }, template);

    process.stdout.write(rendered + '\n');
}

main();
