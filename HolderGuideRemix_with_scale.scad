include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/transforms.scad>
use <SpoolHolderBraceRemix.scad>
use <load_cell.scad>
use <SpoolHolderBrace_with_scale_Remix.scad>

// This is for 16mm long screw. 
screw_extrude_length=4;

difference() {
    union() {
        translate([0, 61, 0])
            import("Ball_bearing_spool_holder/3DPNFilHoldGuide.stl");
        
        right(23)
            up(3.5)
                back(41)
                    cube([25, 2, 18.5]);
    }
    
    // Cut the brace connector part. I use load cell to connect the holder guide and brace. 
    left(12)
        down(1)
            fwd(1)
                cube([20, 50, 28]);
    
    right(33)
        up(5)
            back(28)
                yrot(-90)
                    load_cell(screw_extrude_length); // If you forgot passing parameter, compiler returns strange message "WARNING: Unable to convert translate([0, undef, 0]) parameter to a vec3 or vec2 of numbers, in file ../../../.local/share/OpenSCAD/libraries/BOSL/transforms.scad, line "
}

right(33)
    up(5)
        back(28)
            yrot(-90)
                %load_cell(screw_extrude_length); 

left(29.5)
    back(43.1)
        down(7)
            %brace();

/*
down(7)
    back(2)
        %brace(); */

// 