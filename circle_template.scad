// SPDX-License-Identifier: MIT
// Circle Template generator 0.2
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
// Slot width
slot_width = 2;
// Slot radius (distance from the center of the template to the center of the slot). The default, 33.3375 mm, marks a circle 2.625 inches (66.675 mm) in diameter, correct for a large button maker.
slot_radius = 33.3375;
// Ring width (width of the inner ring)
ring_width = 3;
// Bridge width (width of the links holding the ring to the outer frame)
bridge_width = 2;
// Fill in the center, leaving only the frame, the slot and a solid disk
fill_center = false;
// Number of faces on the circles
circle_faces = 360; // [60:10:1000]

/* [Hidden] */

outer_r = slot_radius + slot_width / 2;     // outside edge of the slot
inner_r = slot_radius - slot_width / 2;     // inside edge of the slot
punchout_r = inner_r - ring_width;          // edge of the center hole
// How far the bridges reach into the ring and the frame on either side of
// the slot, so that they fuse with both.
bridge_overlap = min(0.5, ring_width / 2);

assert(template_thickness > 0, "template_thickness must be positive");
assert(slot_width > 0, "slot_width must be positive");
assert(ring_width > 0, "ring_width must be positive");
assert(bridge_width > 0, "bridge_width must be positive");
assert(inner_r > 0, "slot_radius must be more than half the slot_width");
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
