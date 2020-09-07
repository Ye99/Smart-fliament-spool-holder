include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>
use <BOSL/transforms.scad>
use <SpoolHolderBraceRemix.scad>
include <OpenSCAD-common-libraries/screw_matrics.scad>

stem_length=36; // This exclude base lenght, and the end lock part.
stem_diameter=8;

lock_stem_length=3; // This is constant.
lock_pin_diameter=2;

base_length=2;
base_diameter=stem_diameter+4;

module pin() {
    union() {
        cylinder(d=base_diameter, h=base_length, $fn=80);
        
        up(base_length)
            difference() {
                cylinder(d=stem_diameter, h=stem_length + lock_stem_length, $fn=80);
                up(stem_length)
                    back(stem_diameter/2)
                        xrot(90)
                            cylinder(d=lock_pin_diameter, h=stem_diameter, $fn=80);
            }
    }    
}


pin();
