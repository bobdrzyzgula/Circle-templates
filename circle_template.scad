// SPDX-License-Identifier: MIT
// Circle Template generator 0.1
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
// Note that if you do not want the center punch-out -- if you
// just want the rectangle with the circular slot -- you can do
// so by setting the "ring width" to slightly more than the
// "slot radius". It will then fill in the center.


// Template width
template_width = 100;
// Template depth
template_length = 100;
// Template thickness
template_thickness = 3;
// Slot width in
slot_width = 2;
// Slot raidius (distance from center of template to center of slot). Default is equal to 2.625 inches, correct for a large button maker.
slot_radius = 33.3375;
// Ring width (width of the inner ring)
ring_width = 3;
// Bridge width (width of the links holding the ring to the outer square
bridge_width = 2;

punchout_radius = slot_radius - ring_width - slot_width/2;

difference () {
    cube([template_width,template_length,template_thickness],center=true);
    union() {
        difference() {
            cylinder(h=template_thickness+2,r=slot_radius+slot_width/2,center=true,$fn=600);
            cylinder(h=template_thickness+2,r=slot_radius-slot_width/2,center=true,$fn=600);
            }
        cylinder(h=template_thickness+2,r=punchout_radius,center=true,$fn=600);
    }
    }
difference ()
    {
        union() {
            cube([template_width,bridge_width,template_thickness],center=true);
            cube([bridge_width,template_length,template_thickness],center=true);
            }
        union() {
            cube([punchout_radius*2+0.05,bridge_width+0.05,template_thickness+2],center=true);
            cube([bridge_width+0.05,punchout_radius*2+0.05,template_thickness+2],center=true);
            }
    }
            