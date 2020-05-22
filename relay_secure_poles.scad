use <roundedCube.scad>

// Relay secure poles for https://smile.amazon.com/gp/product/B07M88JRFY/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1

pole_height=10;
pole_diameter=2;
pole_x_distance=20;
pole_y_distance=45;

base_plate_thickness=1.2;
rounded_corner_radius=2;

module relay_secure_pole() {
    cylinder(h=pole_height, d=pole_diameter, center=false, $fn=50);
}

module relay_secure_poles() {
    translate([pole_x_distance/2, pole_y_distance/2, 0])
        relay_secure_pole();
    translate([pole_x_distance/2, -pole_y_distance/2, 0])
        relay_secure_pole();
    translate([-pole_x_distance/2, -pole_y_distance/2, 0])
        relay_secure_pole();
    translate([-pole_x_distance/2, pole_y_distance/2, 0])
        relay_secure_pole();
}

module base_plate() {
    roundedCube([pole_x_distance + pole_diameter*2, pole_y_distance + pole_diameter*2, base_plate_thickness], center=true, r=rounded_corner_radius);
}

relay_secure_poles();
base_plate();