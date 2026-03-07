//-----------
//Constants
//-----------

// Text on plugin
use <vendor/text_on_OpenSCAD/text_on.scad>

/* [General OpenSCAD] */
//$fa //minimum angle
//$fs //minimum size
$fn = 90; //number of segments
//$t //animation step
//$vpr //viewport rotation angles in degrees
//$vpt //viewport translation
//$vpd //viewport camera distance
//$vpf //viewport camera field of view
//$children //number of module children
//$preview //true in F5 preview, false for F6

/* [Keyboard Layout] */
n_row = 4;
n_col = 6;
n_thumb = 5;
n_thumb_r = 3; // how many switch are in the right portion of the phumb arch (to respect of the middle of the last two columns)

/* [Keyboard Shape] */
// The middle finger is the reference point, then the other fingers are considered in lower positions with offset as unit U as number of 1/12 the dimension of a switch (19.05/12)
key_w = 19.05; // Keys full width
key_fix_hole_w = 14; // Hole dimension for the top plate and switch incastro

// Offsets for: little finger left, little finger right, ring finger, middle finger (should be = [0]), index finger left, index finger right. In genral for a layout should contain n_col numbers. [mm]
key_col_offsets = [20, 18, 6, 0, 8, 10];

// Thumb rotation ratius [mm]
thumb_rotation_radius = 75;

// How large the part of the keyboard with the microcontroller si in base. .... (?)
util_w = 40;

/* [Battery] */
// NOTE: this is the battery dimension of the biggest one (the left one, the rght one should be smaller or equal in all dimensions
// Battery Height [mm]
battery_h = 30;
// Battery Width [mm]
battery_w = 40;
// Battery Lenght [mm]
battery_l = 50;

/* [Mechanical] */
// PCB Top plate Height [mm]
// [1.0 : 0.1 : 3.0]
pcb_top_h = 1.2;    // NOTE: mi sembra che va un valore preciso per incastrare i tasti?
// PCB Main plate Height [mm]
// [1.0 : 0.1 : 3.0]
pcb_main_h = 1.6;
// PCB Bottom Plate Height [mm] (also for the back battery)
// [1.0 : 0.1 : 3.0]
pcb_bottom_h = 1.6;
// Screw diameters [mm]
// [2:M2, 2.5:M2.5, 3:M3]
screw_d = 2.5;
// ...
// distanziatori di ottone
// Connettore per il supporto
