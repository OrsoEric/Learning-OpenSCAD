//Plate centered and on origin
n_plate_size = 10;
n_plate_thickness = 2;

//Create a plate
module plate(in_size_x, in_size_y, in_height)
{
    //Translate upward by half height to rest on plane
    translate([0,0,in_height/2])
    cube([in_size_x, in_size_y, in_height], center=true);
}

//Create an exagonal pillar
module hexagon(in_diameter, in_height)
{
    //Translate upward by half height to rest on plane
    translate([0,0,in_height/2])
    //Make a rough cylinder with six sides
    cylinder(r=in_diameter/2, h=in_height, $fn=6, center=true);
}

//extrusion is subtraction between first and second volumes
difference() {
    color("green")
        plate( n_plate_size, n_plate_size, n_plate_thickness);
    
    color("yellow")
        translate([0, 0, 0])
            hexagon(6.2, n_plate_thickness);
}