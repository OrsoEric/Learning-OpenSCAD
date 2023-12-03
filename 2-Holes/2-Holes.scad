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

//An hexagon of diameter D (major diagonal) will have:
//side s = D/sqrt(3)
//minor diagonal d = sqrt(3) *D /2
//If you have a wrench of size 10mm, that's the minor diagonal
//An hexagon must have a major diagonal or diameter D = 2 *d /sqrt(3)
//For a 10mm wrench, the diameter of the hexagon is 11.55mm
module hexagon_wrench(in_wrench_size, in_height)
{
    n_major_diameter = 2 *in_wrench_size /sqrt(3);
    hexagon(n_major_diameter, in_height);
}

//extrusion is subtraction between first and second volumes
difference() {
    color("green")
        plate( n_plate_size, n_plate_size, n_plate_thickness);
    
    color("yellow")
        translate([0, 0, 0])
            hexagon_wrench( 5.2, n_plate_thickness);
}