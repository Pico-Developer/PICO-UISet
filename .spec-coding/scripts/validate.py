#!/usr/bin/env python3
"""Spec Coding artifact validator.

Run in CI or locally to verify that all spec-coding requirements
have complete documentation and tokens are valid JSON.

Usage:
    python .spec-coding/scripts/validate.py

Exit codes:
    0 - all checks passed
    1 - one or more checks failed
"""

import os
import sys
import json

SPEC_ROOT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REQ_DIR = os.path.join(SPEC_ROOT, 'requirements')
TOKEN_DIR = os.path.join(SPEC_ROOT, 'specify', 'tokens')
CONSTITUTION_DIR = os.path.join(SPEC_ROOT, 'constitution')

REQUIRED_REQ_FILES = ['plan.md', 'tasks.md', 'implement.md']
REQUIRED_CONSTITUTION = [
    'CODE_SPEC.md', 'HIERARCHY_SPEC.md', 'INTERACTION_SPEC.md',
    'ENV_CHECK.md', 'DOC_TEMPLATE.md', 'WORKFLOW.md'
]
TOKEN_FILES = ['colors.json', 'typography.json', 'spacing.json']
MIN_FILE_SIZE = 50  # bytes, to catch empty placeholders


def check_requirements(errors: list):
    """Check that all REQ-* directories have required files."""
    if not os.path.isdir(REQ_DIR):
        return  # No requirements yet, that's ok

    for entry in sorted(os.listdir(REQ_DIR)):
        if not entry.startswith('REQ-'):
            continue
        req_path = os.path.join(REQ_DIR, entry)
        if not os.path.isdir(req_path):
            continue

        for required in REQUIRED_REQ_FILES:
            fpath = os.path.join(req_path, required)
            if not os.path.exists(fpath):
                errors.append(f'Missing: {entry}/{required}')
            elif os.path.getsize(fpath) < MIN_FILE_SIZE:
                errors.append(f'Too short (likely placeholder): {entry}/{required}')


def check_constitution(errors: list):
    """Check that all constitution files exist."""
    for fname in REQUIRED_CONSTITUTION:
        fpath = os.path.join(CONSTITUTION_DIR, fname)
        if not os.path.exists(fpath):
            errors.append(f'Missing constitution file: {fname}')


def check_tokens(errors: list):
    """Check that token JSON files are parseable."""
    for fname in TOKEN_FILES:
        fpath = os.path.join(TOKEN_DIR, fname)
        if not os.path.exists(fpath):
            errors.append(f'Missing token file: {fname}')
            continue
        try:
            with open(fpath, 'r', encoding='utf-8') as f:
                json.load(f)
        except json.JSONDecodeError as e:
            errors.append(f'Invalid JSON in {fname}: {e}')


def check_implement_selfcheck(errors: list):
    """Warn if any implement.md contains FAIL in self-check."""
    if not os.path.isdir(REQ_DIR):
        return

    for entry in sorted(os.listdir(REQ_DIR)):
        if not entry.startswith('REQ-'):
            continue
        impl_path = os.path.join(REQ_DIR, entry, 'implement.md')
        if not os.path.exists(impl_path):
            continue
        with open(impl_path, 'r', encoding='utf-8') as f:
            content = f.read()
        if '| FAIL |' in content or '|FAIL|' in content:
            errors.append(f'Self-check FAIL found in {entry}/implement.md')


def main():
    errors = []

    check_constitution(errors)
    check_tokens(errors)
    check_requirements(errors)
    check_implement_selfcheck(errors)

    if errors:
        print('Spec Coding validation FAILED:')
        for e in errors:
            print(f'  \u2717 {e}')
        sys.exit(1)
    else:
        print('Spec Coding validation PASSED \u2713')
        print(f'  - Constitution: {len(REQUIRED_CONSTITUTION)} files OK')
        print(f'  - Tokens: {len(TOKEN_FILES)} files OK')
        req_count = len([d for d in os.listdir(REQ_DIR) if d.startswith('REQ-')]) if os.path.isdir(REQ_DIR) else 0
        print(f'  - Requirements: {req_count} checked')
        sys.exit(0)


if __name__ == '__main__':
    main()
