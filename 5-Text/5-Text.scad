// Define the size of the plate
plate_width = 50;
plate_height = 20;
plate_thickness = 3;

// Define the text and its properties
text_size = 3;
text_thickness = 1;

//Make a rounded rectangle. It's aligned to the bottom left corner
module rounded_rectangle(length, width, radius, height)
{
    // Corners
    translate([radius, radius, 0])
        cylinder(h=height, r=radius, $fn=50);
    translate([length - radius, radius, 0])
        rotate([0, 0, 90])
            cylinder(h=height, r=radius, $fn=50);
    translate([radius, width - radius, 0])
        rotate([0, 0, -90])
            cylinder(h=height, r=radius, $fn=50);
    translate([length - radius, width - radius, 0])
        rotate([0, 0, 180])
            cylinder(h=height, r=radius, $fn=50);

    // Sides
    translate([radius, 0, 0])
        cube([length - 2 * radius, width, height]);
    translate([0, radius, 0])
        cube([length, width - 2 * radius, height]);
}

//Add holes to the rectangle
module rounded_rectangle_holes(length, width, radius, height, in_hole_size, in_hole_distance )
{
    difference()
    {
        rounded_rectangle(plate_width, plate_height, 10, plate_thickness);
        
        translate([plate_width/2-in_hole_distance/2, plate_height/2, plate_thickness])
        cylinder(h=10,r=2,center=true,$fn=100);
        
        translate([plate_width/2+in_hole_distance/2, plate_height/2, plate_thickness])
        cylinder(h=10,r=2,center=true,$fn=100);
    }
    
    
}

//Add text to the rectangle. positive and negative Z
module plate_with_text()
{
    difference()
    {
        union()
        {
            // Create the plate
            rounded_rectangle_holes(plate_width, plate_height, 10, plate_thickness, 3.2, 40);

            // Create the text
            translate([plate_width/2, plate_height*2/3, plate_thickness])
            {
                linear_extrude(height = text_thickness)
                {
                    text("Embossed Text", size = text_size, halign = "center", valign = "center");
                }
            }
        }
        // Create the text
        translate([plate_width/2, plate_height*1/3, plate_thickness-text_thickness])
        {
            linear_extrude(height = text_thickness)
            {
                text("Debossed Text", size = text_size, halign = "center", valign = "center");
            }
        }
    }
}

plate_with_text();
