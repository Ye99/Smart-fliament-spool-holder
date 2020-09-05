include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/transforms.scad>
use <SpoolHolderBraceRemix.scad>
include <OpenSCAD-common-libraries/screw_matrics.scad>

// Wire end is M5 screw; other end is M4
x_length=16; // base is 12.7, to leave space for wire.
y_length=13.1; // base 12.7
z_length=80;

screw_to_end_distance=5;
between_adjacent_screws_distance=15;
screw_group_distance=55;

// cell hole area z lengh 17mm
hole_researved_area_z_length=z_length-(screw_to_end_distance*2+between_adjacent_screws_distance)*2;
hole_researved_area_y_protrude_thickness=8;
hole_researved_area_x_protrude_thickness=8;

module position_screw(surrounding_wall_thickness) {
    up(screw_to_end_distance)
        fwd(surrounding_wall_thickness)
        right(x_length/2)
            xrot(90)
                children();
}

module duplicate_two_screws() {
    children();
    up(between_adjacent_screws_distance)
        children();
}

module hole_reserved_area() {
    #cube([x_length+hole_researved_area_x_protrude_thickness, y_length+hole_researved_area_y_protrude_thickness, hole_researved_area_z_length]);
}

// surrounding_wall_thickness determins how much screw protrude from block surface, leaving space for the wall. 
module load_cell(surrounding_wall_thickness) {
    union() {
        cube([x_length, y_length, z_length]);
        fwd(hole_researved_area_y_protrude_thickness/2)
            left(hole_researved_area_x_protrude_thickness/2)
                up(screw_to_end_distance*2+between_adjacent_screws_distance)
                    hole_reserved_area();
        
        duplicate_two_screws()
            position_screw(surrounding_wall_thickness)
                #m4_screw();
        
        duplicate_two_screws()
            up(screw_group_distance)
                position_screw(surrounding_wall_thickness)
                    #m5_screw();
    }
    
}

module m4_screw() {
        screw(number4_screw_hole_diameter, 
               screwlen=number4_screw_stem_length,
               headsize=number4_screw_head_diameter,
               headlen=3, countersunk=false, align="base");
}

module m5_screw() {
        screw(number5_screw_hole_diameter, 
               screwlen=number5_screw_stem_length,
               headsize=number5_screw_head_diameter,
               headlen=3, countersunk=false, align="base");
}

load_cell(surrounding_wall_thickness=3);

/*
module cut_locking_bolt_hole() {    
    up(26)
        right(2)
            back(4.5)
                #lock_screw_hole();
}

difference() {
    translate([0, 61, 0])
        import("Ball_bearing_spool_holder/3DPNFilHoldGuide.stl");
        
    cut_locking_bolt_hole();
}

down(7)
    back(2)
        %brace();*/