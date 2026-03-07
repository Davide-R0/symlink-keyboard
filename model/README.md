per i distanziatori esagonali e per lassemblaggio delel parti (dove si possono definire gli "anchors") usare la libreria: `BOSL2`

Ad esempio: 
include <BOSL2/std.scad>

// Il cubo non è al centro, ma "poggia" sul piano con la faccia inferiore
cuboid([20, 20, 20], anchor=BOTTOM);

cuboid([10, 10, 5], anchor=BOTTOM) {
    attach(TOP) 
        cyl(d=3, l=10, anchor=BOTTOM);
}


