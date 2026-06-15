#!/usr/bin/env node

/**
 * DCIK — Dorsolateral Cognitive Inference Kinetics
 * Claude Code CLI installer.
 * ALWAYS installs from the remote GitHub repo — never from local files.
 */

const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const REPO_URL = 'https://github.com/oxygn-cloud-ai/dcik.git';
const SKILL_DIR = path.join(os.homedir(), '.claude', 'skills', 'DCIK');
const REPO_TAG = 'main';

function run(cmd, args, opts = {}) {
  console.log(`  → ${cmd} ${args.join(' ')}`);
  const result = spawnSync(cmd, args, { stdio: 'inherit', ...opts });
  if (result.error) throw result.error;
  if (result.status !== 0) {
    const err = new Error(`${cmd} exited with code ${result.status}`);
    err.code = result.status;
    throw err;
  }
  return result;
}

function install() {
  console.log('\n🧠 DCIK — Dorsolateral Cognitive Inference Kinetics\n');
  console.log(`Installing from ${REPO_URL} (${REPO_TAG})\n`);

  // Remove existing installation if present
  if (fs.existsSync(SKILL_DIR)) {
    console.log('Removing existing installation...');
    fs.rmSync(SKILL_DIR, { recursive: true, force: true });
  }

  // Clone from remote — never local. spawnSync with arg array prevents injection.
  console.log('Cloning from GitHub...');
  run('git', ['clone', '--depth', '1', '--branch', REPO_TAG, REPO_URL, SKILL_DIR]);

  // ── Installer integrity verification ──────────────────────────────
  // C3: Verify the cloned repo is actually from the canonical source.
  const verifyDir = SKILL_DIR;
  const gitDir = path.join(verifyDir, '.git');

  // 1. Verify the cloned repo's origin URL matches the canonical REPO_URL
  const originUrl = run('git', ['config', '--get', 'remote.origin.url'], {
    cwd: verifyDir,
    stdio: 'pipe',
  }).stdout.toString().trim();
  if (originUrl !== REPO_URL) {
    console.error(`\n❌ INTEGRITY FAILURE: Remote origin mismatch`);
    console.error(`   Expected: ${REPO_URL}`);
    console.error(`   Got:      ${originUrl}`);
    console.error(`   Aborting install — the cloned repository is not from the canonical source.\n`);
    if (fs.existsSync(gitDir)) fs.rmSync(gitDir, { recursive: true, force: true });
    process.exit(1);
  }

  // 2. Verify the HEAD commit is signed
  const verifyResult = run('git', ['log', '-1', '--show-signature', '--format=%H %s'], {
    cwd: verifyDir,
    stdio: 'pipe',
  });
  const verifyOutput = verifyResult.stdout.toString();
  if (!verifyOutput.includes('gpg: Signature') || verifyOutput.includes('gpg: BAD signature')) {
    console.error(`\n❌ INTEGRITY FAILURE: HEAD commit is not properly signed`);
    console.error(`   git log --show-signature output:`);
    console.error(verifyOutput);
    console.error(`   Aborting install — the cloned repository's HEAD commit is not verified.\n`);
    if (fs.existsSync(gitDir)) fs.rmSync(gitDir, { recursive: true, force: true });
    process.exit(1);
  }

  // 3. Extract and print the verified commit hash
  const commitHash = verifyOutput.split('\n').filter(l => l.startsWith('gpg: ')).length > 0
    ? (verifyOutput.match(/^([a-f0-9]{40})\s/m) || [])[1] || 'unknown'
    : 'unknown';
  console.log(`   Verified commit: ${commitHash} (GPG-signed)`);

  // Remove .git directory (gitDir already declared above in verification block)
  if (fs.existsSync(gitDir)) {
    fs.rmSync(gitDir, { recursive: true, force: true });
  }

  // Remove dirs not needed for skill operation
  for (const sub of ['cli', 'desktop']) {
    const subDir = path.join(SKILL_DIR, sub);
    if (fs.existsSync(subDir)) {
      fs.rmSync(subDir, { recursive: true, force: true });
    }
  }

  // Remove files not needed for skill operation
  for (const file of ['package.json', '.gitignore', 'README.md']) {
    const fp = path.join(SKILL_DIR, file);
    if (fs.existsSync(fp)) fs.unlinkSync(fp);
  }

  console.log(`\n✅ DCIK installed at ${SKILL_DIR}`);
  console.log('   Invoke with /DCIK <topic>\n');
}

function uninstall() {
  if (fs.existsSync(SKILL_DIR)) {
    console.log('Removing DCIK...');
    fs.rmSync(SKILL_DIR, { recursive: true, force: true });
    console.log('✅ Uninstalled.\n');
  } else {
    console.log('DCIK is not installed.\n');
  }
}

const cmd = process.argv[2] || 'install';
if (cmd === 'uninstall') uninstall();
else if (cmd === 'install' || cmd === 'update') install();
else {
  console.log('Usage: npx dcik [install|uninstall|update]');
  process.exit(1);
}
