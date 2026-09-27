#!/usr/bin/env python3
"""Make every Customizer parameter a real widget: OpenSCAD only builds a dropdown / slider when the comment after the
value is nothing but the [spec]. Moves any description to the line above (the Customizer shows it as the label).
Usage: python3 tools/fix_customizer_comments.py file.scad [name=[spec] ...]   (optional spec overrides)"""
import re, sys
path, overrides = sys.argv[1], dict(a.split('=', 1) for a in sys.argv[2:])
out, hidden = [], False
pat = re.compile(r'^(\s*)([A-Za-z_]\w*)(\s*=\s*[^;]+;)\s*//\s*(\[[^\]]*\])?\s*(.*?)\s*$')
for line in open(path).read().split('\n'):
    if re.match(r'^\s*/\*\s*\[Hidden\]\s*\*/', line): hidden = True
    elif re.match(r'^\s*/\*\s*\[', line): hidden = False
    m = pat.match(line)
    if m and not hidden and not line.lstrip().startswith('//'):
        ind, name, assign, spec, desc = m.groups()
        spec = overrides.get(name, spec)
        if desc: out.append(f'{ind}// {desc[0].upper() + desc[1:]}')
        out.append(f'{ind}{name}{assign}' + (f' // {spec}' if spec else ''))
    else:
        out.append(line)
open(path, 'w').write('\n'.join(out))
