use <roundedCube.scad>;
use <SpoolHolderBraceRemix.scad>;

// screw diameter in mm. including thread. 
// for 4mm screw.
screw_diameter=4.1; // anticipate printed hole will shrink.
// screw_len

arm_height=25.5;
arm_length=60;
arm_thickness=17;
arm_thickness_reduction=3;
arm_angle=14.8;

rounded_corner_radius=2;

bolt_holder_area_diameter=20;

// distance between screw holes on arm, x axis.
arm_screw_hole_x_shift=8;

// distance shifted from the next screw hole, y axis.
arm_screw_hole_y_shift=sin(arm_angle)*arm_screw_hole_x_shift;

module arm_screw_hole() {
    translate([arm_thickness_reduction, 81, 51])
        rotate([0, 90, 0])
            #cylinder(d=screw_diameter, h=35, center=false, $fn=50);
}

module arm_screw_hole1() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole();
}

module arm_screw_hole2() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole1();
}

module arm_screw_hole3() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole2();
}

module arm_screw_hole4() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole3();
}

module arm_screw_hole5() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole4();
}

module arm_screw_hole6() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        arm_screw_hole5();
}

module fill_original_holes() {    
    translate([arm_thickness/2+arm_thickness_reduction, arm_height/2+75, 79])
        rotate([-arm_angle, 0, 0])
            roundedCube([arm_thickness, arm_height, arm_length], center=true, r=rounded_corner_radius);
}

module spool_bracket() {
    translate([arm_thickness_reduction, 94, 27])
        rotate([arm_angle, 0, 180])
            brace();
}

module spool_bracket1() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket();
}

module spool_bracket2() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket1();
}

module spool_bracket3() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket2();
}

module spool_bracket4() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket3();
}

module spool_bracket5() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket4();
}

module spool_bracket6() {
    translate([0, arm_screw_hole_y_shift, arm_screw_hole_x_shift])
        spool_bracket5();
}

module reduce_arm_thickness() {
    translate([-arm_thickness+arm_thickness_reduction, arm_height/2+51, 35])
        rotate([-arm_angle, 0, 0])
            cube([arm_thickness, arm_height, arm_length*1.5]);
}

/*
    Remove the extruded bolt holder, so I can use more types of screws. 
*/
module cut_bolt_holder() {    
    translate([23.5, 71.5, 12.5])
        rotate([0, -90, 0])
            cylinder(d=bolt_holder_area_diameter, h=25, center=true, $fn=50);
}

union() {
    difference() {
        union() {
            translate([-5, -16, 0])
                import("Rocker_Arm_v1.1.STL");
            
            fill_original_holes();
        }
        
        arm_screw_hole();
        arm_screw_hole1();
        arm_screw_hole2();
        arm_screw_hole3();
        arm_screw_hole4();
        arm_screw_hole5();
        arm_screw_hole6();
        cut_bolt_holder();
        reduce_arm_thickness();
    }
    
    // spool_bracket();
    // try spool_bracket1-6 to simulate bracket relation with arm hole. Nice!
}