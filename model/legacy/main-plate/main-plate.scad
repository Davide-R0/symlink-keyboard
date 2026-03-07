include <../config.scad>


module switch_outline() {
    translate([key_w/2, -key_w/2, 0])square(key_w, true);
}

// Hole for the top plate, switch fixed
module switch_hole() {
    translate([key_w/2, -key_w/2, 0])square(key_fix_hole_w, true);
}

// Hole needed in the pcb for the switch socket
module switch_socket_hole() {
    // TODO:
}

module switch_print() {
    difference () {
        switch_outline();
        *switch_hole();
    }
}

// keys array for the four ringers (no thumb)
module fingers_keys_array() {
    for (i = [0:n_col-1]) {
        for (j = [0:n_row-1]) {
            translate([i*key_w, -key_col_offsets[i], 0]) // Traslate for the column
            translate([0, -j*key_w, 0]) // Traslate for the row
            switch_print();
        }
    }
}

module circular_section_ring(low_r, high_r, start_theta, end_theta) {
    difference() {
        circle(high_r);
        
        union () {
            circle(low_r);
            rotate([0, 0, start_theta])
            translate([-high_r, 0, 0])
            square(high_r*2, true);
            
            rotate([0, 0, end_theta])
            translate([high_r, 0, 0])
            square(high_r*2, true);
        }
    }
    
}

//circular_section_ring(10, 20, 90, -20);

// keys array for the thumb
// TODO:_ cambiare questo modulo in una funzione ceh prende il tasto ed esegue il print e rotazione, dividerla di più
module thumb_keys_array(isStrip = false) {
    // 0 gradi si trova sulal linea tra le due colonne dell'indice
    // la distanza del centro del cerchio deve essere tale che i tasti sotto le due colonne del indice continuino la matrice.
    low_point = min(key_col_offsets[n_col-2]+key_w*n_row, key_col_offsets[n_col-1]+key_w*n_row);
    
    // Ora bisogna decidere le angolazioni giuste e i passi giusti per i tasti
    low_radius = thumb_rotation_radius - key_w/2;
    // TODO: calcolarlo...
    extra_y_offset = 2.5;
    high_radius = thumb_rotation_radius + key_w/2 + extra_y_offset;
    
    a = sqrt(pow(key_w/2, 2) + pow(low_radius, 2));
    half_theta = acos(low_radius/a);
    
    
    x_point = (n_col - 1)*key_w;
    y_point = -low_point-high_radius;
    
    start_angle = 2*half_theta * (n_thumb - n_thumb_r);
    end_angle = 2*half_theta * (n_thumb_r);
    rot_step = 2*half_theta; // rotation angle for each step
    
    
    delta = 0.01; // delta per farli con intersezioni
    // Right side
    for (t = [half_theta : rot_step : end_angle]) { // Da 0 a 120 gradi, ogni 30 gradi
        translate([x_point, y_point, 0])
        mirror([0,1,0])
        rotate([0, 0, t-90])
        translate([thumb_rotation_radius, 0, 0])
        translate([-key_w/2, key_w/2, 0])
        offset(delta){
        union() {
            switch_print();
            
            if (isStrip == true) {
                if (t < end_angle-rot_step) {
                    polygon([[0, 0], [key_w, 0], [key_w, key_w*tan(half_theta)]]);
                }
                translate([0, -key_w, 0])mirror([0,1,0])
                polygon([[0, 0], [key_w, 0], [key_w, key_w*tan(half_theta)]]);
            }
        }
        }
    }
    // Left side
    for (t = [half_theta : rot_step : start_angle]) { // Da 0 a 120 gradi, ogni 30 gradi
        translate([x_point, y_point, 0])
        rotate([0, 0, t+90])
        translate([thumb_rotation_radius, 0, 0])
        translate([-key_w/2, key_w/2, 0])
        offset(delta){
        union() {
            switch_print();
            
            if (isStrip == true) {
                if (t < start_angle-rot_step) {
                    polygon([[0, 0], [key_w, 0], [key_w, key_w*tan(half_theta)]]);
                }
                translate([0, -key_w, 0])mirror([0,1,0])
                polygon([[0, 0], [key_w, 0], [key_w, key_w*tan(half_theta)]]);
            }
        }
        }
    }
}




//Ora per fare il hull del array dei tasti principale bisogna riempire la parte bassa bene:
// - Trovare la colonna più bassa di tutte
// - allungare le colonne esterne della forma sino a questo valore
module finger_keys_array_hull() {
    max_offset = max(key_col_offsets);
    
    hull()
    union() {
        fingers_keys_array();
        
        translate([0, -n_row*key_w - max_offset])
        square([key_w, key_w*2]); // TODO: agigustare se servisse...
        translate([(n_col-1)*key_w, -n_row*key_w - max_offset])
        square([key_w, key_w*2]); // TODO: agigustare se servisse...
    }
    
}

module board_util() {
    max_offset = max(key_col_offsets);
    vertical_offset = key_w;
    
    translate([(n_col)*key_w, -n_row*key_w - max_offset])
    polygon([
    [0,0],
    [0, key_w*n_row - key_col_offsets[n_col-1]+max_offset],
    [util_w, key_w*n_row - key_col_offsets[n_col-1]+max_offset ],
    [util_w, - vertical_offset]
    ]);
    //square([util_w, key_w*n_row - key_col_offsets[n_col-1]+max_offset + vertical_offset]);
}



/*
// Metodo non funzionante
*offset(r = 4) {
    offset(r = -4) {
        finger_keys_array_hull();
        thumb_keys_array(true);
    }
}*/

minkowski() {
    radius = 3;
    union() {
        // Le tue forme originali (devono essere PIÙ PICCOLE del normale!)
        offset(r = -radius) {
            finger_keys_array_hull();
            thumb_keys_array(true);
            board_util();
       }
    }
    circle(r = radius*2);
}


/*
offset(r = 4) {
    
    offset(r = -4) {
        thumb_keys_array(true);
    }
}*/

#thumb_keys_array(true);
#finger_keys_array_hull();
#board_util();

module main_plate() {
    
    
}
