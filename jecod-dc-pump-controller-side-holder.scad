// Holder for Jaeco DC Pump Controller

// Parameters

screws_position = 1; // values: 0 for "right", 1 for "left"

holder_thickness = 4;
holder_mount_width = 40;

holder_handle_thickness = 2;
holder_handle_width = 10;
holder_handle_length = 3;

controller_x = 107.25;
controller_y = 69.58;
controller_z = 26.32;

bolt_diameter      = 5;
bolt_head_diameter = 8;
bolt_head_height   = 2;
bolt_position      = 15;

frame_height = 2;

// Calculations
base_x  = controller_x + 2 * holder_handle_thickness;
base_y = controller_y + 2 * holder_handle_thickness;

total_x = base_x + holder_mount_width;

bolt_r = bolt_diameter / 2;
bolt_center = total_x - holder_mount_width / 2 - bolt_diameter / 2 + holder_handle_thickness * 2;

/**
 * run()
 */
run();
//debug();

/**
 * modules
 */
module debug() {
    m = [holder_handle_thickness,holder_handle_thickness,0-controller_z - frame_height];
    mirror([ screws_position, 0, 0 ])
    color([1,0,0])
        translate(m)
            cube([controller_x,controller_y,controller_z]);
}

module run() {
    mirror([ screws_position, 0, 0 ]) {
        difference() {
            union() {
                cube([total_x,base_y,holder_thickness]);
                frame();
            }
            bolts();
        }
        paws();
    }
}

module frame() {

    translate([0,0,-holder_handle_thickness]) {
        difference() {
            cube([controller_x+2*holder_handle_thickness,controller_y+2*holder_handle_thickness, frame_height]);
            translate([holder_handle_thickness+2,holder_handle_thickness+2,-.1]) {
                cube([controller_x-4,controller_y-4, frame_height+.2]);
            }
        }
    }
}

module bolts() {
    translate([bolt_center,0,-.1]) {
        translate([0,bolt_position + bolt_diameter / 2,0]) {
            bolt();
        }
        translate([0,base_y - bolt_position - bolt_diameter / 2,0]) {
            bolt();
        }
    }
}

module paws() {
    translate([0,base_y/2-holder_handle_width/2,0] ) {
        paw();
    }
    translate([base_x,base_y/2-holder_handle_width/2,0] ) {
        rotate([0,0,180]) {
            paw();
        }
    }
    translate([base_x/2+holder_handle_width/2,0,0] ) {
        rotate([0,0,90]) {
            paw();
        }
    }
    offset = 10;
    translate([offset,base_y,0] ) {
        rotate([0,0,-90]) {
            paw();
        }
    }
    x = controller_x-offset-holder_handle_width + 2 * holder_handle_thickness;
    translate([x,base_y,0] ) {
        rotate([0,0,-90]) {
            paw();
        }
    }
}

module paw() {
    z = controller_z + holder_thickness;
    translate([0,0,-z]) {
        union() {
            cube([holder_handle_thickness, holder_handle_width, z ]);
            hprism();
        }
    }
}

module bolt() {
    union() {
        translate( [0,0,holder_thickness - bolt_head_height + .2] ) {
        cylinder( h = bolt_head_height, r2 = bolt_head_diameter / 2, r1 = bolt_r, $fn=100 );
        }
        cylinder( h = holder_thickness + .2, r = bolt_r, $fn=100 );
    }
}       
module hprism() {
        l = holder_handle_width;
        h = holder_handle_length;
        w = holder_handle_thickness;
        translate([holder_handle_thickness-.1,0,0] ) {
            union() {
                translate([holder_handle_thickness,0,0] ) {
                    rotate([90,0,90]) {
                        prism( l, w, h );
                    }
                }
                cube([w,l,w]);
            }
        }
}

module prism(l, w, h) {
    polyhedron(// pt      0        1        2        3        4        5
               points=[[0,0,0], [0,w,h], [l,w,h], [l,0,0], [0,w,0], [l,w,0]],
               // top sloping face (A)
               faces=[[0,1,2,3],
               // vertical rectangular face (B)
               [2,1,4,5],
               // bottom face (C)
               [0,3,5,4],
               // rear triangular face (D)
               [0,4,1],
               // front triangular face (E)
               [3,2,5]]
               );
    }