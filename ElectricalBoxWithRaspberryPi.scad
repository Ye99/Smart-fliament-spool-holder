/* By: Ye Zhang (mr.yezhang@gmail.com)
   Date: May 22, 2020
    Raspberry Pi breakout holder and electrical box. 
*/

use <roundedCube.scad>
use <relay_secure_poles.scad>

// Choose, which part you want to see!
part = "all_parts__";  //[all_parts__:All Parts,bottom_part__:Bottom,top_part__:Top, breakout_part__:Breakout]

// Standard width is 69.33mm. This is inner space width.
width=52; //[51:85]
// Inner space height. Default 41mm
height=41;  // [37:70]

// Wall thickness in mm, add to width and height. Actuall wall (including cover) thickness is
// half of this value. 
wall_double_thickness=3.5; // [1:4]
// outlet screw diameter (mm) for the holes at 2 ends
outlet_screw_hole_diag=3.4; // [3:6]
// the screw hole on box bottom tab, to secure the box.
bottom_tab_screw_hole_diag=5;
// width of hole to run the mains input wires (mm)
// This 14/2 wire width is 10, height is 5
wires_hole_width=11; // [8:12]
// height of hole to run the mains input wires (mm)
wires_hole_height=6; // [4:12]
// https://smile.amazon.com/gp/product/B000BPEQCC/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1

// this is relay control wire. Three wires.
relay_control_wires_hole_diameter=8; // [8:12]

// sensor wires to Raspberry Pi
rpi_input_wires_hole_diameter=12; // [8:18]

// radius for rounded corner
rounded_corner_radius=2;

cover_alignment_tab_length=3;
cover_alignment_tab_height=4;
// the larger this value, the more cover free-play allowed.
cover_alignment_tab_tolerance=0.2;

// Program Section //
if (part == "bottom_part__") {
    box();
} else if (part == "top_part__") {
    cover();
} else if (part == "breakout_part__") {
      breakout();
} else if (part == "all_parts__") {
    all_parts();
} else {
    all_parts();
}

module breakout_walls(width, length, height) {
    ow_width = width+wall_double_thickness;
    ow_length = length+wall_double_thickness;
    ow_height = height+wall_double_thickness/2;
    
    difference() {
        // box walls
        difference() {
            // outside wall
            roundedCube([ow_width, ow_length, ow_height], center=true, r=rounded_corner_radius,
            zcorners=[true, false, false, true]);
            // inside wall
            translate([wall_double_thickness/2, wall_double_thickness/2, wall_double_thickness/2]) 
                // make the inside wall wider/longer to cut two walls
                roundedCube([width+wall_double_thickness, length+wall_double_thickness, height],
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
        breakout_walls(width, length, height);
        
        translate([-(width+wall_double_thickness)/2-(rpi_box_x_with_tab+wall_double_thickness/2)/2, 
                0, 
                -(height)/2])
            rotate([0, 0, 180])
                rpi_box_holder(rpi_box_x_with_tab, rpi_box_y, rpi_box_z);
    }
}

module all_parts() {
translate([0, 0, (height+wall_double_thickness/2)/2]) 
    union() {
        box();
        translate([-width+wall_double_thickness/2, 0, 0])
            breakout();
    }

 // this put cover next to box
 translate([width+(wall_double_thickness*2), 0, (wall_double_thickness/2+cover_wall_height)/2])
 // this displacement puts the cover on top
 // translate([0,0,(height+wall_double_thickness/2)+1]) rotate([0, 180, 0])
    cover();
}

// Inner space length.
length=106; // Note: if you change this, you must update screw_posistion_from_edge and the value at "why is this magic number?" accordingly.
outlet_screw_hole_depth=35; // how far down is the outlet screw hole in supporting cylinder.
support_cylinder_radius=outlet_screw_hole_diag*2+1;

// distance between supporting cylinder and box top
cylinder_top_gap=5.5-wall_double_thickness; // deduct cover thickness so the outlet will be flush.

// outlet screw off set from edge. Change according to your measurement with caution!
// My desin references x,y,z 0 (center), and thus changing wall thickness won't inerference screw_position.
screw_posistion_from_edge=11; // Outlet screw holes are 84mm apart. Must be precise!

// cover wall height in mm, not including cover thickness.
cover_wall_height=3;

/* Raspberry Pi and its breakout board holders are part of the electrical box */
rpi_box_y=67;
rpi_box_x=27.5;
rpi_box_x_with_tab=29 ;
rpi_box_z=92;
rpi_box_holder_height=40;
// The holder is a triangle-shape bracket. This is one side's length.
rpi_box_holder_side_length=5;

module one_plug_hole() {
    difference(){
        cylinder(r=17.4625, h=15, center = true, $fn=50);
        translate([-24.2875,-15,-cover_wall_height*2]) cube([10,37,15], center=false);
        translate([14.2875,-15,-cover_wall_height*2]) cube([10,37,15], center=false);
   }
}

module cover_alignment_tab() {
    cube([wall_double_thickness/2, cover_alignment_tab_length, cover_alignment_tab_height], center=false);
}

module cover(width=width, length=length, height=height, screw_pos=screw_posistion_from_edge) {
    union() {
        difference() {        
           difference() {
                // outside wall
                roundedCube([width + wall_double_thickness, length + wall_double_thickness, cover_wall_height+wall_double_thickness/2], center=true, r=rounded_corner_radius);
                // inside wall
                translate([0, 0, wall_double_thickness/2]) 
                    roundedCube([width, length, cover_wall_height], center=true, r=rounded_corner_radius);
            } 

            // Outlet opening and screw hole
            rotate([0,0,90]) 
                translate([-length/2+12, 0, 0]) // why is this magic number?
                    union() {
                        translate([height+19.3915, 0, 0]) 
                        {
                            one_plug_hole();
                        }
                    
                        translate([height-19.3915, 0, 0]){
                            one_plug_hole();
                        }
                        
                        // center hole. 4mm diameter.
                        // printed holes tend to shrink, give it 5mm. 
                        translate([height, 0, -3]) cylinder(r=2.5, h=20, $fn=50); 
                        translate([height, 0, 3.5]) cylinder(r1=2.5, r2=3.3, h=3);            
                    }
        }
        
        translate([-width/2+cover_alignment_tab_tolerance, length/3, 0]) 
            cover_alignment_tab();
        translate([-width/2+cover_alignment_tab_tolerance, -length/3, 0]) 
            cover_alignment_tab();
    }
}

module box_walls(ow_width, ow_length, ow_height) {
        difference() {
            // box walls
            difference() {
                // outside wall
                roundedCube([ow_width, ow_length, ow_height], center=true, r=rounded_corner_radius,
                zcorners=[false, true, true, false]);
                // inside wall
                translate([0, 0, wall_double_thickness/2]) 
                    roundedCube([width, length, height], center=true, r=rounded_corner_radius);
            } 
        
           // mains input wires hole on side wall
           translate([ow_width/2, -(ow_length/4), -ow_height/4])
                // cube's x, y, z parameters confirm to the overall axes, making reasoning simple. 
                cube([wall_double_thickness*2, wires_hole_width, wires_hole_height], center=true);
            
           // control input wires hole on the other side wall
           translate([-ow_width/2, (ow_length/4), -ow_height/3])
            rotate([0, 90, 0])
                cylinder(d=relay_control_wires_hole_diameter, h=wall_double_thickness, center=true, $fn=50);
    }
}

module outlet_screw_cylinder(length, ow_height, screw_pos) {
    cylinder_height = ow_height - cylinder_top_gap;

    translate([0, -length/2, -ow_height/2])
        difference(){
                // the support cylinder
                scale([1, 2.1, 1]) 
                    cylinder(h=cylinder_height, 
                            r1=support_cylinder_radius, 
                            r2=support_cylinder_radius, $fn=60, center=false);
                
                translate([0, -support_cylinder_radius*1.5, ow_height/2+wall_double_thickness]) // to make tab strong, its thickness equals to wall_double_thickness
                 {
                    scale([1, 1.5, 1])
                        // remove half of the outer cylinder                  
                        cube([support_cylinder_radius*2, support_cylinder_radius*2, 
                              ow_height], true);
                    // screw hole in the outside cylinder tab
                    translate([0, 2, -3])
                        cylinder(r=bottom_tab_screw_hole_diag/2, h=ow_height*2, $fn=50, center=true);
                }
                    
                // screw hole in the cylinder
                translate([0, screw_pos, cylinder_height-outlet_screw_hole_depth+1]) {
                        cylinder(r=outlet_screw_hole_diag/2, h=outlet_screw_hole_depth, $fn=50, center=false);
            }
        }
}

module lengh_support(ow_width, ow_height, wall_double_thickness) {
    rotate([0,0,90]) 
        translate([0, -(ow_width/2)+wall_double_thickness/2, -ow_height/2])
            scale([1, 0.6, 1]) // support_cylinder_radius shrink widthwise, leave more room for outlet body.
                difference(){
                    cylinder(ow_height, support_cylinder_radius, support_cylinder_radius, $fn=60);
                    translate([-support_cylinder_radius, -support_cylinder_radius*2-1, -1])
                        cube([support_cylinder_radius*2, support_cylinder_radius*2, ow_height+wall_double_thickness]);
                }
}

/*
 * Function box()
 * Draw the box 
 */
module box(width=width, length=length, height=height, screw_pos=screw_posistion_from_edge) {
    ow_width = width+wall_double_thickness;
    ow_length = length+wall_double_thickness;
    ow_height = height+wall_double_thickness/2;
   
    box_walls(ow_width, ow_length, ow_height);
      
    // outlet screw cylinder
    outlet_screw_cylinder(length, ow_height, screw_pos);
    // the other one
    rotate([0,0,180])  
        outlet_screw_cylinder(length, ow_height, screw_pos);
    
    // support lengh-wide
    lengh_support(ow_width, ow_height, wall_double_thickness);
    
    // the other support lengh-wide
    rotate([0,0,180]) 
        lengh_support(ow_width, ow_height, wall_double_thickness);
    
    translate([0, 0, -(height+wall_double_thickness/2)/2]) 
        relay_secure_poles();
}