// pipe_cross_clamp_context.scad — context-of-use renders (MSF "3D Printing for All"). Never exported.
// OpenSCAD 2021.01 or newer. Includes the part file (not `use`) so that every -D override given to
// render_views.py reaches the parts too; the part file's own build is switched off by pcc_context.
// Pipes, bolts and zip ties are stand-ins for illustration only.
//   openscad -o img/x_installed.png -D 'scene="installed"' --viewall --autocenter pipe_cross_clamp_context.scad
/* [Hidden] */
// set BEFORE the include: the part file then draws nothing by itself
pcc_context = true;
include <pipe_cross_clamp.scad>

/* [Scene] */
// Which scene to show
scene = "installed"; // [installed:Installed, exploded:Exploded, section:Section]
// Separation of the caps in the exploded view (mm)
explode = 25; // [0:5:80]
// Section plane placed automatically (at the crossing for bolts, through the first tie for zip ties)
section_auto = true;
// Section plane position along pipe 1 when not automatic (mm)
section_x = 0; // [-100:1:100]
// Length of the stand-in pipes (mm)
pipe_len = 170; // [80:10:300]

assert($preview, "pipe_cross_clamp_context.scad is for preview renders only — export parts from pipe_cross_clamp.scad");

module pipes() {
    color("silver") translate([0, 0, -clamp_gap / 2]) rotate([0, 90, 0]) cylinder(d = pipe1_d, h = pipe_len, center = true);
    color("silver") translate([0, 0, T + clamp_gap / 2]) rotate([0, 0, angle]) rotate([0, 90, 0]) cylinder(d = pipe2_d, h = pipe_len, center = true);
}
module bolts_standin(ex) {
    zb = -clamp_gap - floor_t - ex;                      // floor of the cap 1 counterbore (head side)
    zt = T + clamp_gap + floor_t + ex;                   // floor of the cap 2 nut well
    if (is_bolts) for (q = bolt_pts) translate(q) color("dimgray") {
        translate([0, 0, zb - washer_t - bolt_d * 0.7 - ex]) cylinder(d = bolt_d, h = zt - zb + nut_h + 2 + 2 * ex + washer_t + bolt_d * 0.7);
        translate([0, 0, zb - washer_t - bolt_d * 0.7 - ex]) cylinder(d = nut_af * 1.12, h = bolt_d * 0.7, $fn = 6);   // head
        translate([0, 0, zb - washer_t - ex]) cylinder(d = washer_d, h = washer_t);
        translate([0, 0, zt + ex]) cylinder(d = nut_af * 1.12, h = nut_h, $fn = 6);                                  // captive nut
    }
}
module ties_standin() {                                   // the visible part of each zip-tie loop
    if (!is_bolts) color("black") {
        for (s = [-1, 1]) translate([s * e1, 0, -clamp_gap / 2]) intersection() {
            rotate([0, 90, 0]) difference() { cylinder(r = r1 + tie_t, h = tie_w, center = true); cylinder(r = r1, h = tie_w + 1, center = true); }
            translate([-50, -100, -200]) cube([100, 200, 200]);
        }
        for (s = [-1, 1]) translate([0, 0, T + clamp_gap / 2]) rotate(angle) translate([s * e2, 0, 0]) intersection() {
            rotate([0, 90, 0]) difference() { cylinder(r = r2 + tie_t, h = tie_w, center = true); cylinder(r = r2, h = tie_w + 1, center = true); }
            translate([-50, -100, 0]) cube([100, 200, 200]);
        }
    }
}
module clamp_parts(ex) {
    color("ivory") render() body();
    if (is_bolts) {
        color("ivory") render() translate([0, 0, -clamp_gap - ex]) rotate([180, 0, 0]) cap1();
        color("ivory") render() translate([0, 0, T + clamp_gap + ex]) rotate(angle) cap2();
    }
}

sx = section_auto ? (is_bolts ? 0 : e1) : section_x;
if (scene == "installed") { clamp_parts(0); pipes(); bolts_standin(0); ties_standin(); }
else if (scene == "exploded") { clamp_parts(explode); pipes(); bolts_standin(explode); }
else if (scene == "section") {
    render() difference() { union() { clamp_parts(0); } translate([sx, -500, -500]) cube(1000); }
    color("silver") render() difference() { pipes(); translate([sx, -500, -500]) cube(1000); }
    if (is_bolts) render() difference() { bolts_standin(0); translate([sx, -500, -500]) cube(1000); }
}
