/* By: Ye Zhang (mr.yezhang@gmail.com)
   Date: Sept 3, 2020
    Electrical box and RPI3 holder.
*/

use <OpenSCAD-common-libraries/roundedCube.scad>
use <relay_secure_poles.scad>
use <triangles.scad>
include <OpenSCAD-common-libraries/size_constants.scad>
include <OpenSCAD-common-libraries/electrical_box.scad>
use <BOSL/transforms.scad>

// Choose, which part you want to see!
part = "all_parts__";  //[all_parts__:All Parts,electrical_box_bottom:ElectrialBoxBottom,electrical_box_cover:ElectricalBoxCover, breakout_bottom:BreakoutBottom, breakout_cover:BreakoutCover]

rpi_box_y=61.6;
rpi_box_x=27.5;
rpi_box_x_with_tab=rpi_box_x;
rpi_box_z=90.2;
rpi_box_holder_height=height;
// The holder is a triangle-shape bracket. This is one side's length.
rpi_box_holder_side_length=5;

rpi_box_GPIO_side_support_z_length=19;

// Control wires to relay in the electric box
relay_wires_hole_diameter=9; // [8:18]

// radius for rounded corner
rounded_corner_radius=2;

// Program Section //workaround
if (part == "electrical_box_bottom") {
    electricalbox_buttom(has_out_wire_hole=false);
} else if (part == "electrical_box_cover") {
    electricalbox_cover();
} else if (part == "all_parts__") {
    all_parts();
} else {
    all_parts();
}

module rpi_box_brace_one_side(wall_thickness) {
    hull() {
            translate([rpi_box_holder_side_length, 0, 0]) 
                circle(d=wall_thickness, $fn=50);
            circle(d=wall_thickness, $fn=50);
    }
}

module rpi_box_brace(wall_thickness) {
    translate([0, 0, wall_thickness/2+rpi_box_holder_height/2])
        rotate([0, 0, 90])
            linear_extrude(height=rpi_box_holder_height, center=true, convexity = 10)    
                union() {
                    rpi_box_brace_one_side(wall_thickness);
                    rotate([0, 0, 90])
                        rpi_box_brace_one_side(wall_thickness);
                }
}

/* Virtual rpi case to simulate rpi fit. */
module mock_rpi_case() {
    cube([rpi_box_x_with_tab, rpi_box_y, rpi_box_z]);
}

// Add one wall thickness to rpi_box_x, because it has only one wall. 
module rpi_box_holder(rpi_box_x, rpi_box_y, rpi_box_z) {
    wall_thickness=wall_double_thickness/2;
    up(wall_thickness/2) {
        union() {
            roundedCube([rpi_box_x+wall_thickness, rpi_box_y+wall_double_thickness, wall_thickness], 
                center=true, r=wall_thickness/2,
                zcorners=[false, true, true, false]);
            
            up(wall_thickness/2)
                left(rpi_box_x/2+wall_thickness)
                    fwd((rpi_box_y)/2+wall_thickness)
                    cube([rpi_box_GPIO_side_support_z_length, wall_thickness, height], center=false);
            
            translate([(rpi_box_x)/2, (rpi_box_y+wall_thickness)/2, 0]) 
                rotate([0, 0, 90])
                    rpi_box_brace(wall_thickness);
        }
        
        translate([-(rpi_box_x+wall_thickness)/2, -rpi_box_y/2, 0])
            %mock_rpi_case();
    }
}

module all_parts() {
    difference() {
        union() {
            electricalbox_buttom(has_out_wire_hole=false);
            fwd(22.69)
                left((width+wall_double_thickness)/2+rpi_box_x/2+wall_double_thickness/4)
                    zrot(180)
                        rpi_box_holder(rpi_box_x, rpi_box_y, rpi_box_z);
        }
        
        // Cut control input wires hole on the wall of electrical box
        translate([-width/2, length/4, height/5.45])
            rotate([0, 90, 0])
                #cylinder(d=relay_wires_hole_diameter, h=wall_double_thickness, center=true, $fn=50);
    }
    
    // this put cover next to box
    right(width+(wall_double_thickness*1.7))
        electricalbox_cover();
}
