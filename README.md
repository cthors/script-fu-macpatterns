# script-fu-scripts
custom scripts for GNU Image Manipulation Program

### layers-to-patterns.scm:
Saves each layer in the current document to a .pat pattern file for use with the paint can tool, etc.
Gives the option to enlarge the layer by 4x or 8x, to create patterns that appear to have larger pixels.

### mac_patterns.xcf:
A sample file to run layers-to-patterns on

### How-to:
1. Copy layers-to-patterns.scm to the GIMP's script folder. "Layers to Patterns" should now appear at the bottom of the Filters menu.
2. Open mac_patterns.xcf and run "Layers to Patterns." This will add the classic MacPaint patterns to the GIMP.
