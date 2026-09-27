#!/usr/bin/env python3
"""Build the one-file Customizer version: metadata header from customizer_meta.txt (@name, @description, @category,
@credit, @license - in that order, first lines of the file), then the part file with common.scad and helpers.scad inlined.
common.scad values go under one [Hidden] tab (as in the multi-file version, where included files never show in
the Customizer); helpers.scad definitions go at the end (OpenSCAD hoists modules and functions).
Usage: python3 tools/make_customizer.py pipe_cross_clamp.scad pipe_cross_clamp_customizer.scad"""
import re, sys
src, out = sys.argv[1], sys.argv[2]
part = open(src).read()
common = re.sub(r'/\*\s*\[[^\]]*\]\s*\*/', '', open('common.scad').read())      # drop its tab markers
helpers = open('helpers.scad').read()
assert 'include <common.scad>' in part and 'include <helpers.scad>' in part
hdr_end = part.index('include <common.scad>')
head, body = part[:hdr_end], part[hdr_end:]
body = body.replace('include <common.scad>\n', '').replace('include <helpers.scad>\n', '')
# Customizer metadata header: exactly these five tags, in this order, one line each, at the very top
META_KEYS = ['name', 'description', 'category', 'credit', 'license']
meta = [l.rstrip('\n') for l in open('customizer_meta.txt') if l.strip()]
import re as _re
assert len(meta) == 5, f'customizer_meta.txt must have exactly 5 lines, found {len(meta)}'
for key, line in zip(META_KEYS, meta):
    m = _re.fullmatch(r'// @' + key + r': (\S.*)', line)
    assert m, f'customizer_meta.txt: expected "// @{key}: <value>", found: {line!r}'
res = ('\n'.join(meta) + '\n\n' + head.replace('pipe_cross_clamp_customizer.scad (same geometry, no includes - for online Customizers)',
                    'this file - generated from pipe_cross_clamp.scad by tools/make_customizer.py; do not edit by hand')
       + '/* [Hidden] */\n// ===== inlined from common.scad (shop defaults, not Customizer settings) =====\n' + common
       + '\n// ===== end of common.scad =====\n\n' + body
       + '\n\n// ===== inlined from helpers.scad =====\n' + helpers + '\n// ===== end of helpers.scad =====\n')
open(out, 'w').write(res)
print('wrote', out, len(res.splitlines()), 'lines')
