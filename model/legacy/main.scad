include <config.scad> //Importa tutto del file, compreso le variabili
//use <file.scad> // Importa solo i moduli del file: module myModule() { ...}
use <main-plate/main-plate.scad>

/*
Assemblaggio parametrico:
// main_assembly.scad
use <plate.scad>
use <mcu_mount.scad>
include <config.scad> // dove u = 19.05

// Definiamo i parametri di assemblaggio come "Constraints"
distanza_mcu_da_bordo = 10;
spessore_plate = 1.6;

// Posizionamento Plate
color("gray") 
    disegna_plate();

// Posizionamento Supporto MCU relativo al plate
translate([distanza_mcu_da_bordo, -u, spessore_plate]) 
    rotate([0, 0, 90])
    supporto_nice_nano();
*/

/*
module tastiera_split(is_left = true) {
    if (is_left) {
        // Disegna la parte sinistra
        corpo_tastiera();
    } else {
        // Specchia la parte sinistra per fare la destra
        mirror([1, 0, 0]) corpo_tastiera();
    }
}

// Nel file di assemblaggio
tastiera_split(is_left = true);

translate([300, 0, 0]) 
    tastiera_split(is_left = false);
*/


/*
per fare l'outline della tastiera (il bordo esterno) che segua perfettamente i tasti, non disegnare linee. Usa hull() o minkowski():

Piazza dei cilindri nei quattro angoli dove vuoi i tasti estremi.

Racchiudili in un hull().

OpenSCAD creerà automaticamente la forma convessa che li unisce. È il modo più veloce per fare un outline ergonomico senza calcolare un singolo angolo.
*/