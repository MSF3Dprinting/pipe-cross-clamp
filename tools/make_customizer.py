#!/usr/bin/env python3
"""Build the one-file Customizer version: inline common.scad and helpers.scad into the part file.
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
res = (head.replace('pipe_cross_clamp_customizer.scad (same geometry, no includes - for online Customizers)',
                    'this file - generated from pipe_cross_clamp.scad by tools/make_customizer.py; do not edit by hand')
       + '/* [Hidden] */\n// ===== inlined from common.scad (shop defaults, not Customizer settings) =====\n' + common
       + '\n// ===== end of common.scad =====\n\n' + body
       + '\n\n// ===== inlined from helpers.scad =====\n' + helpers + '\n// ===== end of helpers.scad =====\n')
open(out, 'w').write(res)
print('wrote', out, len(res.splitlines()), 'lines')
