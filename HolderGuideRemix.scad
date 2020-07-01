include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/transforms.scad>
use <SpoolHolderBraceRemix.scad>

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
        %brace();