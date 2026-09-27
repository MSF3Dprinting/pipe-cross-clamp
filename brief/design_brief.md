# Design brief — Pipe cross clamp, fixed angle (`pipe_cross_clamp`)

**Request:** number to be assigned · MSF 3D Printing Advisor (owner) · 2026-09-26 · Brief version 0.1
**Written against:** msf-3dp-design skill v1.2.0 · **Personal data:** none (no uploads)

## 1. Item
- Purpose (one line): a parametric clamp that joins two pipes of different diameters crossing at a fixed angle θ chosen in the Customizer, fitted onto pipes already in place.
- Area of use and users: non-clinical (logistics, workshops, non-clinical hospital areas, training). Printed by trained 3D printing staff and fitted by technicians or logisticians.
- Criticality (§4): **in scope** as a generic, non-clinical tool. Every deployment gets its own scope check (README). Use in a patient area, above a patient, or carrying a device → critical item (§4.2 / §4.1c) with its own approval before use.
- Existing designs and OEM parts found (§3.2): no MSF design. UMS V1 has only single-pole vertical attachments (20 / 25 mm). The public designs found are single-pipe saddle and split clamps, clamps that stack pipes in parallel, and n-way socket fittings (pipe ends only). None clamps two different diameters at a chosen crossing angle, so this is a new design.

## 2. Design assumptions
- **Function:** pipe 1 lies in a seat on the underside of a central **body** and pipe 2 in a seat on its top side. Their axes cross at θ, one above the other, with a solid web between them. Each pipe is closed by one of two variants, chosen with a Customizer switch:
  - **Bolt variant** (3 printed parts: body, cap 1, cap 2). Two **through-bolts** pass through cap 1, the body and cap 2, so one pair of bolts clamps both pipes at once. No nut traps are needed; the head and nut bear on the cap flanges with washers. The bolt positions are computed for every θ: they sit as close to the crossing as the clearance around both pipes allows, one on each side of each pipe.
  - **Zip-tie variant** (1 printed part: body only). Each pipe is held by two zip ties, one on each side of the crossing. Each tie runs through a U-shaped channel inside the body: up a slot beside the seat, over the seat, and down the other side. The channels have radiused bends so a tie threads through by pushing, and the two pipes' channels sit at different heights so they never collide, whatever θ is.
- **Seat shape — V-seat, not a round saddle** (default 90° included angle). Each pipe sits in a V-seat in the body and, in the bolt variant, a matching V-seat in the cap, giving four contact lines. It is self-centring, it tolerates oval pipes and diameter variation, and a 90° V prints on any face without supports (its faces are at 45°). Above the contact points the seat continues with vertical walls at pipe radius + clearance, which keeps the part narrow.
- **Loads and their direction:** positioning load up to 2 kg, hanging or side-pulled, with no person leaning or pulling on it. At this load the clamp holds by friction in the V-seats: bolt preload in the bolt variant, tie tension in the zip-tie variant.
- **Fit type per interface:**
  - Pipe in seat: self-centring V with 1.0 mm clearance per side at the seat mouth.
  - Bolt variant: 3.0 mm clamping gap between cap and body at the nominal diameter; the bolts close it.
  - Bolt holes: M6 + 0.6 mm = Ø6.6 printed vertically (0.4 mm clearance + 0.2 mm vertical-hole compensation).
  - Zip-tie channels: tie width + 1.0 mm by tie thickness + 1.0 mm.
- **Mating part variation — tolerance envelope:** in the bolt variant each seat accepts about −2 mm to +2 mm on the set diameter; the lower limit is where the gap closes and the upper is the seat mouth clearance. The zip-tie variant accepts about −3 mm to +2 mm. Outside that range, change the parameter and reprint. The README carries the envelope table.
- **Mating hardware:**
  - Bolt variant: 2 × M6 bolts (M5 selectable) with 2 nuts and 4 washers; M6 threaded rod cut to length plus 4 nuts also works. The console and README state the minimum bolt length for each size combination (about M6 × 70 for the defaults).
  - Zip-tie variant: 4 × 6 mm zip ties.
- **Materials acceptable, in order:** the shelf is not yet confirmed, so the part is designed for the weaker candidate (PLA).
  1. PETG: preferred; tougher and creeps less under bolt preload.
  2. PLA: acceptable indoors below 40 °C; bolts may need re-tightening after the first week.
  3. ASA or PC Blend: outdoor or above 50 °C only, via the advisor.
  
  TPU is not suitable (too soft to hold the angle). One material per part.
- **Environment:** room temperature; wiped with Surfanios, bleach or IPA (assumed); indoor. Outdoor use or UV → PETG or ASA and a new check.
- **Print orientation:**
  - Body: flat, with the pipe 1 seat opening downwards. That seat's V apex acts as a 45° pointed roof, and the pipe 2 seat opens upwards with a flat floor. All bolt holes and tie slots are vertical, so there are no horizontal holes. The tie channels' horizontal runs have a 45° gabled roof.
  - Caps: face down, seat opening downwards (pointed V roof). The flanges rest on the bed and the hump rises above them.
  - Result: every part sits flat on Z = 0, prints without supports, and every overhang is ≤ 45°.
- **Layout assumptions:** the pipe ends are not accessible, so everything fits on from the side. The pipes cross one above the other. θ covers 0–90°; a crossing at 180° − θ uses the same clamp, mirrored. θ = 0° gives two parallel pipes stacked.

## 3. Shape and size
- **Overall size (defaults Ø32 / Ø25, θ = 90°, bolt variant):**
  - Body: about 55 × 60 × 38 mm.
  - Caps: about 60 × 30 × 25 mm (cap 1) and 50 × 25 × 21 mm (cap 2).
  - Largest configuration (Ø60 / Ø60): body about 100 × 110 × 75 mm, within 200 mm.
- **Feature list:**
  - Body plan outline = the convex hull of both seat footprints and both bolt bosses (or tie slots), with rounded vertical edges (R ≥ 4 mm).
  - V-seats run straight through the body along each pipe axis.
  - Top edges get a 45° chamfer of 0.8 mm; bottom edges and seat mouths on the bed get a 0.4 mm chamfer against elephant's foot.
  - Caps: a hump with the V-seat over the pipe, plus flat flanges at the face with washer bearing (Ø14 boss). The flange is 6 mm thick so the bolt stack stays short.
  - No text on the part by default. An optional raised size label (e.g. "32×25 90°") can be switched on for non-clinical use only.
  - Strength in the geometry: the web between the seats is ≥ 5 mm solid and the flanges ≥ 6 mm, so both are filled by perimeters and solid layers at the default 2-perimeter / 15 % profile.
- **Colour bands:** none. Any colour for non-clinical use; a light colour if the clamp ever goes into a clinical area.

## 4. Parameters the user can change
| Parameter | Default | Range | What it changes |
|---|---|---|---|
| `pipe1_d` | 32 **UNVERIFIED** | 10–60 mm | outside diameter of pipe 1 (bottom seat); measure with calipers |
| `pipe2_d` | 25 **UNVERIFIED** | 10–60 mm | outside diameter of pipe 2 (top seat); measure with calipers |
| `angle` | 90 | 0–90° | crossing angle θ between the pipe axes |
| `closure` | "bolts" | bolts / zipties | closing method |
| `bolt_d` | 6 | 5–8 mm | bolt size (M5 / M6 / M8) |
| `bolt_clear` | 0.4 | 0.2–1.0 mm | extra on the bolt hole diameter (set from the coupon) |
| `washer_d` | 12 | 10–20 mm | washer outside diameter → boss size |
| `tie_w` | 6.0 **UNVERIFIED** | 2.5–9 mm | zip-tie width |
| `tie_t` | 1.6 **UNVERIFIED** | 0.8–2.5 mm | zip-tie thickness |
| `tie_clear` | 0.5 | 0.3–1.0 mm | clearance per side in the tie channel (set from the coupon) |
| `seat_len1`, `seat_len2` | 30 | 20–80 mm | seat length along each pipe (grip) |
| `v_angle` | 90 | 60–90° | V-seat included angle (≤ 90° keeps the downward seat ≤ 45°) |
| `seat_clear` | 1.0 | 0.5–3 mm | clearance per side at the seat mouth |
| `clamp_gap` | 3.0 | 1–5 mm | cap-to-body gap at the nominal diameter (bolt variant) |
| `web` | 5 | 3–10 mm | solid material between the two seats |
| `flange_t` | 6 | 4–10 mm | cap flange thickness |
| `size_label` | false | true / false | raised size text on a side face (non-clinical only) |

## 5. Changed from the request
| Request said | Reading taken / change made | Constraint that forced it |
|---|---|---|
| "under various angles" | Fixed angle per print, θ 0–90° in the Customizer (your choice in Round 1); 180° − θ is the same clamp | strength, printability, and your decision |
| pipe clamp (round saddles implied) | 90° V-seats with 4 contact lines | tolerance of oval and varying pipes; prints on any face without supports |
| M6 bolts | Two through-bolts clamp both pipes; bolt size is a parameter (M6 default, M5 from the kit selectable); threaded rod allowed | fewest bolts, no nut traps, no horizontal holes |
| one-piece clamp (Round 1 option A) | The zip-tie variant is one piece. The bolt variant is body + 2 caps, because pipes already in place need an opening seat. The angle stays fixed in the body. | the pipe ends are not accessible |
| filament (not answered) | Designed for PLA as the weaker candidate; README lists PETG first | §3.5 — shelf unknown |

## 6. Defaults relied on (tagged (default) — please confirm)
- Positioning load ≤ 2 kg, test at 2 × = 4 kg (default from Round 2, option 1A).
- Default diameters Ø32 (bed-rail nominal) and Ø25 (UMS vertical attachment), both UNVERIFIED.
- θ default 90°.
- "6 mm zip ties" read as 6.0 mm wide × 1.6 mm thick (UNVERIFIED).
- Wipe cleaning with Surfanios, bleach or IPA; room temperature.
- Vertical-hole compensation +0.2 mm; bottom chamfer 0.4 mm; top chamfer 0.8 mm; walls ≥ 1.8 mm around channels, ≥ 2.5 mm around bolt holes.
- Fit coupon (§10.4), printed before the part:
  - Universal coupon, row 1: the tie slot, `tie_clear` 0.3 / 0.5 / 0.7 / 0.9.
  - Universal coupon, row 2: the bolt hole, `bolt_clear` 0.2 / 0.4 / 0.6 / 0.8.
  - A 6 mm **seat gauge slice** of each seat (body + cap profile), laid on the real pipe to confirm the diameter before the full part is printed.

## 7. Flags and approval
- Advisor-consultation flags (§4.3): none at ≤ 2 kg, indoor, room temperature. Outdoor use, > 50 °C or high load → flag and advisor.
- Approval path: the design is approved by the 3D Printing Advisor. Each deployment is approved by the line manager, or by Biomed + IPC if the clamp is ever used in a clinical area (then it becomes a critical item).

## 8. Failure consequence and test before use
- **If it fails:**
  - Slip: the joint rotates about the crossing or slides along a pipe, and the attached pipe swings or drops, together with up to 2 kg hung on it.
  - Breakage: the clamp and its load fall from the mounting height.
  - Acceptable only where nothing below can be hurt or damaged; the README says so.
- **Test before use (§10.4):**
  - Function: fit both pipes, tighten until the clamp stops rotating by hand. In the bolt variant the cap must not touch the body; if it does, the pipe is smaller than the seat range.
  - Fit: the seat gauge sits on the pipe with no rocking.
  - Cleaning: wipe once with the local agent; no whitening or softening.
  - Edges: no sharp edges after deburring.
  - Load: hang 4 kg (2 × design load) at the working point for 10 min — no slip > 2 mm, no cracks or whitening. Test to failure: no, as it is non-critical. Re-check bolt tightness after 1 week for PLA.

## 9. Open questions
- Filament on the shelf now: material, colour, quantity.
- Zip ties: width and thickness (calipers), or a photo next to a ruler.
- M6 bolts: lengths available, and plain or nylon lock nuts? Is M6 threaded rod available?
- Quantity and urgency; which diameter pairs and angles to export as ready-made STLs (default set: 32×25 at 90°).
- Grip liner wanted (a strip of inner tube in each seat for more friction)? If yes, a `liner_t` parameter is added to the seat clearance.
