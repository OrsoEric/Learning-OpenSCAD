//V1.0 prints and closes
//V2.0
// too much game, increase diameter of male thread
//increase inner hole, can use more space
//Make bottom thinner, can use more space

// Include the OpenSCAD Threads Library
include <threads.scad>;

//Thread Wrapper
// in_thread_diameter: Diameter of the thread
// in_pitch: Distance between each thread
// in_thread_length: Length of the threaded part of the bolt
module my_thread(in_thread_diameter, in_pitch, in_thread_length) {
    
    metric_thread(diameter=in_thread_diameter, pitch=in_pitch, length=in_thread_length);
}

//centered cylinder that rests on its base
// in_outer_diameter: Outer diameter of the cylinder
// in_height: Height of the cylinder
// in_edges: Number of sides of the cylinder
module centered_cylinder(in_outer_diameter, in_height, in_edges)
{
   translate([0,0,in_height/2]) 
   cylinder(h=in_height, d=in_outer_diameter,$fn=in_edges, center=true);
}

//Can with male thread
// in_pitch: Distance between each thread
// in_thread_diameter: Diameter of the thread
// in_height: Thickness of the nut
module my_tank(in_pitch, in_thread_diameter, in_diameter, in_thread_length,  in_height, in_wall_thickness)
{
    //Stack a cylinder, a thread, then extrude a cylinder
    
    //Thickness of the bottom
    n_bottom_thickness = in_wall_thickness;
    //Stack cylinder and thread
    difference()
    {
        union()
        {
            centered_cylinder( in_diameter, in_height, 100 );
            translate( [0,0,in_height]) 
                my_thread(in_thread_diameter, in_pitch, in_thread_length);
        }
        //Extrude the inner space
        translate( [0,0,((in_thread_length +in_height)/2)+n_bottom_thickness]) 
        cylinder(in_thread_length +in_height, d=in_diameter-9-in_wall_thickness,$fn=100, center=true);
    }
}

//Lid with female thread
// in_pitch: Distance between each thread
// in_thread_diameter: Diameter of the thread
// in_thread_length: Length of the threaded part of the case
// in_case_thickness: Thickness of the case wall
module my_lid(in_pitch, in_thread_diameter, in_thread_length, in_bottom_thickness, in_wall_thickness)
{
    
    difference()
    {
        //Body of the Lid
        centered_cylinder( in_thread_diameter+in_wall_thickness, in_thread_length +in_bottom_thickness, 100);
        // Inner part of the case
        translate([0, 0, +in_bottom_thickness])
            my_thread(in_thread_diameter, in_pitch, in_thread_length);
    }
    
}


//DIMENSIONS
//Outer diameter of the Can
n_can_diameter = 80.0;
//Thickness of the outer Walls
n_wall_thickness = 5.0;

//MARGINS
n_thread_margin = 1.0;

// Create a hollow case with a male thread of diameter 75 mm
translate([50, 0,0])
my_tank
(
    in_pitch = 3,
    in_thread_diameter = n_can_diameter -n_wall_thickness,
    in_diameter = n_can_diameter,
    in_thread_length=10,
    in_height=30,
    in_wall_thickness=5
);

translate([-50, 0,0])
my_lid(3, 75 +n_thread_margin, 10, 5, 4);


