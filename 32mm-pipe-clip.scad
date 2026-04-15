// Holder for 32mm PCV-U pipe and suction cup

pipe_diameter      =  32.2; // internal pipe diameter - add .2
pipe_gap_param     =  15;   // rig gap
holder_wall        =   4;   // holder wall
holder_width       =  10;   // holder width
holder_resolution  = 300;   // $fn param for holder
connector_heigh    =   9;   // connector width
connector_diameter =   5.7; // connector_diameter
suction_diameter   =   9;   // suction connector diameter
suction_heigh      =   3;   // suction connector heigh
suction_resolution = 100;   // $fn param for suction connector

union() {
    // ring
    difference() {
        union() {
            difference() {
                cylinder(h=holder_width, d=pipe_diameter + 2*holder_wall, $fn=holder_resolution);
                translate([0, 0, -1])
                    cylinder(h=holder_width+2, d=pipe_diameter, $fn=holder_resolution);
            }
        }
        // cut the ring
        gap = holder_wall * pipe_diameter * ( pipe_gap_param / 100 );
        translate([-gap/2,1,-1])
            cube([gap, pipe_diameter+holder_wall, holder_width+2]);
    }
    // suction connector
    translate([0, -pipe_diameter/2, holder_width  /2 ])
        rotate([90])
        cylinder(h=connector_heigh,d=connector_diameter, $fn=suction_resolution);
    translate([0,-pipe_diameter/2-holder_wall-2.2, holder_width  /2 ])
        rotate([90])
        cylinder(h=suction_heigh,d=suction_diameter, $fn=suction_resolution);
}

