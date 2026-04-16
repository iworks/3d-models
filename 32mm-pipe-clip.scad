// Holder for 32mm PCV-U pipe and suction cup

// Parameters
pipe_diameter      = 32.2;  // internal pipe diameter (includes 0.2mm tolerance)
pipe_gap_param     = 15;    // ring gap percentage
holder_wall        = 4;     // holder wall thickness
holder_width       = 10;    // holder width
holder_resolution  = 300;   // $fn parameter for holder
connector_heigh    = 2.2;   // connector height
connector_diameter = 5.7;   // connector diameter
suction_diameter   = 9;     // suction connector diameter
suction_heigh      = 3;     // suction connector height
suction_resolution = 100;   // $fn parameter for suction connector

// Calculated values
displacement = -pipe_diameter / 2;
holder_inline = pipe_diameter;

union() {
    // Ring
    difference() {
        union() {
            difference() {
                cylinder(
                    h = holder_width, 
                    d = holder_inline + 2 * holder_wall, 
                    $fn = holder_resolution
                );
                translate([0, 0, -1])
                    cylinder(
                        h = holder_width + 2, 
                        d = holder_inline, 
                        $fn = holder_resolution
                    );
            }
        }
        // Cut the ring
        gap = holder_wall * holder_inline * (pipe_gap_param / 100);
        translate([-gap / 2, 1, -1])
            cube([gap, holder_inline + holder_wall, holder_width + 2]);
    }
    
    // Suction connector column
    d1 = displacement;
    translate([0, d1, holder_width / 2])
        rotate([90])
        cylinder(
            h = connector_heigh + holder_wall + 1, 
            d = connector_diameter, 
            $fn = suction_resolution
        );
    
    // Suction connector
    d2 = displacement - connector_heigh - holder_wall;
    translate([0, d2, holder_width / 2])
        rotate([90])
        cylinder(
            h = suction_heigh, 
            d = suction_diameter, 
            $fn = suction_resolution
        );
}

