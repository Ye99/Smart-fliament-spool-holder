/* By: Ye Zhang (mr.yezhang@gmail.com)
   Date: May 22, 2020
    Raspberry Pi breakout holder and electrical box. 
*/

use <OpenSCAD-common-libraries/roundedCube.scad>
use <relay_secure_poles.scad>
use <triangles.scad>
include <OpenSCAD-common-libraries/size_constants.scad>
include <OpenSCAD-common-libraries/electrical_box.scad>
use <BOSL/transforms.scad>

// Choose, which part you want to see!
part = "all_parts__";  //[all_parts__:All Parts,electrical_box_bottom:ElectrialBoxBottom,electrical_box_cover:ElectricalBoxCover, breakout_bottom:BreakoutBottom, breakout_cover:BreakoutCover]

/* Raspberry Pi and its breakout board holders are part of the electrical box */
rpi_box_y=67;
rpi_box_x=27.5;
rpi_box_x_with_tab=29 ;
rpi_box_z=92;
rpi_box_holder_height=40;
// The holder is a triangle-shape bracket. This is one side's length.
rpi_box_holder_side_length=5;

// sensor wires to Raspberry Pi
rpi_input_wires_hole_diameter=12; // [8:18]

// radius for rounded corner
rounded_corner_radius=2;

// the larger this value, the more cover free-play allowed.
cover_alignment_tab_tolerance=0.3;

// leave space for RPI 40pin dupoint cable.
breakout_ribbon_cable_hole_height=15; // [15:35]

breakout_cover_height=height-breakout_ribbon_cable_hole_height;
// leave space so cover and bottom will fit snuggly. 
breakout_cover_free_play=0.3;

// RPI 40pin ribbon cable width. Actual 59.
breakout_ribbon_cable_width=60; // [59: 65]

// Program Section //workaround
if (part == "electrical_box_bottom") {
    electricalbox_buttom(has_out_wire_hole=false);
} else if (part == "electrical_box_cover") {
    electricalbox_cover();
} else if (part == "breakout_bottom") {
    breakout();
    %translate([0, 0, (height-breakout_cover_height+wall_double_thickness/4)/2])
        breakout_cover_fixed_parameters();
} else if (part == "breakout_cover") {
    translate([0, 0, (breakout_cover_height+wall_double_thickness*3/2)/2])
        rotate([180, 0, 90])
            breakout_cover_fixed_parameters();
} else if (part == "all_parts__") {
    all_parts();
} else {
    all_parts();
}

/* shared function to follow "DRY" principle */
module breakout_cover_fixed_parameters() {
    breakout_cover(breakout_ribbon_cable_width, length, breakout_cover_height);
}

module breakout_walls(width, length, height) {
    ow_width = width+wall_double_thickness/2; // only one side has wall
    ow_length = length+wall_double_thickness; // both sides have wall
    ow_height = height+wall_double_thickness/2; // only bottom has wall
    
    difference() {
        // box walls
        difference() {
            // outside wall
            roundedCube([ow_width, ow_length, ow_height], center=true, r=rounded_corner_radius,
            zcorners=[true, false, false, true]);
            // inside wall. 
            translate([wall_double_thickness/2, wall_double_thickness/2, wall_double_thickness/2]) 
                // make the inside wall wider/longer to cut two walls
                roundedCube([width+wall_double_thickness/2, length+wall_double_thickness, height],
                            center=true, r=rounded_corner_radius); 
            
            // control input wires hole on the side wall
            translate([0, -ow_length/2, -ow_height/4])
                rotate([90, 0, 0])
                cylinder(d=rpi_input_wires_hole_diameter, h=wall_double_thickness, center=true, $fn=50);
        } 
    }
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

module rpi_box_holder(rpi_box_x, rpi_box_y, rpi_box_z) {
    wall_thickness=wall_double_thickness/2;
    
    union() {
        roundedCube([rpi_box_x+wall_thickness, rpi_box_y+wall_double_thickness, wall_thickness], 
            center=true, r=wall_thickness/2,
            zcorners=[false, true, true, false]);
        
        translate([(rpi_box_x)/2, -(rpi_box_y+wall_thickness)/2, 0]) 
            rpi_box_brace(wall_thickness);
        
        translate([(rpi_box_x)/2, (rpi_box_y+wall_thickness)/2, 0]) 
            rotate([0, 0, 90])
                rpi_box_brace(wall_thickness);
    }
    
    translate([-(rpi_box_x+wall_thickness)/2, -rpi_box_y/2, 0])
        %mock_rpi_case();
}

module breakout() {
    union() {
        breakout_walls(breakout_ribbon_cable_width, length, height);
        
        translate([-(breakout_ribbon_cable_width+wall_double_thickness/2)/2-(rpi_box_x_with_tab+wall_double_thickness/2)/2, 
                    0, 
                    -(height)/2])
            rotate([0, 0, 180])
                rpi_box_holder(rpi_box_x_with_tab, rpi_box_y, rpi_box_z);
        
        breakout_cover_support(height);
    }
}

/* Breakout compartment only has one side wall. This module add a tab on the 
shared wall to support cover. */
module breakout_cover_support(height) {
    wall_thickness=wall_double_thickness/2;
    translate([(breakout_ribbon_cable_width+wall_thickness)/2, 
                -length*3/10-cover_alignment_tab_tolerance, 
                (height+wall_thickness)/2])
        rotate([0, 90, 90])
            a_triangle(30, 8, length*4/5);
}

module breakout_cover_cube(width, length, height, wall_thickness) {
    roundedCube([width+wall_thickness, length+wall_thickness*2, height+wall_thickness],
                center=true, r=rounded_corner_radius,
                zcorners=[false, true, true, false]);
}

// cover is L-shaped
// width and length don't include buttom wall thickness
module breakout_cover(width, length, height) {
    wall_thickness=wall_double_thickness/2;
    
    translate([0, 0, wall_thickness])
    rotate([0, 0, 180])
        union() {
            difference() {
                breakout_cover_cube(width, length, height, wall_thickness);
                translate([0, wall_thickness, -wall_thickness])
                    breakout_cover_cube(width, length, height, wall_thickness);
                
                // remove cover vertical side edge. 
                translate([(width-wall_thickness)/2-breakout_cover_free_play, 
                            -length/2-wall_thickness, 
                            -(height+wall_thickness)/2])
                    cube([wall_thickness+breakout_cover_free_play, wall_thickness*3, height]);
            }
            
            // inner tab
            translate([-(width-wall_thickness)/2-wall_thickness, 
                        length/2-wall_thickness-cover_alignment_tab_tolerance, 
                        (height-wall_thickness)/2-cover_alignment_tab_height])
                cube([width-rounded_corner_radius, wall_thickness, cover_alignment_tab_height]);
            
            // outer tab
            translate([-(width-wall_thickness)/2-wall_thickness, 
                    length/2+wall_thickness, 
                    (height-wall_thickness)/2-cover_alignment_tab_height])
                cube([width-rounded_corner_radius, wall_thickness, cover_alignment_tab_height+wall_thickness]);
        }
}

module all_parts() {
    union() {
        electricalbox_buttom(has_out_wire_hole=false);
        translate([-breakout_ribbon_cable_width+wall_double_thickness/2, 0, (height+wall_double_thickness/2)/2])
            breakout();
    }
    
    // this put cover next to box
    right(width+(wall_double_thickness*1.7))
        electricalbox_cover();
    
 translate([0, (length+breakout_ribbon_cable_width)/2 + support_cylinder_radius*support_cylinder_scale_factor + 3, 
           (breakout_cover_height+wall_double_thickness*3/2)/2])
    rotate([180, 0, 90])
        breakout_cover_fixed_parameters();
}

