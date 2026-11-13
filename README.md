# Circle Templates

A parameterized OpenSCAD model for 3D-printing circular templates (stencils) for
marking or cutting circles in fabric, paper or other thin material.

![Six templates in different sizes](images/six-sizes.jpg)

It began in a public library makerspace with button makers. The makerspace has
punches for paper, but many people want to cover their buttons with fabric, and
used to trace around a paper cut-out. A template holds the fabric flat while you
mark the circle through the slot with a pencil, chalk or fine marker. You can
also run a knife blade around the slot to cut most of the circle, then snip the
four short gaps left by the bridges.

Nothing here is specific to buttons, so the model makes a circular stencil of
any size.

## How it's built

Each template has three parts:

- an **outer frame**, a rectangular plate;
- an **inner ring** just inside the slot, which presses the material flat right
  next to the line; the center inside the ring is open, so you can see what you
  are framing;
- four **bridges** across the slot, holding the ring to the frame.

The circle you mark is the center line of the slot.

## Files

| File | What it is |
| --- | --- |
| `circle_template.scad` | The OpenSCAD model. All settings are at the top of the file. |
| `images/` | Photos of printed templates. |

## Quick start

1. Open `circle_template.scad` in [OpenSCAD](https://openscad.org/).
2. Open the Customizer (Window → Customizer) and set the circle's diameter, in
   inches or millimetres, and the template size.
3. Render (F6), export as STL or 3MF, and print it flat. No supports are needed.

## Parameters

| Parameter | Default | Meaning |
| --- | --- | --- |
| `circle_diameter` | 2.625 | Diameter of the circle to mark (the center line of the slot), in `units`. The default is correct for a large button maker. |
| `units` | in | Units for `circle_diameter`: `in` or `mm`. |
| `template_width` | 100 | Width of the outer frame. |
| `template_length` | 100 | Length of the outer frame. |
| `template_thickness` | 3 | Thickness of the template. |
| `slot_width` | 2 | Width of the slot you mark or cut through. |
| `ring_width` | 3 | Width of the inner ring. |
| `bridge_width` | 2 | Width of each of the four bridges across the slot. |
| `fill_center` | false | Leave the center solid, so the template is just a plate with a circular slot. |
| `circle_faces` | 360 | Number of faces on the circles. |
| `make_label` | true | Engrave the size into the frame below the slot. |
| `label_text` | (blank) | Text to engrave. Blank means the circle's size, such as `2 5/8 in` or `50 mm`. |
| `label_size` | 5 | Height of the lettering. |
| `label_depth` | 0.6 | Depth of the engraving. |
| `label_font` | Liberation Sans Bold | Font, by its OpenSCAD name (Help → Font List). |

Except for `circle_diameter` in inches, all lengths are in millimetres.

The frame must be wider than the slot; the model stops with a message if it
isn't, or if the ring is so wide that nothing is left for the center hole.

## The label

The label is engraved in the top face, centered in the strip of frame between
the slot and the near edge. Sizes in inches are written as fractions down to
32nds (`1 1/4 in`, `2 5/8 in`); anything else is written as a decimal.

If that strip is too narrow for `label_size`, the lettering is made smaller to
fit, keeping about 1 mm clear of the slot and the edge. If there is less than
2.5 mm of room, OpenSCAD prints a warning in its console; make the template a
little longer or turn the label off. The model doesn't check the label's
width, so keep custom text short on narrow templates.

## Printing

The templates in the photos were printed flat. The ones with a pebbled surface
were printed on a textured plate, and the face that was on the plate picks up
the texture.

## Gallery

| | |
| --- | --- |
| ![A stack of templates](images/stack.jpg) | ![Large template, textured side](images/closeup-textured.jpg) |
| A stack of templates. | The textured (plate) side. |
| ![Large template, smooth side](images/closeup-smooth.jpg) | ![Another large template, smooth side](images/closeup-smooth-2.jpg) |
| The smooth (top) side. | The ring, slot and bridges up close. |
| ![Small template, textured side](images/small-textured.jpg) | ![Small template, smooth side](images/small-smooth.jpg) |
| A small template, textured side. | A small template, smooth side. |

## License

MIT; see [LICENSE](LICENSE).

---

*This README was written by Claude (Anthropic) at Bob Drzyzgula's direction. The
model and the photographs are his.*
