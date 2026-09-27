# Lessons learned — Pipe cross clamp (msf-3dp-design skill)

**Session:** 26 Sep 2026 · **Item:** `pipe_cross_clamp` v1.0 → v1.5 · **Skill package:** msf-3dp-design v1.2.0 + updated MSF Project instructions (26 Sep 2026) · **Requester:** MSF 3D Printing Advisor (skill owner) · **Tooling:** OpenSCAD 2021.01 (CGAL), check_stl.py, sweep.py, manifold3d 3.5.4, single-CPU sandbox

Purpose: feed `references/lessons.md` (§13) and the skill files named below. Section 1 is a ready-to-paste register row; sections 3–7 give each lesson with its evidence and the proposed change; the appendix holds the script patches as diffs.

---

## 1. Register row (paste into references/lessons.md §13)

| Project | Lesson → rule |
|---|---|
| Pipe cross clamp, fixed angle (v1.0–1.4) | Requester review, not the automated checks, caught the structural faults — add a structural review (load path vs layers, fastener pattern, thinnest loaded section) before release; never clamp with two diagonal bolts — two per side of each clamped member, never collinear; never put bolt load into a thin wing joining a taller block at an inside corner (layers peel) — solid convex caps, counterbores, captive nuts; check the section over a V apex (wedge spreading: 4 mm ≈ 50 MPa → 10 mm ≈ 9 MPa); corner radii adapt to nearby seats and slots; square-ended seat blocks + a 45° transition sized from the exact rounded outline (no knife edges at oblique ends); hull only adjacent slabs (one hull over both chamfer flares widened a gauge notch 1.4–1.8 mm); section every height band, including the top face where two chamfers meet; Customizer spec alone after the value, description on the line above; lists for choices, sliders for numbers, an "all printable parts" plate option; sweep.py mis-read labelled lists and export/sweep assumed one body per STL — patched; background jobs die at turn end — sweeps need resume |

---

## 2. Original prompt and request timeline

**Original prompt (verbatim):**

> Create a parametric pipe clamp to attach two different pipes of different sizes together, under various angles.

**Follow-up requests (verbatim, in order):**

| # | Requester message | What it led to |
|---|---|---|
| 1 | "Fixed angle" | Concept A chosen (angle fixed per print). Rounds 1 questions 1–2 left unanswered. |
| 2 | "1 A / 2 A / 3 Make options with M6 bolts and 6mm zip ties as options" | Generic non-clinical tool, Ø10–60 range, two closures from one file |
| 3 | "yes proceed" | Summary approved; brief v0.1 written (filament question unanswered) |
| 4 | "proceed" | Build v1.0 (took four turns: tool-call limit hit three times) |
| 5 | "We have updated the skill update the design and documentation accordingly" | v1.1: new Project-instruction rules applied (the skill package itself had not changed) |
| 6 | "when selecting the part I prefer list not to write physically, when selecting number I want slider where it make sense" | v1.2: Customizer widgets fixed; sweep.py bug found |
| 7 | "also ensure that for part selection we have option to select all printable parts" | v1.3: all-parts print plates; export/sweep multi-body patch |
| 8 | "But now the geometry of the caps is bad - it will never be strong enough to really hold the pipe, and it will be wobblly, also when the bolts will be tightened the wings of the cap will separate in between layers. Enhance the geometry of the part" | v1.4: 4 through-bolts, solid caps, counterbores, captive nuts |
| 9 | "Create the file lessons learned where you summarize the lessons learned in this session including the original prompt, to be used to improve claude skill" | This file |
| 10 | "in customizer version you need to sctrictly follow the customizer pattern. this is missing information about // @name … // @description … // @category … // @credit … // @license …" | v1.5: metadata header added and enforced by the generator (lesson C8) |

**Outcome:** v1.4 delivered as a zip: part `.scad` + one-file Customizer version + context scene + coupon; 10 STLs (body, 2 caps, zip-tie body, 2 numbered gauges, coupon, 3 print plates); visual README + full DATASHEET + STATUS; sweep reports (latest: 154 cases, 151 PASS / 3 GUARD / 0 FAIL); all STLs Manifold-valid. **Not printed yet** — every fit and all strength figures are unconfirmed.

---

## 3. Structural design lessons (highest value)

| # | What happened | Root cause | Proposed skill change | Priority |
|---|---|---|---|---|
| D1 | v1.0–1.3 caps were held by **two diagonal bolts** — every clamping force on one line, so the clamp could rock about it. Found by the requester, not by any check. | No rule on fastener patterns; all checks are geometric (manifold, overhang, walls), none structural. | design-rules.md §5: "A clamped part gets ≥ 2 fasteners on each side of each clamped member; no three fasteners collinear with the clamp axis; the resultant passes through the clamped centre." Solution used: 4 through-bolts, layout "corners" (one per quadrant) or "pairs" (along the bisector), whichever is more compact. | High |
| D2 | Cap **wings** (6 mm flat lobe) joined a 25 mm hump at a right angle; tightening bends the wing about that root, pulling across the layers → delamination (requester's finding). | Flange-plus-block pattern taken from machined parts; no rule linking bolt load, inside corners and layer direction. | design-rules.md §5: "Never put bolt or clamp load into a thin wing that joins a taller block at an inside corner. Make the part one solid convex body (hull), seat bolt heads in counterbores and nuts in captive wells, and check that the load path runs along the layers." | High |
| D3 | 4 mm over the V apex: the 90° V wedge pushes the two cap halves apart — hand estimate ≈ 50 MPa (v1.4 with 10 mm: ≈ 9 MPa). | The weakest loaded section was not identified; the minimum-wall check treated it as "thick enough" (> 1.8 mm). | verification.md §10: add **T22 structural review** — name the load path, the thinnest *loaded* section, its stress by hand, and the layer direction there; the minimum-wall rule is not a strength check. design-rules.md: V-seat clamps need ≥ 10 mm over the apex by default (or a computed value). | High |
| D4 | Corner radius R4 thinned the seat-end wall to **0.25 mm** (v1.0) and the wall beside the upper tie slots to **≈ 0.9 mm** at the defaults (v1.1). The second was missed by the first sweep: sections were only at Z 2 and 10 mm, below those slots. | Fixed corner radius independent of nearby features; fixed absolute section heights. | design-rules.md: corner radius = the largest value up to `corner_r` that keeps `struct_wall` to every seat and slot (implemented as `best_r()`); verification.md T19: sections through **every height band that holds a feature**, including 0.3 mm below the top face (or relative sections, see T3). | High |
| D5 | A convex hull outline crossing a seat obliquely leaves **knife edges** at the seat mouth; at small angles they become very acute. | Hull of all features used as one outline. | design-rules.md: each seat lives in a block whose ends are square to the seat; blocks at different heights are joined by a 45° transition whose height ≥ the overhang distance. | Medium |
| D6 | The transition height, computed from sharp rectangle corners, gave **45.7°** at `seat_len2 = 80`. | Rounded corners shrink the lower outline diagonally by up to r(√2 − 1). | Compute overhang distances from the exact support function of the rounded outline (implemented as `supp1()`). | Medium |
| D7 | The seat gauge notch was **1.4–1.8 mm oversize through the whole plate** because one `hull()` spanned both face chamfer flares. It passed every check at 90° and failed only at 60° (plate split in two). | Chamfer-by-hull pattern applied over three slabs. | openscad-environment.md / helpers.scad: "hull only adjacent slabs (bottom flare, straight part, top flare separately)"; add a `flared_cutter()` helper; measure one critical fit on the exported STL (probe points) in T20. | High |
| D8 | At the top of cap 2, a nut-well lead-in chamfer and the outline top chamfer met: wall **1.15 mm**. | Two chamfers eating the same wall. | design-rules.md: bosses around wells = well radius + `bolt_wall` + 2 × `chamfer_top`; section 0.3 mm below every top face. | Medium |
| D9 | A cap lobe silently vanished (3 bodies): `rounded_rect()` with r = half the height gives a zero-height square. | Helper accepts r ≥ min(size)/2 without complaint. | helpers.scad: clamp r to `min(size)/2 − 0.01` or assert. | Medium |
| D10 | Wide zip ties were refused by a guard although the bend radius could simply grow. | Guard where geometry could adapt. | Confirms the existing rule "adapt geometry where it can; guard only impossible geometry" — cite this case. | Low |
| D11 | Good patterns confirmed: 90° V-seats print on any face without supports and centre oval pipes; through-bolt positions computed for any angle; captive nuts in the top cap need only one tool; gabled tie channels print without bridges. | — | Add to design-rules.md as reusable patterns (V-seat clamp, captive-nut cap, gabled internal channel). | Low |

---

## 4. Customizer and deliverable lessons

| # | What happened | Proposed skill change | Priority |
|---|---|---|---|
| C1 | Every parameter showed as a **text box**: the description was written after the `[spec]` on the same line, which stops OpenSCAD building the widget. `scad/test_coupon.scad` in the skill has the same fault. | openscad-environment.md §6: "The comment after a value is only the `[spec]`; the description goes on the line above (it becomes the label)." Fix `test_coupon.scad`. Ship `fix_customizer_comments.py` (in this package's tools/). Add a lint to check_stl/sweep or export.sh that flags trailing text. | High |
| C2 | Requester preference: **choices as lists, numbers as sliders**; labelled lists `[value:Label, …]`; numeric lists where a slider would offer invalid values (bolt M5 / M6 / M8 — no M7); booleans as checkboxes. | openscad-environment.md: make it the default Customizer style. | High |
| C3 | Requester preference: the part list always offers **all printable parts** on one plate. Implemented as "All clamp parts – one print plate" and "+ 2 gauges", shelf layout on the 250 × 210 mm MK4S bed with a 5 mm margin, `plate_gap` slider, guard when it does not fit. | deliverables.md §11: every multi-part item has an "all parts" plate option and ready plate STLs; identical items as numbered files (`gauge_1`, `gauge_2`). Consider a shared `print_plate()` helper. | High |
| C4 | A hidden internal switch (`build_part = true`) was swept as a boolean and produced an empty STL. | Internal switches are expressions (`is_undef(...)`), never literal booleans, so the Customizer and sweep ignore them. | Medium |
| C5 | The one-file Customizer version (new rule) was generated by inlining `common.scad` (tab markers stripped, under `[Hidden]`) and `helpers.scad` (at the end). Mesh-identical to the multi-file version. | Ship `make_customizer.py` in scripts/; state "regenerate after every edit" in deliverables.md. | Medium |
| C6 | `use <part.scad>` in the context scene ignores `-D` overrides passed by render_views.py (the zip-tie context would show the bolt variant). | context_scene.scad template: `pcc_context = true;` **before** `include <part.scad>`, part build guarded by `is_undef(pcc_context)`. | Medium |
| C8 | The one-file Customizer version lacked the **Customizer metadata header** the requester's Customizer expects: `// @name:`, `// @description:`, `// @category:`, `// @credit:`, `// @license:` as the first five lines, in that order. The skill does not mention it. | openscad-environment.md / deliverables.md: make the header mandatory for every one-file Customizer version; keep the values in `customizer_meta.txt`; `make_customizer.py` validates presence, order and single-line values (done in this package). Resolve the conflict with "no licence statements in generated documents": `@license` is required metadata — state which licence MSF uses. | High |
| C7 | New Project rules applied in v1.1: short visual README + full DATASHEET; no licence statements (LICENSE file removed); follow-up schedule 2 weeks / 1 month / 3 months (proposed, advisor validates); Humanitarian Making readiness scale — **file `references/readiness-levels.md` missing**, levels left pending rather than invented. | Add `readiness-levels.md` to the package; update README_TEMPLATE into README (visual) + DATASHEET templates; remove the licence field from templates. | High |

---

## 5. Tooling lessons (scripts)

| # | What happened | Proposed change | Priority |
|---|---|---|---|
| T1 | `sweep.py` read any spec containing `:` as a **range**, so labelled lists (`[body:Body, …]`) were mis-read as 1–2 or skipped (parts and closures silently untested); numeric list values were quoted as strings. | Merge the patch (appendix A): a range is numbers only; quote only string parameters. | High |
| T2 | `export.sh` and `sweep.py` assume **one body per STL** — every multi-part plate would fail falsely. | Merge the patch (appendix A/B): a model may announce `echo("CHECK expect_bodies=N max_size=M")`; both scripts pass it to check_stl.py. | High |
| T3 | Fixed absolute section heights missed the upper tie slots (D4) and top-face walls (D8). | check_stl.py: `--sections auto` (every 2–3 mm plus 0.3 mm below the top) or relative values (`25%,50%,90%,top-0.3`). | High |
| T4 | Sweeps on one CPU: 6 parallel processes gave ~3 cases/min and a 180 s timeout (false FAIL); background jobs **stop when the conversation turn ends** (happened 3 times); `sweep.py` writes its report only at the end. | sweep.py: stream the report line by line, `--resume <log>` to skip finished cases, run sequentially by default, and a "focused" mode (parameters that affect the changed parts). verification.md: plan heavy sweeps within one turn or in resumable chunks. | High |
| T5 | Documentation-only and UI-only versions (v1.1–1.3) re-used earlier sweeps by proving the STLs **mesh-identical** (sorted-triangle comparison) — saved ~30 min per version. | Ship `compare_meshes.py`; verification.md: "if every exported mesh is identical to the verified version, earlier sweeps carry over". | Medium |
| T6 | `openscad-fast` (Manifold) not available in the sandbox; the snapshot host is unreachable. `manifold3d` installs from PyPI and validated every STL (status, volume, genus = designed openings). | install_openscad.sh: fall back to `pip install manifold3d` and add a Manifold validation step to export.sh. | Medium |
| T7 | `export.sh` sometimes did not write the coupon STL (timeout while other jobs ran) — noticed only by listing the folder. | export.sh: fail loudly if any expected STL is missing; print a final table of files. | Medium |
| T8 | Shell pitfalls cost turns: `pkill -f <pattern>` killed the running shell (its own command line matched); `eval` stripped the quotes from `-D closure="zipties"`; `<<<` unsupported by `/bin/sh`. | openscad-environment.md tips: use `pgrep -f "[p]attern"`; wrap loops in bash scripts; never `eval` `-D` strings. | Low |

---

## 6. Process lessons

| # | What happened | Proposed change | Priority |
|---|---|---|---|
| P1 | The owner's review caught structural faults (D1–D3) that 350 automated cases passed. | T22 structural review (D3) before any release; show the requester a section view of load-bearing parts and ask "where does it bend, where could layers peel?" | High |
| P2 | Skill package out of sync: Project instructions carried new rules, but the package was still v1.2.0, its `docs/PROJECT_INSTRUCTIONS.md` held the old text, `readiness-levels.md` was missing. | Bump the package version with every rule change; keep one source for the instructions; a release checklist verifying referenced files exist. | High |
| P8 | A summary reported "13 STLs" when the package held 10 — a label typed into a check script, not a count. | Print counts from the file system (`ls | wc -l`), never from memory. | Low |
| P3 | Four turns ended at the tool-call limit before delivery (v1.0, v1.4). The hand-over messages kept the state honest, but the requester had to type "continue" repeatedly. | deliverables.md: budget tool calls per turn (model + check ≈ 10, sweep polls ≈ 1 per 5 min); deliver a partial zip at the end of a turn when the core files are verified; STATUS.md updated before long waits. | Medium |
| P4 | At the start of one turn, the sandbox held an **unfinished v1.4** from an interrupted earlier attempt at the same request. It was found by comparing the file with the last delivered zip, reviewed and built on — not silently shipped. | SKILL.md: at the start of every turn, compare the working files with the last delivered package (time stamps, diff); treat unknown changes as an unverified draft. | Medium |
| P5 | Intake ran as typed lettered rounds; the updated rules require the option picker, all questions at the start, measurements last with a drawing. The concept choice (fixed vs swivel) with a sketch before any measurement worked well. | Keep "concept first, with a sketch" in Round A; enforce the option picker per the new instructions. | Low |
| P6 | The filament question went unanswered twice; the design proceeded for PLA as the weaker candidate and said so. | Confirms §3.5; add "record unanswered questions as defaults in the brief, not as silent assumptions". | Low |
| P7 | Hand estimates stated in the DATASHEET with their inputs (bolt preload, μ = 0.3, V wedge factor), and the test before use (4 kg, 10 min) to confirm them. | Confirms the approach; add a hand-estimate template for bolted V clamps to design-rules.md. | Low |

---

## 7. Summary of proposed skill changes by file

| File | Change | From |
|---|---|---|
| references/design-rules.md | Fastener pattern rule; no loaded thin wings; solid hulls + counterbores + captive nuts; ≥ 10 mm over V apex; adaptive corner radius; square seat ends + computed 45° transition; boss sizing with double chamfers; reusable patterns | D1–D8, D11, P7 |
| references/verification.md | T22 structural review; sections through every height band and the top face; mesh-identity carry-over; plan resumable sweeps | D3, D4, T3–T5, P1 |
| references/openscad-environment.md | Customizer metadata header (@name, @description, @category, @credit, @license); Customizer comment rule; lists/sliders style; internal switches as expressions; hull only adjacent slabs; shell tips | C1, C2, C4, D7, T8 |
| references/deliverables.md | All-parts plate option; numbered identical STLs; one-file Customizer regeneration; README + DATASHEET; no licence text; partial zip at turn end | C3, C5, C7, P3 |
| references/readiness-levels.md | Add the missing file (Humanitarian Making scale, verbatim, MSF interpretation) | C7 |
| scad/helpers.scad | Clamp `rounded_rect` radius; add `flared_cutter()`, `print_plate()`, `best_corner_r()` | D7, D9, C3, D4 |
| scad/test_coupon.scad, scad/context_scene.scad | Fix Customizer comments; include-with-guard pattern | C1, C6 |
| scripts/sweep.py | Labelled lists, numeric list quoting, CHECK echo, streaming report, `--resume`, sequential default | T1, T2, T4 |
| scripts/export.sh | CHECK echo, fail on missing STL, Manifold validation | T2, T6, T7 |
| scripts/check_stl.py | `--sections auto` / relative sections | T3 |
| scripts/ (new) | `fix_customizer_comments.py`, `make_customizer.py`, `compare_meshes.py` | C1, C5, T5 |
| SKILL.md, docs/PROJECT_INSTRUCTIONS.md, README.md | Version bump, single source for instructions, start-of-turn diff check | P2, P4 |

---

## Appendix A — sweep.py patch (applied in this item's tools/sweep.py)

```diff
--- skill/scripts/sweep.py	1980-01-01 00:00:00.000000000 +0000
+++ tools/sweep.py	2026-09-26 13:18:09.252568493 +0000
@@ -43,7 +43,8 @@
         info = {"default": default, "kind": "other"}
         if default in ("true", "false"):
             info["kind"] = "bool"
-        elif ann and ":" in ann:
+        elif ann and re.fullmatch(r"\[\s*-?\d+(?:\.\d+)?(?:\s*:\s*-?\d+(?:\.\d+)?){1,2}\s*\]", ann.strip()):
+            # a range is [min:max] or [min:step:max], numbers only; [value:Label, ...] is a labelled dropdown
             nums = [float(x) for x in re.findall(r"-?\d+(?:\.\d+)?", ann)]
             if len(nums) >= 2:
                 info["kind"] = "range"
@@ -65,7 +66,8 @@
     """Format a -D value: strings quoted, others as given."""
     v = str(value)
     kind = params.get(name, {}).get("kind")
-    if kind in ("dropdown", "string") and not v.startswith('"') and v not in ("true", "false"):
+    is_str = params.get(name, {}).get("default", '"').startswith('"')   # numeric dropdowns stay unquoted
+    if kind in ("dropdown", "string") and is_str and not v.startswith('"') and v not in ("true", "false"):
         v = f'"{v}"'
     return f"{name}={v}"
 
@@ -106,7 +108,9 @@
     secs = round(time.time() - t0, 1)
     if rc == 0 and os.path.exists(stl) and os.path.getsize(stl) > 84:
         warn = [l for l in out.splitlines() if l.startswith("WARNING")]
-        return {"name": case["name"], "status": "PASS", "reason": "; ".join(warn[:3]), "stl": stl, "seconds": secs}
+        ce = re.search(r"CHECK expect_bodies=(\d+) max_size=([\d.]+)", out)   # multi-part print plate
+        ca = {"expect_bodies": int(ce.group(1)), "max_size": float(ce.group(2))} if ce else {}
+        return {"name": case["name"], "status": "PASS", "reason": "; ".join(warn[:3]), "stl": stl, "seconds": secs, "check_args": ca}
     m = re.search(r"ERROR: Assertion.*?(?:\n|$)", out)
     if m:
         return {"name": case["name"], "status": "GUARD", "reason": m.group(0).strip(), "stl": None, "seconds": secs}
@@ -149,7 +153,7 @@
                 sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
                 from check_stl import check_file
                 secs = [float(z) for z in a.sections.split(",") if z.strip()] if a.sections else []
-                chk = check_file(r["stl"], sections=secs, allow_bridges=a.allow_bridges)
+                chk = check_file(r["stl"], sections=secs, allow_bridges=a.allow_bridges, **r.get("check_args", {}))
                 if not chk["ok"]:
                     r["status"] = "FAIL"
                     r["reason"] = "check_stl: " + "; ".join(chk["fail"])
```

## Appendix B — export.sh patch (applied in this item's tools/export.sh)

```diff
--- skill/scripts/export.sh	1980-01-01 00:00:00.000000000 +0000
+++ tools/export.sh	2026-09-26 13:18:09.252349510 +0000
@@ -37,6 +37,9 @@
   grep -E "^(WARNING|ECHO)" "$DIR/stl/${name}.log" | head -20
   local chk=(python3 "$HERE/check_stl.py" "$stl" --json "$DIR/stl/${name}.check.json")
   [ -n "${SECTIONS:-}" ] && chk+=(--sections "$SECTIONS")
+  # a multi-part print plate announces its own limits: ECHO: "CHECK expect_bodies=N max_size=M"
+  local ce; ce="$(grep -oE 'CHECK expect_bodies=[0-9]+ max_size=[0-9.]+' "$DIR/stl/${name}.log" | head -1)"
+  [ -n "$ce" ] && chk+=(--expect-bodies "$(echo "$ce" | sed -E 's/.*expect_bodies=([0-9]+).*/\1/')" --max-size "$(echo "$ce" | sed -E 's/.*max_size=([0-9.]+).*/\1/')")
   [ -n "${ALLOW_BRIDGES:-}" ] && chk+=(--allow-bridges)
   if ! "${chk[@]}"; then FAIL=1; echo "FAIL check $name" >> "$LOG"; else echo "ok    $name  $(basename "$stl")  [$defs]" >> "$LOG"; fi
   if [ -z "${NO_RENDERS:-}" ]; then
```

The new helper scripts `fix_customizer_comments.py` and `make_customizer.py` are in `tools/` of `pipe_cross_clamp_v1.4.zip`.
