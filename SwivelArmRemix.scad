connector_thickness=4.8;
reduce_thickness=0.5;
connector_thickness_after_reduction=connector_thickness-reduce_thickness;

module cut_cylinder() {
    cylinder(h = 20, d=30, center = false, $fn=50);
}

module cut_bolt_holder() {    
    translate([connector_thickness_after_reduction/2, 0, 0])
        rotate([0, 90, 0])
            cut_cylinder();
    
    translate([-connector_thickness_after_reduction/2, 0, 0])
        rotate([0, -90, 0])
            cut_cylinder();
}

difference() {
    translate([-48.5, -12.5, -130])
        import("Swivel_Arm_v_1.0.STL");
        
    cut_bolt_holder();
}
