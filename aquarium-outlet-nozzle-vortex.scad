/*
   Aquarium overflow vortex turbine for sump connection
   ----------------------------------------------------
Purpose:
This OpenSCAD model creates a small inline vortex/turbine body that can be
attached to a 40 mm aquarium drain tube and used on the outflow path into a sump.

Concept:
- Water enters through a 40 mm female socket
- Flow is guided into a round chamber
- The chamber creates swirl around a small rotor
- Water exits downward to the sump

Notes:
- This is mainly a DIY / prototype concept, not a pressure-rated plumbing part.
- Print in PETG or ABS for better water resistance than PLA.
- Add sealing (O-ring, silicone, or PVC-safe sealant) if used in a real system.
- A normal aquarium overflow will usually provide low pressure, so low-friction rotor
support is important.[web:25][web:32]

Parameters:
tube_outer      = outside diameter of the mating tube or pipe
tube_wall       = wall thickness of the printed female socket
basin_dia       = outside diameter of the vortex chamber
basin_height    = total height of the vortex chamber
blade_count     = number of rotor blades
shaft_dia       = diameter of the center shaft hole / shaft body

Typical tuning:
- Increase basin_dia for smoother swirl and lower restriction
- Increase blade_count for smoother torque, reduce for lower drag
 */

tube_outer = 22; // 40mm female tube OD
tube_outer_size = 4;
tube_wall = 2;   // PVC wall thickness
basin_dia = 40;  // Vortex basin inner dia
basin_height = 50;
shaft_dia = 5;

blade_count   = 5;
blade_angle   = 44;   // blade pitch angle in degrees
blade_height  = basin_height-tube_wall-.1;   // blade extrusion height
blade_length  = 13;   // radial blade length
blade_thick   = 2;    // blade thickness
hub_dia       = 10;   // center hub diameter

// Ring support structure for turbine shaft
spoke_count          = 6;    // number of connectors
spoke_width          = 1.5;  // connector thickness
spoke_height         = 3;    // z height of part

$fn = 200;

print = 1;


/**
 * produce
 */
translate([0,0,0]) vortex_basin();
translate([print? basin_dia+5:0,0,0]) blades();
translate([0,print? basin_dia+5:0,0]) ring_support();


module ring_support() {
    translate([0,0,print? 0:basin_height]) {
        spoke_len = (basin_dia - shaft_dia) / 2 - tube_wall;
        union() {
            // big ring
            difference() {
                cylinder(h = spoke_height, d = basin_dia);
                translate([0,0,-0.1])
                    cylinder(h = spoke_height + 0.2, d = basin_dia - 2 * tube_wall );
            }
            // small ring
            difference() {
                cylinder(h = spoke_height, d = shaft_dia+2*tube_wall);
                translate([0,0,-0.1])
                    cylinder(h = spoke_height + 0.2, d = shaft_dia);
            }
            // spokes fully inside the big ring opening
            color([.3,0,.5])
                for (i = [0 : spoke_count - 1]) {
                    rotate([0, 0, i * 360 / spoke_count])
                        translate([(shaft_dia + tube_wall )/2, -spoke_width / 2, 0])
                        cube([spoke_len, spoke_width, spoke_height]);
                }
        }
    }
}


module blades() {
    translate([0,0,tube_wall]) {
        color([.2,.3,.9])
            union() {
                // center hub
                cylinder(h = blade_height, d = hub_dia);
                // flat blades
                for (i = [0 : blade_count - 1]) {
                    rotate([0, 0, i * 360 / blade_count])
                        translate([hub_dia / 2, -blade_thick / 2, 0])
                        rotate([0, 0, blade_angle])
                        cube([blade_length, blade_thick, blade_height]);
                }
                // shaft core
                translate([0,0,-tube_wall]) cylinder(h = blade_height + 10, d = shaft_dia);
            }
    }
}


module vortex_basin() {
    difference() {
        color([1,0,0]) cylinder(h=basin_height, d=basin_dia);
        translate([0,0,tube_wall]) cylinder(h=basin_height, d=basin_dia - tube_wall);
        // Tangential inlet slot for tube
        translate([basin_dia/2 - tube_outer/2, -(tube_outer+tube_outer_size), tube_wall]) cube([tube_outer, tube_outer_size*tube_outer, 30]);
        // Central outlet hole
        translate([0,0,basin_height-10]) cylinder(h=150, d=25);
        translate([0,0,-10]) cylinder(h=basin_height, d=shaft_dia+.05);
    }
    translate([0,0,basin_height*2/3] ) {
        difference() {
            cylinder(h=basin_dia,r=basin_dia/2+tube_wall);
            translate([0,0,-1]) cylinder(h=basin_dia+2,r=basin_dia/2);
        }
    }
}

