/*
Dies ist ein in OpenSCAD erstelltes Modell des Jupitersystems (Monde und Ringe des Jupiters).
Dies ist ein einfaches und statisches Modell ohne Simulation.

This is a model of Jovian system (moons and rings of jupiter) written in OpenSCAD. 
This is simple & static and does not have simulation.
*/

SCALE = 0.02; // Skalierungsfaktor für Entfernungen (Scale factor for distances)

// Radien der Monde (Radii of moons)
RADIUS_IO = 100;         
RADIUS_EUROPA = 150;    
RADIUS_GANYMEDE = 240;  
RADIUS_CALLISTO = 290;  
RADIUS_METIS = 39;      
RADIUS_ADRASTEA = 42;   
RADIUS_AMALTHEA = 56.5;   
RADIUS_THEBE = 67;    

// Farbe der Monde (Color of moons)
COLOR_IO = [212/255, 198/255, 107/255];
COLOR_EUROPA = [222/255, 223/255, 227/255];
COLOR_GANYMEDE = [143/255, 128/255, 113/255];
COLOR_CALLISTO = [180/255, 162/255, 133/255];
COLOR_METIS = [1, 1, 1];
COLOR_ADRASTEA = [1, 1, 1];
COLOR_AMALTHEA = [1, 1, 1];
COLOR_THEBE = [1, 1, 1];

// Farbe der Ringe (Color of rings)
COLOR_HALO_RING = [176/255, 196/255, 222/255, 0.7];
COLOR_MAIN_RING = [255/255, 99/255, 71/255, 0.7];    
COLOR_GOSSAMER_RING1 = [218/255, 165/255, 32/255, 0.7];  
COLOR_GOSSAMER_RING2 = [152/255, 251/255, 152/255, 0.7]; 

// Ringe der Umlaufbahnen (Orbital rings)
module orbit_ring_visible(radius) {
    color([1, 1, 1, 0.2]) {  
        cylinder(h=0.1, r1=radius, r2=radius); 
    }
}

// Modell des Jupiter in der Mitte (Jupiter's model at center)
module jupiter() {
    color([255/255, 229/255, 204/255]) {
        sphere(18);  
    }
}

// Darstellung von Umlaufbahnringen im 3D-Raum (Model of orbital rings in 3D space)
module orbit_ring(radius, ring_color) {
    color(ring_color) { 
        cylinder(h=0.2, r1=radius, r2=radius);  
    }
}

// Modell des Mondes (Moon's model)
module moon(radius, color) {
    color(color) {
        sphere(r=radius);
    }
}

// Etikett zur Angabe des Namens jedes Mondes (Labels to indicate name of every moon)
module label(text, position) {
    translate(position) {
        color([1, 1, 1]) {  
            text(text, size=6);  
        }
    }
}

// Jeder Ring des Jupiter (Every Jupiter's ring)
module halo_ring() {
    rotate([20, 0, 0]) {  
        orbit_ring(39, COLOR_HALO_RING);
    }
}
module main_ring() {
    rotate([5, 0, 0]) { 
        orbit_ring(47, COLOR_MAIN_RING);
    }
}
module gossamer_ring1() {
    rotate([0, 5, 0]) {  
        orbit_ring(56, COLOR_GOSSAMER_RING1);
    }
}
module gossamer_ring2() {
    rotate([0, -10, 0]) {  
        orbit_ring(66, COLOR_GOSSAMER_RING2);
    }
}


// Positionierung der Monde in ihren entsprechenden Umlaufbahnen
// (Positioning every moon in its corresponding orbit)
module moons() {
    rotate([0, 30, 0]) {
        translate([RADIUS_IO, 0, 0]) moon(10, COLOR_IO);
        orbit_ring_visible(RADIUS_IO); 
        label("Io", [RADIUS_IO + 10, 0, 0]);  
    }
    rotate([0, 45, 0]) {
        translate([RADIUS_EUROPA, 0, 0]) moon(10, COLOR_EUROPA);
        orbit_ring_visible(RADIUS_EUROPA);  
        label("Europa", [RADIUS_EUROPA + 10, 0, 0]); 
    }
    rotate([0, 60, 0]) {
        translate([RADIUS_GANYMEDE, 0, 0]) moon(10, COLOR_GANYMEDE);
        orbit_ring_visible(RADIUS_GANYMEDE);  
        label("Ganymede", [RADIUS_GANYMEDE + 10, 0, 0]);  
    }
    rotate([0, 75, 0]) {
        translate([RADIUS_CALLISTO, 0, 0]) moon(10, COLOR_CALLISTO);
        orbit_ring_visible(RADIUS_CALLISTO);  
        label("Callisto", [RADIUS_CALLISTO + 10, 0, 0]);
    }
    rotate([0, 90, 0]) {
        translate([RADIUS_METIS, 0, 0]) moon(5, COLOR_METIS);
        orbit_ring_visible(RADIUS_METIS); 
        label("Metis", [RADIUS_METIS + 10, 0, 0]); 
    }
    rotate([0, 110, 0]) {
        translate([RADIUS_ADRASTEA, 0, 0]) moon(5, COLOR_ADRASTEA);
        orbit_ring_visible(RADIUS_ADRASTEA); 
        label("Adrastea", [RADIUS_ADRASTEA + 10, 0, 0]); 
    }
    rotate([0, 135, 0]) {
        translate([RADIUS_AMALTHEA, 0, 0]) moon(5.5, COLOR_AMALTHEA);
        orbit_ring_visible(RADIUS_AMALTHEA);  
        label("Amalthea", [RADIUS_AMALTHEA + 10, 0, 0]); 
    }
    rotate([0, 150, 0]) {
        translate([RADIUS_THEBE, 0, 0]) moon(5.5, COLOR_THEBE);
        orbit_ring_visible(RADIUS_THEBE); 
        label("Thebe", [RADIUS_THEBE + 10, 0, 0]); 
    }
}

module jovian_system() {
    jupiter();
    halo_ring();
    main_ring();
    gossamer_ring1();
    gossamer_ring2();
    moons();
}
jovian_system();