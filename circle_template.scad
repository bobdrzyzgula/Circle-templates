// SPDX-License-Identifier: MIT
// Circle Template generator 0.3
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm

// This model had its origins in a public library makerspace
// where I volunteer. We have button makers there, and punch-out
// tools for paper, but many people want to put fabric on the
// buttons. Previously they just would draw around a paper cut-
// out. I designed this code to create a template, or stencil, that
// they could use to hold down the fabric and make a clear mark
// -- or even use a knife blade to cut most of the circle.
//
// Nevertheless, this is generally useful to make circular
// stencils of any size. The model has three main elements -- an
// outer rectangular frame, an inner ring, and four bridges to
// connect the two. All of these are parameterized, so this
// could have a number of applications.
//
// If you do not want the center punch-out -- if you just want the
// rectangle with the circular slot -- set fill_center to true.

// Template width
template_width = 100;
// Template length
template_length = 100;
// Template thickness
template_thickness = 3;
// Diameter of the circle to mark (the center line of the slot), in the units below. The default, 2.625 inches, is correct for a large button maker.
circle_diameter = 2.625;
// Units for circle_diameter. All other dimensions are in mm.
units = "in"; // [in, mm]
// Slot width
slot_width = 2;
// Ring width (width of the inner ring)
ring_width = 3;
// Bridge width (width of the links holding the ring to the outer frame)
bridge_width = 2;
// Fill in the center, leaving only the frame, the slot and a solid disk
fill_center = false;
// Number of faces on the circles
circle_faces = 360; // [60:10:1000]

/* [Label] */

// Engrave the circle's size into the frame below the slot
make_label = true;
// Label text. Leave blank to use the circle's size, e.g. "2 5/8 in".
label_text = "";
// Height of the lettering. It is reduced automatically if the frame below the slot is too narrow.
label_size = 5;
// Depth of the engraving
label_depth = 0.6;
// Font, as OpenSCAD names it (Help > Font List)
label_font = "Liberation Sans:style=Bold";

/* [Hidden] */

function gcd(a, b) = b == 0 ? a : gcd(b, a % b);

// A size in inches as a whole number and a fraction in 32nds, e.g.
// "2 5/8 in", or as a decimal if it isn't an exact number of 32nds.
function inch_label(d) =
    let(n = round(d * 32), whole = floor(n / 32), num = n % 32,
        g = gcd(num, 32))
    abs(d * 32 - n) > 1e-6 ? str(d, " in")
    : num == 0 ? str(whole, " in")
    : str(whole > 0 ? str(whole, " ") : "", num / g, "/", 32 / g, " in");

circle_d_mm = units == "in" ? circle_diameter * 25.4 : circle_diameter;
slot_radius = circle_d_mm / 2;
label = label_text != "" ? label_text
    : units == "in" ? inch_label(circle_diameter)
    : str(circle_diameter, " mm");

outer_r = slot_radius + slot_width / 2;     // outside edge of the slot
inner_r = slot_radius - slot_width / 2;     // inside edge of the slot
punchout_r = inner_r - ring_width;          // edge of the center hole
// How far the bridges reach into the ring and the frame on either side of
// the slot, so that they fuse with both.
bridge_overlap = min(0.5, ring_width / 2);
// The strip of frame between the slot and the near edge holds the label,
// centered in it with at least 1 mm clear on each side.
label_gap = template_length / 2 - outer_r;
label_h = min(label_size, label_gap - 2);
label_y = -(outer_r + template_length / 2) / 2;

assert(template_thickness > 0, "template_thickness must be positive");
assert(slot_width > 0, "slot_width must be positive");
assert(ring_width > 0, "ring_width must be positive");
assert(bridge_width > 0, "bridge_width must be positive");
assert(units == "in" || units == "mm", "units must be \"in\" or \"mm\"");
assert(inner_r > 0, "circle_diameter must be more than the slot_width");
assert(!make_label || label_depth < template_thickness,
    "label_depth must be less than template_thickness");
if (make_label && label_h < 2.5)
    echo(str("WARNING: only ", max(label_h, 0), " mm of room for the label; ",
        "make the template longer or turn the label off"));
assert(2 * outer_r < min(template_width, template_length),
    str("the slot (", 2 * outer_r, " mm across) does not fit inside the template (",
        min(template_width, template_length), " mm)"));
assert(fill_center || punchout_r > 0,
    "ring_width leaves no room for the center hole; reduce it, or set fill_center to true");

// A cylinder through the full thickness of the template, for cutting.
module through(r) {
    cylinder(h = template_thickness + 2, r = r, center = true, $fn = circle_faces);
}

// The frame and ring: the plate with the slot and the center hole cut out.
difference() {
    cube([template_width, template_length, template_thickness], center = true);
    difference() {
        through(outer_r);
        through(inner_r);
    }
    if (!fill_center)
        through(punchout_r);
    if (make_label && label_h > 0)
        translate([0, label_y, template_thickness / 2 - label_depth])
            linear_extrude(label_depth + 1)
                text(label, size = label_h, font = label_font,
                    halign = "center", valign = "center");
}

// Four bridges across the slot, overlapping slightly into the ring and the
// frame.
intersection() {
    union() {
        cube([2 * outer_r + 2, bridge_width, template_thickness], center = true);
        cube([bridge_width, 2 * outer_r + 2, template_thickness], center = true);
    }
    difference() {
        cylinder(h = template_thickness, r = outer_r + bridge_overlap, center = true,
            $fn = circle_faces);
        through(inner_r - bridge_overlap);
    }
}
