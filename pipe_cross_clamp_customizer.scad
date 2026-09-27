/* ===== DESIGN SUMMARY =====
 * Part / purpose:    Pipe cross clamp, fixed angle. Joins two pipes of different outside diameters that
 *                    cross at a fixed angle (0-90 deg, set in the Customizer). Fits onto pipes already in place.
 *                    Generic, non-clinical tool (logistics, workshops, non-clinical hospital areas, training).
 * Version:           1.4 2026-09-26   Designer: MSF 3D Printing for All
 * One-file version:  this file - generated from pipe_cross_clamp.scad by tools/make_customizer.py; do not edit by hand
 * Critical part:     no (non-clinical, <= 2 kg positioning load). Any use in a patient area, above a patient
 *                    or carrying a device -> critical item, new scope check and Biomed + IPC approval.
 * Material:          designed for PLA (weakest candidate; shelf not confirmed). PETG preferred, PLA indoors
 *                    below 40 C, ASA / PC Blend outdoor or > 50 C via the advisor. Not TPU.
 * Environment:       indoor, room temperature, wiped with Surfanios / bleach / IPA
 * Loads:             <= 2 kg hanging or side-pulled on one of the pipes; held by friction in 90 deg V-seats
 *                    (bolt preload or zip-tie tension). Test at 2x = 4 kg.
 * Print orientation: body flat on its pipe-1 face (pipe-1 seat opens down: pointed 45 deg roof; pipe-2 seat
 *                    opens up: flat floor). Caps face down (seat opens down: pointed roof), hump up.
 *                    Supports: none. Brim: no. All bolt holes and tie slots vertical.
 * Mating hardware:   bolts variant: 4 x M6 bolts (bolt_d; socket head or hex head), 4 nuts (captive in cap 2),
 *                    4 washers (head side); or M6 threaded rod + 4 washers + 8 nuts;
 *                    minimum bolt length echoed in the console. zipties variant: 4 x zip ties (tie_w x tie_t).
 * Fits used:         pipe in self-centring V (4 contact lines with caps), seat_clear per side at the mouth;
 *                    clamp_gap cap-to-body at the nominal diameter; bolt hole = bolt_d + bolt_clear (total,
 *                    includes the +0.2 vertical-hole compensation); tie channel = tie + 2 x tie_clear.
 * Interfaces:        pipe1_d, pipe2_d outside diameters (UNVERIFIED defaults 32 / 25 - measure with calipers)
 * Unverified values: pipe1_d, pipe2_d, tie_w, tie_t (defaults, not measured)
 * Flags:             none at <= 2 kg indoor
 * Deviations:        none from sections 5 / 8 / 9. From the brief: size label moved from the body to the seat
 *                    gauge; bolt_clear is the total extra on the hole diameter (see README "Changed while modelling").
 * Verified:          see DATASHEET verification table (OpenSCAD 2021.01, check_stl.py, manifold3d, sweep report)
 * Not verified:      physical print, fit on real pipes, load test, cleaning test
 * Approval:          design: 3D Printing Advisor; each deployment: line manager (Biomed + IPC if clinical)
 * ========================== */
// Sources: MSF 3D Printing Process Guideline V1.1; msf-3dp-design skill v1.2.0 (common.scad / helpers.scad).

/* [Hidden] */
// ===== inlined from common.scad (shop defaults, not Customizer settings) =====
// common.scad — MSF "3D Printing for All" shared design defaults
// OpenSCAD 2021.01 or newer. No external libraries.
// Copy this file next to your part, then:  include <common.scad>
// Values are starting points, not guarantees — tune them after the coupon / first article,
// and record what was confirmed in the README ("Confirmed by test print").
// Sources: MSF 3D Printing Process Guideline V1.1 Parts 2–4; Hydra Research design rules;
//          MSF project values (tagged "project" in the workflow file).

assert(version_num() >= 20210100, "OpenSCAD 2021.01 or newer is required");


layer_h        = 0.2;    // [0.1:0.05:0.3] layer height (SPEED preset)
ext_w          = 0.45;   // extrusion width with a 0.4 mm nozzle


clr_free_pp    = 0.3;    // [0.2:0.05:0.5] sliding fit, printed-printed (MSF: >= 0.6 total)
clr_free_pm    = 0.15;   // [0.1:0.05:0.4] sliding fit, printed-machined (MSF: >= 0.3 total)
clr_tight_pp   = 0.15;   // [0.05:0.05:0.3] tight fit, printed-printed (MSF: 0.3 total)
clr_tight_pm   = 0.075;  // [0.0:0.025:0.3] tight fit, printed-machined (MSF: 0.15 total)
clr_dropin     = 0.8;    // [0.4:0.1:1.5] loose drop-in, removable for cleaning
hole_clr       = 0.2;    // [0:0.05:0.5] added to the DIAMETER of vertical holes (holes print small)


min_wall       = 1.6;    // MSF minimum wall
struct_wall    = 4 * ext_w;   // 1.8 mm: four perimeters, solid at any slicer setting
min_base       = 2.0;    // base of flat parts
min_handle     = 2.4;    // handled protrusions, both directions
min_hole_v     = 1.5;    // vertical hole diameter
min_pin_d      = 1.8;    // pin diameter
max_bridge     = 10;     // avoid bridges; hard limit if unavoidable
max_overhang   = 45;     // degrees from vertical (60 only where the brief allows it)
overhang_tol   = 0.05;   // degrees, float32 STL rounding on exact 45° faces
max_part       = [200, 200, 200];


chamfer_bottom = 0.4;    // [0.3:0.1:0.6] elephant's foot
chamfer_top    = 0.8;    // [0.6:0.1:1.0] exposed edges
fillet_min     = 1.0;    // internal concave corners (IPC)
base_corner_r  = 4;      // vertical edge radius at the plate, closed corners


bolt_wall      = 2.5;    // material around bolt holes (four to five perimeters)
min_thread_d   = 10;     // modelled threads only above this diameter ...
min_thread_p   = 1.5;    // ... and this pitch
tap_factor     = 0.90;   // hole for tapping (Hydra)
selftap_factor = 0.96;   // hole for a self-tapping screw (Hydra)
insert_factor  = 0.98;   // hole for a heat-set insert (Hydra) — or the insert maker's value


drain_d        = 6;      // [0:1:12] drainage hole in closed floors, 0 = none (blind sockets >= 2)
brim_ear_d     = 0;      // [0:1:15] built-in brim ears for tall or narrow parts, 0 = none
brim_ear_t     = 0.4;    // two layers


font           = "Liberation Sans:style=Bold";
text_size_min  = 6;      // letter height (MSF > 6 mm); training set used size 5 (4.8 mm caps)
text_depth     = 0.8;    // [0.6:0.1:1.0] emboss / deboss depth


band_base      = 2.0;    // colour band base
band_min       = 3 * layer_h;   // 0.6 mm per colour


nfc_pocket     = [19, 19, 1];


fn_preview     = 32;     // [16:8:64] segments in preview (F5)
fn_export      = 96;     // [48:8:180] segments for export (F6 / command line)
$fn = $preview ? fn_preview : fn_export;


EPS = 0.01;              // boolean overlap to avoid coincident faces (see boolean hygiene)

// ===== end of common.scad =====

assert(version_num() >= 20210100, "OpenSCAD 2021.01 or newer is required");

/* [Part selection] */
// Which part to export
part = "body"; // [body:Body, cap1:Cap 1 - under pipe 1 (bolts only), cap2:Cap 2 - over pipe 2 (bolts only), gauge:Seat gauge - print two, all:All clamp parts - one print plate, all_checks:All clamp parts + 2 gauges - one print plate]
// How each pipe is held in its seat
closure = "bolts"; // [bolts:Bolts - body + 2 caps, zipties:Zip ties - body only]

/* [Main dimensions - the two pipes] */
// Outside diameter of pipe 1 (bottom seat) - UNVERIFIED, measure with calipers
pipe1_d = 32; // [10:0.1:60]
// Outside diameter of pipe 2 (top seat) - UNVERIFIED, measure with calipers
pipe2_d = 25; // [10:0.1:60]
// Crossing angle between the pipe axes, degrees (180 - angle = same clamp)
angle = 90; // [0:1:90]
// Seat length along pipe 1 (grip)
seat_len1 = 30; // [20:1:80]
// Seat length along pipe 2 (grip)
seat_len2 = 30; // [20:1:80]

/* [Interface / fit] */
// V-seat included angle, degrees (<= 90 keeps the downward seat at <= 45 deg)
v_angle = 90; // [60:1:90]
// Clearance per side between pipe and seat walls at the mouth
seat_clear = 1.0; // [0.5:0.1:3]
// Cap-to-body gap at the nominal diameter (bolts close it); also sets seat depth
clamp_gap = 3.0; // [1:0.1:5]
// Gap under pipe 2 above the flat floor of the top seat
floor_relief = 0.5; // [0.2:0.1:2]
// Extra on the bolt hole DIAMETER, total (coupon row 2 step value)
bolt_clear = 0.6; // [0.2:0.1:1.2]
// Zip-tie width - UNVERIFIED
tie_w = 6.0; // [2.5:0.1:9]
// Zip-tie thickness - UNVERIFIED
tie_t = 1.6; // [0.8:0.1:2.5]
// Clearance per side in the tie channel (coupon row 1 step value)
tie_clear = 0.5; // [0.3:0.1:1]

/* [Mounting - hardware] */
// Bolt size
bolt_d = 6; // [5:M5, 6:M6, 8:M8]
// Counterbore in cap 1 for the bolt head, washer and a socket spanner (mm)
bolt_tool_d = 18; // [14:0.5:26]

/* [Strength] */
// Solid material between the two seats (bolts variant)
web = 5; // [3:0.5:10]
// Wall beside each seat mouth
seat_wall = 3.0; // [1.8:0.1:6]
// Solid cap floor under the bolt head (cap 1) and under the captive nut (cap 2)
floor_t = 8; // [6:0.5:12]
// Cap material above the V apex - carries the clamping load across the pipe
cap_back = 10; // [6:0.5:20]
// Wall around the zip-tie channels (four perimeters)
channel_wall = 1.8; // [1.8:0.45:3.6]
// Minimum centreline radius of the tie channel bends (grows for wide ties)
tie_bend_r = 6; // [5.5:0.5:10]

/* [Printability] */
// Gap between parts when all parts are on one print plate (mm)
plate_gap = 8; // [3:1:20]
// Vertical edge radius of the outlines
corner_r = 4; // [2:0.5:8]

/* [Preview] */
// Show the pipes in preview (never exported)
show_ghosts = true;

/* [Hidden] */
BIG = 400;              // length of seat cutters (longer than any part)
bed = [250, 210];       // print bed of the reference printer (Original Prusa MK4S), mm
bed_margin = 5;         // keep-out along the bed edges for the all-parts plate
build_part = is_undef(pcc_context);   // false only when included by pipe_cross_clamp_context.scad (not a Customizer setting)

// ===== Derived values =====
is_bolts = closure == "bolts";
sa = sin(v_angle / 2);
ta = tan(v_angle / 2);
r1 = pipe1_d / 2;  r2 = pipe2_d / 2;
m1 = r1 + seat_clear;  m2 = r2 + seat_clear;           // seat mouth half-widths
a1 = r1 / sa;  a2 = r2 / sa;                            // pipe centre to V apex
g1 = a1 - clamp_gap / 2;  g2 = a2 - clamp_gap / 2;      // V apex height above the seat face (pipe centre sits clamp_gap/2 outside the face)
d2 = min(a2, r2 + floor_relief) - clamp_gap / 2;        // depth of the top seat (flat floor) below the body top
hole_d = bolt_d + bolt_clear;
// Hardware from the bolt size (ISO 7089 washer, ISO 4032 nut): [washer OD, washer t, nut across flats, nut height]
function hw_std(d) = d == 5 ? [10, 1.0, 8, 4.7] : d == 6 ? [12, 1.6, 10, 5.2] : [16, 1.6, 13, 6.8];
washer_d = hw_std(bolt_d)[0];  washer_t = hw_std(bolt_d)[1];  nut_af = hw_std(bolt_d)[2];  nut_h = hw_std(bolt_d)[3];
boss_r = hole_d / 2 + bolt_wall + 1;                      // body bosses (the bolt only passes through)
cb_r = bolt_tool_d / 2;                                   // cap 1: counterbore for head + washer + socket
nw_r = (nut_af + 0.4) / sqrt(3);                          // cap 2: captive-nut hex well, across-corners radius
// bosses keep the full bolt_wall around each well even at the top face, where the well lead-in and the
// outline chamfer both eat into it
cap1_boss_r = cb_r + bolt_wall + 2 * chamfer_top;  cap2_boss_r = nw_r + bolt_wall + 2 * chamfer_top + 0.2;
function gw(m, g, z) = min(m, max(0, (g - z) * ta));      // seat half-width at height z above the seat face
tw = tie_w + 2 * tie_clear;  tt = tie_t + 2 * tie_clear; // tie channel section (width along the pipe x radial)

// Lateral clearance of the through-bolts: clear of both seats in the body, and >= bolt_wall between each cap's
// counterbore / nut well and its seat at floor level (where the V is widest).
h1 = max(m1 + chamfer_top + hole_d / 2 + bolt_wall, gw(m1, g1, floor_t) + cb_r + bolt_wall);
h2 = max(m2 + chamfer_top + hole_d / 2 + bolt_wall, gw(m2, g2, floor_t) + nw_r + bolt_wall);
d2v = [cos(angle), sin(angle)];                          // pipe 2 axis direction (plan)
n2v = [-sin(angle), cos(angle)];                         // pipe 2 lateral direction (plan)
// Bolt pattern: 4 through-bolts, two on each side of EACH pipe, never on one line, so the caps cannot rock.
// Two layouts; the more compact one is used:
//   corners - one bolt in each quadrant around the crossing (a rectangle at 90 deg), for large angles
//   pairs   - two pairs spread along the bisector of the pipes, for small angles (where corners run away)
sn = sin(angle / 2);  kn = cos(angle / 2);
bolt_e = max(max(cb_r, nw_r) + 1.5, min(seat_len1, seat_len2) / 2);   // half the spacing inside a pair
bolt_H = (max(h1, h2) + bolt_e * sn) / kn;
function bis(a, c) = [a * kn - c * sn, a * sn + c * kn];              // bisector frame -> plan
pairs_pts = [bis(bolt_e, bolt_H), bis(-bolt_e, bolt_H), bis(-bolt_e, -bolt_H), bis(bolt_e, -bolt_H)];
corner_ok = angle >= 5;
c_pp = corner_ok ? [(h1 * cos(angle) - h2) / sin(angle), h1] : [0, 0];   // pipe-1 side +, pipe-2 side +
c_pm = corner_ok ? [(h1 * cos(angle) + h2) / sin(angle), h1] : [0, 0];   // pipe-1 side +, pipe-2 side -
use_corners = corner_ok && max(norm(c_pp), norm(c_pm)) <= norm([bolt_e, bolt_H]);
bolt_pts = use_corners ? [c_pp, c_pm, -c_pp, -c_pm] : pairs_pts;
bolt_layout = use_corners ? "corners" : "pairs";
cap1_pts = [for (q = bolt_pts) [q[0], -q[1]]];            // cap 1 is printed turned 180 deg about X
cap2_pts = [for (q = bolt_pts) [q * d2v, q * n2v]];       // cap 2 in its own frame (seat along X)

// Zip-tie channels: U1 (pipe 1, from the bed, gable outward), U2 (pipe 2, from the top, gable inward)
tie_R = max(tie_bend_r, tt / 2 + tw / 2 + 0.5);           // bend radius actually used (room for the inner gable)
ys1 = m1 + chamfer_bottom + channel_wall + tt / 2;
ys2 = m2 + chamfer_top + channel_wall + tt / 2 + tw / 2;
zh1 = g1 + channel_wall + tt / 2;
u1_top = zh1 + tt / 2 + tw / 2;
e1 = seat_len1 / 2 - tw / 2 - channel_wall;              // tie positions along each pipe (+-)
e2 = seat_len2 / 2 - tw / 2 - channel_wall;

// Body = lower block (square-ended around seat 1) + 45 deg transition + upper block (square-ended around
// seat 2). Square ends keep every seat mouth free of knife edges at any angle.
hw1 = is_bolts ? m1 + seat_wall : max(m1 + seat_wall, ys1 + tt / 2 + tw / 2 + channel_wall);
hw2 = is_bolts ? m2 + seat_wall : max(m2 + seat_wall, ys2 + tt / 2 + channel_wall);

// Corner radius of each block: the largest value up to corner_r that keeps >= struct_wall around the seat end
// and (zip ties) around every tie-slot point - a larger radius would cut into the wall beside the slots.
function leg_poly(ys, R, gable_out) = [for (q = uprof(R, gable_out)) [q[1], ys - R + q[0]]];   // slot section (X along pipe, Y lateral)
function leg_pts(ys, gable_out, e) = let(pl = leg_poly(ys, tie_R, gable_out), n = len(pl))
    [for (i = [0 : n - 1], t = [0 : 0.1 : 1]) [e, 0] + pl[i] * (1 - t) + pl[(i + 1) % n] * t];
function corner_wall(r, L, hw, pts) = let(C = [L / 2 - r, hw - r])
    min(concat([99], [for (P = pts) if (P[0] > C[0] && P[1] > C[1]) r - norm(P - C)]));
function best_r(rmax, L, hw, pts) = let(c = [for (r = [rmax : -0.25 : 0.5]) if (corner_wall(r, L, hw, pts) >= struct_wall - 0.001) r])
    len(c) > 0 ? c[0] : 0.5;
rr1_seat = max(0.5, min(corner_r, hw1 - m1 - struct_wall - chamfer_top));
rr2_seat = max(0.5, min(corner_r, hw2 - m2 - struct_wall - chamfer_top));
rr1 = is_bolts ? rr1_seat : best_r(rr1_seat, seat_len1, hw1, leg_pts(ys1, true, e1));
rr2 = is_bolts ? rr2_seat : best_r(rr2_seat, seat_len2, hw2, leg_pts(ys2, false, e2));
L1e = is_bolts ? max(seat_len1, 2 * (max([for (q = bolt_pts) abs(q[0])]) + boss_r)) : seat_len1;  // body seat lengths: bolt bosses never
L2e = is_bolts ? max(seat_len2, 2 * (max([for (q = bolt_pts) abs(q * d2v)]) + boss_r)) : seat_len2; // stick out past a seat end
function rotv(v, a) = [v[0] * cos(a) - v[1] * sin(a), v[0] * sin(a) + v[1] * cos(a)];
function rect_pts(L, hw, a) = [for (sx = [-1, 1], sy = [-1, 1]) rotv([sx * L / 2, sy * hw], a)];
DIRS = [for (i = [0 : 2 : 358]) [cos(i), sin(i)]];
// exact support function of the lower outline: rounded rectangle (seat 1) + bolt bosses
function supp1(u) = max(concat([(L1e / 2 - rr1) * abs(u[0]) + (hw1 - rr1) * abs(u[1]) + rr1],
                               [for (c = (is_bolts ? bolt_pts : [])) u * c + boss_r]));
function outside1(q) = max([for (u = DIRS) u * q - supp1(u)]);
delta = max(0, max([for (q = rect_pts(L2e, hw2, angle)) outside1(q)]));   // sharp corners of the upper rect: conservative
z1 = is_bolts ? g1 : u1_top + channel_wall;               // top of the lower block
trans_h = is_bolts ? max(web, delta + 0.5) : max(1, delta + 0.5);   // 45 deg transition (>= overhang distance)
z2 = z1 + trans_h;                                        // bottom of the upper block
zh2 = z2 + channel_wall + tt / 2;
T = is_bolts ? z2 + d2 : zh2 + tt / 2 + tw / 2 + channel_wall + d2;   // body height
bolt_len_min = 2 * floor_t + 2 * clamp_gap + T + washer_t + nut_h + 2;   // head in cap 1 counterbore, nut captive in cap 2
// Caps: solid blocks; the seat block is lengthened so the bolt bosses never stick out past a seat end
Lc1 = max(seat_len1, 2 * (max([for (q = cap1_pts) abs(q[0])]) + cap1_boss_r));
Lc2 = max(seat_len2, 2 * (max([for (q = cap2_pts) abs(q[0])]) + cap2_boss_r));
cap1_h = g1 + cap_back;  cap2_h = g2 + cap_back;
plan_r = max(norm([L1e / 2, hw1]), norm([L2e / 2, hw2]), is_bolts ? max([for (q = bolt_pts) norm(q)]) + boss_r : 0);
d_min1 = pipe1_d - clamp_gap * sa;  d_min2 = pipe2_d - clamp_gap * sa;      // cap touches the body below this
gauge_hw = max(m1, m2) + 18;  gauge_h = g1 + g2 + web;  gauge_t = 4;

// ===== All-parts print plate =====
// Footprints (plan bounding boxes in print position) from the same points that build each outline.
function bb_pts(pts, circ = [], cr = 0) = [min(concat([for (q = pts) q[0]], [for (c = circ) c[0] - cr])),
                                           max(concat([for (q = pts) q[0]], [for (c = circ) c[0] + cr])),
                                           min(concat([for (q = pts) q[1]], [for (c = circ) c[1] - cr])),
                                           max(concat([for (q = pts) q[1]], [for (c = circ) c[1] + cr]))];
function cap_bb(m, L, pts, br) = let(hw = m + seat_wall) bb_pts([[-L / 2, -hw], [L / 2, hw]], pts, br);
function item_bb(n) = n == "body" ? bb_pts(concat(rect_pts(L1e, hw1, 0), rect_pts(L2e, hw2, angle)), circ_b, boss_r)
                    : n == "cap1" ? cap_bb(m1, Lc1, cap1_pts, cap1_boss_r)
                    : n == "cap2" ? cap_bb(m2, Lc2, cap2_pts, cap2_boss_r)
                    : [-gauge_hw, gauge_hw, 0, gauge_h];
circ_b = is_bolts ? bolt_pts : [];
clamp_items = is_bolts ? ["body", "cap1", "cap2"] : ["body"];
plate_items = part == "all" ? clamp_items : part == "all_checks" ? concat(clamp_items, ["gauge", "gauge"]) : [];
is_plate = len(plate_items) > 0;
plate_sizes = [for (n = plate_items) let(b = item_bb(n)) [b[1] - b[0], b[3] - b[2]]];
use_w = bed[0] - 2 * bed_margin;  use_h = bed[1] - 2 * bed_margin;
// rows from left to right; a part that would pass the usable width starts a new row
function shelf(sz, W, g, i = 0, x = 0, y = 0, rh = 0) =
    i >= len(sz) ? []
  : (x > 0 && x + sz[i][0] > W) ? shelf(sz, W, g, i, 0, y + rh + g, 0)
  : concat([[x, y]], shelf(sz, W, g, i + 1, x + sz[i][0] + g, y, max(rh, sz[i][1])));
plate_pos = is_plate ? shelf(plate_sizes, use_w, plate_gap) : [];
plate_w = is_plate ? max([for (i = [0 : len(plate_items) - 1]) plate_pos[i][0] + plate_sizes[i][0]]) : 0;
plate_h = is_plate ? max([for (i = [0 : len(plate_items) - 1]) plate_pos[i][1] + plate_sizes[i][1]]) : 0;

// ===== Input validation =====
assert(angle >= 0 && angle <= 90, "angle must be 0-90 degrees (a crossing at 180 - angle uses the same clamp)");
assert(v_angle <= 90 + 0.001, "v_angle above 90 deg makes the downward-facing seat overhang more than 45 deg");
for (r = [r1, r2]) let(m = r + seat_clear, g = r / sa - clamp_gap / 2)
    assert(r * cos(v_angle / 2) <= min(m, g * ta) - 0.3,
           "the pipe would touch the seat mouth instead of the V faces - increase clamp_gap less or seat_clear more");
assert(bolt_tool_d >= washer_d + 2 - 0.001, "bolt_tool_d too small for the washer and a socket - increase bolt_tool_d");
assert(is_bolts || part == "body" || part == "gauge" || part == "all" || part == "all_checks",
       "the zip-tie variant has no caps - choose Body, Seat gauge or one of the All options");
assert(is_bolts || (seat_len1 >= 2 * tw + 2 * channel_wall + 2 - 0.001 && seat_len2 >= 2 * tw + 2 * channel_wall + 2 - 0.001),
       "seat_len too short for two zip ties per pipe - lengthen the seat or use narrower ties");
assert(is_bolts || (zh1 - tie_R >= 0.5 - 0.001 && ys1 - tie_R >= 0.5 && ys2 - tie_R >= 0.5),
       "tie channels do not fit around a pipe this small - use narrower zip ties or the bolts variant");
for (q = bolt_pts) assert(abs(q[1]) >= h1 - 0.01 && abs(q * n2v) >= h2 - 0.01,
                          "internal: a bolt position does not clear a seat");
assert(2 * plan_r <= max_part[0] && T <= max_part[2], "part exceeds 200 mm - reduce seat_len or the diameters");
assert(!is_plate || (plate_w <= use_w + 0.001 && plate_h <= use_h + 0.001),
       str("the parts do not fit on one print plate (", bed[0], " x ", bed[1], " mm bed) - choose the parts one by one"));

echo(str("NOTE body height ", T, " mm; plan radius ", plan_r, " mm; closure ", closure));
if (is_plate) echo(str("NOTE print plate ", plate_w, " x ", plate_h, " mm with ", len(plate_items), " parts: ", plate_items));
if (is_plate) echo(str("CHECK expect_bodies=", len(plate_items), " max_size=", max(use_w, use_h)));
if (is_bolts) echo(str("NOTE bolts: 4 x M", bolt_d, " (", bolt_layout, " layout), minimum length ", ceil(bolt_len_min),
                       " mm (next standard length, or threaded rod); positions ", bolt_pts));
echo(str("NOTE accepted pipe 1: ", d_min1, " to ", pipe1_d + 2 * seat_clear - 0.6, " mm; pipe 2: ", d_min2, " to ", pipe2_d + 2 * seat_clear - 0.6, " mm (bolts variant)"));
echo(str("NOTE block corner radii ", rr1, " / ", rr2, " mm"));
echo(str("NOTE web between seats ", is_bolts ? trans_h : channel_wall, " mm (transition ", trans_h, " mm for overhang ", delta, " mm); seat wall ", seat_wall, " mm; body seat lengths ", L1e, " / ", L2e, " mm"));

// ===== Helper modules =====
// Seat cross-section (2D): x = lateral, y = height; seat face at y = 0, V apex at y = g, opening towards -y.
// floor_h truncates the V with a flat floor at that height (only for the upward-opening top seat).
module seat_profile(m, g, floor_h, c) {
    w0 = min(m, g * ta);                                  // mouth half-width at the face
    ce = (g - m / ta >= c) ? c : 0;                       // chamfer only where the mouth has vertical walls
    union() {
        intersection() {
            polygon([[0, g], [(g + 2) * ta, -2], [-(g + 2) * ta, -2]]);
            translate([-m, -2]) square([2 * m, min(g, floor_h) + 2]);
        }
        if (ce > 0) polygon([[-(w0 + ce + 2), -2], [w0 + ce + 2, -2], [w0, ce], [-w0, ce]]);   // 45 deg mouth chamfer
    }
}
// Seat cutter along X: lateral -> Y, height -> Z.
module seat_x(m, g, floor_h, c) {
    rotate([90, 0, 90]) linear_extrude(BIG, center = true) seat_profile(m, g, floor_h, c);
}
// Vertical bolt hole through a part of height h, 45 deg chamfer at the bed, lead-in at the top.
module bolt_hole(d, h) {
    translate([0, 0, -1]) cylinder(d = d, h = h + 2);
    translate([0, 0, -1]) cylinder(r1 = d / 2 + chamfer_bottom + 1, r2 = d / 2, h = chamfer_bottom + 1);
    translate([0, 0, h - chamfer_top]) cylinder(r1 = d / 2, r2 = d / 2 + chamfer_top + 1, h = chamfer_top + 1);
}

// Tie channel profile: x = radial distance from the bend centre, y = along the pipe. 45 deg gable on the
// side that becomes a roof: outer side for U1 (bend centre below), inner side for U2 (bend centre above).
function uprof(R, gable_out) = gable_out
    ? [[R - tt / 2, -tw / 2], [R + tt / 2, -tw / 2], [R + tt / 2 + tw / 2, 0], [R + tt / 2, tw / 2], [R - tt / 2, tw / 2]]
    : [[R + tt / 2, -tw / 2], [R + tt / 2, tw / 2], [R - tt / 2, tw / 2], [R - tt / 2 - tw / 2, 0], [R - tt / 2, -tw / 2]];
UMAP = [[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]];   // rotate_extrude frame -> (X along pipe, Y lateral, Z up)
// Half of a U channel (+Y side): leg going down from the bend, 90 deg bend, run to the centre line.
module u_half(ys, R, zc, leg_len, gable_out) {
    translate([0, ys - R, zc - R]) multmatrix(UMAP) {
        rotate_extrude(angle = 90) polygon(uprof(R, gable_out));
        rotate([90, 0, 0]) linear_extrude(leg_len) polygon(uprof(R, gable_out));          // faces meet the bend exactly
        rotate([0, 0, 90]) rotate([-90, 0, 0]) linear_extrude(ys - R + 0.05) polygon(uprof(R, gable_out));
    }
}
// Full U channel in the YZ plane at X = 0: legs at Y = +-ys open at Z = -1, run centreline at Z = zc.
module u_channel(ys, R, zc, leg_len, gable_out) {
    u_half(ys, R, zc, leg_len, gable_out);
    mirror([0, 1, 0]) u_half(ys, R, zc, leg_len, gable_out);
}
// 45 deg flare at the open end of both legs (Z = 0 face), following the pentagonal leg section.
module leg_flares(ys, gable_out, c) {
    for (s = [-1, 1]) scale([1, s, 1]) hull() {
        translate([0, 0, c]) linear_extrude(0.01) polygon(leg_poly(ys, tie_R, gable_out));
        translate([0, 0, -1]) linear_extrude(0.01) offset(delta = c + 1) polygon(leg_poly(ys, tie_R, gable_out));
    }
}

// ===== Part modules =====
module outline1() {                                       // lower block: seat-1 strip + bolt bosses
    hull() {
        rounded_rect([L1e, 2 * hw1], rr1);
        if (is_bolts) for (q = bolt_pts) translate(q) circle(r = boss_r);
    }
}
module outline2() {                                       // upper block: seat-2 strip + bolt bosses
    hull() {
        rotate(angle) rounded_rect([L2e, 2 * hw2], rr2);
        if (is_bolts) for (q = bolt_pts) translate(q) circle(r = boss_r);
    }
}
module body_solid() {
    chamfered_prism(z1, chamfer_bottom, 0) outline1();
    hull() {                                              // 45 deg transition: trans_h >= overhang distance
        translate([0, 0, z1 - 0.01]) linear_extrude(0.01) outline1();
        translate([0, 0, z2]) linear_extrude(0.01) outline2();
    }
    translate([0, 0, z2]) chamfered_prism(T - z2, 0, chamfer_top) outline2();
}

module body() {
    difference() {
        body_solid();
        seat_x(m1, g1, 1e3, chamfer_bottom);                                   // pipe 1, opens down (pointed roof)
        translate([0, 0, T]) rotate(angle) mirror([0, 0, 1]) seat_x(m2, g2, d2, chamfer_top);   // pipe 2, opens up
        if (is_bolts) {
            for (q = bolt_pts) translate(q) bolt_hole(hole_d, T);
        } else {
            for (s = [-1, 1]) translate([s * e1, 0, 0]) {                        // pipe 1 ties, from the bed
                u_channel(ys1, tie_R, zh1, zh1 - tie_R + 1, true);
                leg_flares(ys1, true, chamfer_bottom);
            }
            for (s = [-1, 1]) rotate(angle) translate([s * e2, 0, 0]) {          // pipe 2 ties, from the top
                translate([0, 0, zh2]) mirror([0, 0, 1]) u_channel(ys2, tie_R, 0, T - zh2 - tie_R + 1, false);
                translate([0, 0, T]) mirror([0, 0, 1]) leg_flares(ys2, false, chamfer_top);
            }
        }
    }
}

// Cap in print position: seat along X opening down at Z = 0. One solid convex block over the seat and both bolt
// bosses - no wings, no inside corners: the bolt load goes through the block in compression and in bending
// along the layers. Cap 1 has counterbores for the bolt head (socket access), cap 2 captive-nut hex wells;
// both keep a solid floor_t under the head / nut so the bolts stay short.
module cap(m, g, L, pts, br, well) {
    hw = m + seat_wall;
    h = g + cap_back;
    difference() {
        chamfered_prism(h, chamfer_bottom, chamfer_top) hull() {
            rounded_rect([L, 2 * hw], max(0.5, min(corner_r, seat_wall - struct_wall)));
            for (q = pts) translate(q) circle(r = br);
        }
        seat_x(m, g, 1e3, chamfer_bottom);
        for (q = pts) translate(q) {
            bolt_hole(hole_d, h);
            if (well == "counterbore") {
                translate([0, 0, floor_t]) cylinder(r = cb_r, h = h);
                translate([0, 0, h - chamfer_top]) cylinder(r1 = cb_r, r2 = cb_r + chamfer_top + 1, h = chamfer_top + 1);
            } else {
                translate([0, 0, floor_t]) cylinder(r = nw_r, h = h, $fn = 6);
                translate([0, 0, h - chamfer_top]) cylinder(r1 = nw_r, r2 = nw_r + (chamfer_top + 1) / cos(30), h = chamfer_top + 1, $fn = 6);
            }
        }
    }
}

// Seat gauge: 4 mm plate with the pipe-1 seat profile on the bottom edge and the pipe-2 profile on the top
// edge. Print two; hold one on each side of a pipe: the gap between the plates is clamp_gap at the nominal size.
module gauge_notch(m, g, c_b, c_t) {             // exact profile through the plate, 45 deg flares only at the faces
    hull() {                                               // (three separate hulls: one hull over all would widen the notch)
        translate([0, 0, -1]) linear_extrude(0.01) offset(delta = c_b + 1) seat_profile(m, g, 1e3, 0);
        translate([0, 0, c_b]) linear_extrude(0.01) seat_profile(m, g, 1e3, 0);
    }
    translate([0, 0, c_b]) linear_extrude(gauge_t - c_b - c_t + 0.01) seat_profile(m, g, 1e3, 0);
    hull() {
        translate([0, 0, gauge_t - c_t]) linear_extrude(0.01) seat_profile(m, g, 1e3, 0);
        translate([0, 0, gauge_t + 1]) linear_extrude(0.01) offset(delta = c_t + 1) seat_profile(m, g, 1e3, 0);
    }
}
module gauge() {
    difference() {
        chamfered_prism(gauge_t, chamfer_bottom, chamfer_top) translate([0, gauge_h / 2]) rounded_rect([2 * gauge_hw, gauge_h], corner_r);
        gauge_notch(m1, g1, chamfer_bottom, chamfer_top);
        translate([0, gauge_h, 0]) mirror([0, 1, 0]) gauge_notch(m2, g2, chamfer_bottom, chamfer_top);
        translate([-gauge_hw + 2, 2, gauge_t - 0.6]) linear_extrude(1) text(str(pipe1_d), size = 6, font = font, halign = "left", valign = "baseline");
        translate([gauge_hw - 2, gauge_h - 2, gauge_t - 0.6]) linear_extrude(1) text(str(pipe2_d), size = 6, font = font, halign = "right", valign = "top");
    }
}

// Pipe stand-ins for preview (use position of the body)
module ghost_pipes() {
    %color("silver", 0.4) translate([0, 0, -clamp_gap / 2]) rotate([0, 90, 0]) cylinder(d = pipe1_d, h = 160, center = true);
    %color("silver", 0.4) translate([0, 0, T + clamp_gap / 2]) rotate([0, 0, angle]) rotate([0, 90, 0]) cylinder(d = pipe2_d, h = 160, center = true);
}

// ===== Build (print position: Z = 0 is the bed) =====
module cap1() { cap(m1, g1, Lc1, cap1_pts, cap1_boss_r, "counterbore"); }
module item(n) {
    if (n == "body") body();
    else if (n == "cap1") cap1();
    else if (n == "cap2") cap2();
    else gauge();
}
module plate() {                                          // all parts, centred on the bed, each in print position
    for (i = [0 : len(plate_items) - 1]) let(b = item_bb(plate_items[i]))
        translate([plate_pos[i][0] - b[0] - plate_w / 2, plate_pos[i][1] - b[2] - plate_h / 2, 0]) item(plate_items[i]);
}
module cap2() { cap(m2, g2, Lc2, cap2_pts, cap2_boss_r, "nut"); }

if (build_part) {
    if (part == "body") body();
    else if (part == "cap1") cap1();
    else if (part == "cap2") cap2();
    else if (part == "gauge") gauge();
    else if (is_plate) plate();
    if ($preview && show_ghosts && part == "body") ghost_pipes();
}


// ===== inlined from helpers.scad =====
// helpers.scad — MSF "3D Printing for All" helper modules
// OpenSCAD 2021.01 or newer. No external libraries.
// Usage:  include <common.scad>   then   include <helpers.scad>
// Every helper is product-agnostic. All sizes in mm. Parts sit on Z = 0 (print position).
//
// Contents
//   2D:  rounded_rect, rounded_poly, teardrop2d, hex_grid
//   3D:  chamfered_prism, rounded_box, section_cut
//   Holes (cutters): vertical_hole, teardrop_hole, flat_top_hole, cone_roof_bore, nut_trap, drain_hole
//   Adhesion / standing parts: brim_ear, brim_ears, tab, slot
//   Previews: ghost_tube, ghost_pole, ghost_device, ghost_wall
//
// Boolean hygiene (2021.01 / CGAL): cutters extend EPS or more beyond the faces they cut; never let a
// cutter face coincide with a part face. Clip cutters to the region they are meant to cut.

// ---------------------------------------------------------------- 2D --------------------------------

// Rectangle centred at the origin with rounded corners. size = [x, y].
module rounded_rect(size, r = 2) {
    rr = min(r, size[0] / 2, size[1] / 2);
    if (rr <= 0) square(size, center = true);
    else offset(r = rr) square([size[0] - 2 * rr, size[1] - 2 * rr], center = true);
}

function _unit(v) = v / norm(v);
function _ang(v) = atan2(v[1], v[0]);
// Fillet arc replacing vertex p1 (neighbours p0, p2) with radius r, n segments.
function _fillet_pts(p0, p1, p2, r, n) =
    let(a = _unit(p0 - p1), b = _unit(p2 - p1),
        theta = acos(max(-1, min(1, a * b))),          // angle between the two edges at p1
        t = r / tan(theta / 2),                        // tangent length along each edge
        ta = p1 + a * t, tb = p1 + b * t,
        c = p1 + _unit(a + b) * (r / sin(theta / 2)), // arc centre on the bisector
        a0 = _ang(ta - c), a1 = _ang(tb - c),
        d = ((a1 - a0 + 540) % 360) - 180)             // signed sweep, always the short way
    [for (i = [0 : n]) c + r * [cos(a0 + d * i / n), sin(a0 + d * i / n)]];

// Polygon with a fillet radius per vertex: pts = [[[x, y], r], ...] (r = 0 keeps a sharp corner).
// Works for convex and concave corners. Every r must be small enough for its two edges.
module rounded_poly(pts, fn = 16) {
    n = len(pts);
    polygon([for (i = [0 : n - 1])
        let(p1 = pts[i][0], r = pts[i][1], p0 = pts[(i - 1 + n) % n][0], p2 = pts[(i + 1) % n][0])
        each (r > 0 ? _fillet_pts(p0, p1, p2, r, fn) : [p1])]);
}

// Teardrop profile for a horizontal hole: circle of radius r plus a roof whose faces are `angle`
// degrees from vertical, apex on the +Y axis (a true point, so no bridge is needed).
module teardrop2d(r, angle = 45) {
    union() {
        circle(r = r);
        polygon([[-r * cos(angle), r * sin(angle)], [0, r / sin(angle)], [r * cos(angle), r * sin(angle)]]);
    }
}

// Honeycomb of pointy-top hexagonal openings filling `area` = [x, y] (centred), for perforated walls.
// cell = hexagon across flats, wall = web between openings. Openings that would cross the area edge
// are dropped, so the margin stays solid. Use as a 2D cutter:  linear_extrude(t) hex_grid(8, 1.6, [60, 40]);
module hex_grid(cell = 8, wall = 1.6, area = [60, 40]) {
    px = cell + wall; py = px * sqrt(3) / 2; R = cell / sqrt(3);
    nx = floor(area[0] / px) + 1; ny = floor(area[1] / py) + 1;
    for (j = [-ny : ny], i = [-nx : nx]) {
        x = i * px + (j % 2 == 0 ? 0 : px / 2); y = j * py;
        if (abs(x) + R * cos(30) <= area[0] / 2 && abs(y) + R <= area[1] / 2)
            translate([x, y]) rotate(30) circle(r = R, $fn = 6);
    }
}

// ---------------------------------------------------------------- 3D --------------------------------

// Extrude a CONVEX 2D child to height h with a 45° bottom chamfer c_bot (elephant's foot) and an
// optional 45° top chamfer c_top. hull() of inset slabs — no minkowski, fast in CGAL.
module chamfered_prism(h, c_bot = 0.4, c_top = 0) {
    hull() {
        if (c_bot > 0) linear_extrude(EPS) offset(r = -c_bot) children();
        translate([0, 0, c_bot]) linear_extrude(max(h - c_bot - c_top, EPS)) children();
        if (c_top > 0) translate([0, 0, h - EPS]) linear_extrude(EPS) offset(r = -c_top) children();
    }
}

// Box centred in XY on Z = 0 with filleted vertical edges (r) and chamfered bottom / top edges.
module rounded_box(size, r = 2, c_bot = 0.4, c_top = 0.8) {
    chamfered_prism(size[2], c_bot, c_top) rounded_rect([size[0], size[1]], r);
}

// Cut everything above z = h (preview sections; wrap in render() + color() for documentation renders).
module section_cut(h) {
    difference() { children(); translate([-1000, -1000, h]) cube(2000); }
}

// ---------------------------------------------------------------- Holes (cutters) -------------------
// All cutters are positioned by the caller (translate) and extend EPS beyond both faces.

// Vertical through-hole, diameter d + hole_clr (vertical holes print small), height h from z = 0.
module vertical_hole(d, h, clr = hole_clr) {
    translate([0, 0, -EPS]) cylinder(d = d + clr, h = h + 2 * EPS);
}

// Horizontal hole along the Y axis through a wall of thickness l (centred on the origin),
// teardrop-compensated so it prints round without support. angle = roof angle from vertical.
module teardrop_hole(d, l, angle = 45) {
    rotate([90, 0, 0]) linear_extrude(l + 2 * EPS, center = true) teardrop2d(d / 2, angle);
}

// Horizontal hole along the Y axis with a flattened top: a teardrop cut at cut * r, so the top is a
// short flat bridge (about 0.6 r wide at cut = 1.1). Use where the teardrop apex would break a surface.
module flat_top_hole(d, l, cut = 1.1) {
    r = d / 2;
    rotate([90, 0, 0]) linear_extrude(l + 2 * EPS, center = true)
        intersection() { teardrop2d(r, 45); translate([-r - 1, -r - 1]) square([2 * r + 2, r + 1 + cut * r]); }
}

// Blind bore rising from z = 0 to `depth` with a 45° cone roof that starts at the full bore
// width, so a flat-ended shaft still stops at `depth` and no support is needed.
module cone_roof_bore(d, depth, clr = hole_clr) {
    dd = d + clr;
    translate([0, 0, -EPS]) cylinder(d = dd, h = depth + EPS);
    translate([0, 0, depth - EPS]) cylinder(d1 = dd, d2 = 0.5, h = dd / 2);
}

// Hexagonal nut pocket. af = nut across flats, h = pocket depth, clr = total clearance on af.
// Orient the opening horizontally or give it a flat top when it must print without support.
module nut_trap(af, h, clr = 0.3) {
    translate([0, 0, -EPS]) cylinder(d = (af + clr) / cos(30), h = h + EPS, $fn = 6);
}

// Drainage hole through a floor of thickness t: chamfered on the underside (no elephant's foot
// closing it) and led in from above. d = 0 gives nothing, so the parameter can switch it off.
module drain_hole(d = drain_d, t = 2, clr = hole_clr, c = 0.6) {
    if (d > 0) {
        dd = d + clr;
        translate([0, 0, -EPS]) cylinder(d = dd, h = t + 2 * EPS);
        translate([0, 0, -EPS]) cylinder(d1 = dd + 2 * c, d2 = dd, h = c + EPS);
        translate([0, 0, t - c]) cylinder(d1 = dd, d2 = dd + 2 * c, h = c + EPS);
    }
}

// ---------------------------------------------------------------- Adhesion / standing parts ---------

// One brim ear (mouse ear) disc on the bed at the origin; union it onto a corner of the footprint.
module brim_ear(d = 10, t = brim_ear_t) { if (d > 0) cylinder(d = d, h = t); }

// Brim ears at a list of XY positions.
module brim_ears(positions, d = brim_ear_d, t = brim_ear_t) {
    for (p = positions) translate([p[0], p[1], 0]) brim_ear(d, t);
}

// Standard tab for standing flat parts (training sets): l × w footprint, t thick, on Z = 0,
// centred in X, growing in -Y from the origin.
module tab(l = 30, w = 8, t = 2.0) {
    translate([-l / 2, -w, 0]) cube([l, w, t]);
}

// Matching slot cutter in a stand: tab + clearance, `depth` deep from z = top down, with an entry
// chamfer. Place it with translate([x, y, top - depth]).
module slot(l = 30, t = 2.0, depth = 8, clr = 0.3, entry = 0.4) {
    tt = t + 2 * clr; ll = l + 2 * clr;
    translate([-ll / 2, -tt / 2, -EPS]) cube([ll, tt, depth + 2 * EPS]);
    translate([0, 0, depth - entry])
        linear_extrude(entry + EPS, scale = [(ll + 2 * entry) / ll, (tt + 2 * entry) / tt])
            square([ll, tt], center = true);
}

// ---------------------------------------------------------------- Previews (never exported) ---------
// % makes them background objects: visible in preview, absent from render and export.

module ghost_tube(d, l, axis = "x") {          // horizontal tube or rail through the origin
    %color("silver", 0.4)
        if (axis == "x") rotate([0, 90, 0]) cylinder(d = d, h = l, center = true);
        else rotate([90, 0, 0]) cylinder(d = d, h = l, center = true);
}
module ghost_pole(d, h) { %color("silver", 0.4) translate([0, 0, -h / 2]) cylinder(d = d, h = h); }
module ghost_device(size) { %color("lightblue", 0.4) translate([0, 0, size[2] / 2]) cube(size, center = true); }
module ghost_wall(w = 200, h = 200, t = 20) { %color("wheat", 0.3) translate([-w / 2, 0, 0]) cube([w, t, h]); }

// ===== end of helpers.scad =====
