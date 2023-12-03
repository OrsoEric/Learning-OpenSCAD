// Include the OpenSCAD Threads Library
include <threads.scad>;

//Wrapper of the metric_thread module from threads.scad
// in_thread_diameter: Diameter of the thread
// in_pitch: Distance between each thread
// in_thread_length: Length of the threaded part of the bolt
module my_thread(in_pitch, in_thread_diameter, in_thread_length)
{
    metric_thread(diameter=in_thread_diameter, pitch=in_pitch, length=in_thread_length);
}

//centered cylinder that rests on its base
module centered_cylinder(in_height, in_diameter, in_edges)
{
   translate([0,0,in_height/2]) 
   cylinder(h=in_height, d=in_diameter,$fn=in_edges, center=true);
}

//An hexagon of diameter D (major diagonal) will have:
//side s = D/sqrt(3)
//minor diagonal d = sqrt(3) *D /2
//If you have a wrench of size 10mm, that's the minor diagonal difference
//An hexagon must have a major diagonal or diameter D = 2 *d /sqrt(3)
module hexagon_wrench(in_height, in_wrench_size)
{
    n_major_diameter = 2 *in_wrench_size /sqrt(3);
    centered_cylinder(in_height, n_major_diameter, 6);
}

//Bolt
// in_pitch: Distance between each thread
// in_thread_diameter: Diameter of the thread
// in_nut_diameter: Outer diameter of the nut
// in_thread_length: Length of the threaded part of the bolt
// in_grip_length: Length of the unthreaded part of the bolt
// in_nut_length: Thickness of the nut
module my_bolt(in_pitch, in_thread_diameter, in_nut_diameter, in_thread_length, in_grip_length, in_nut_length)
{    
    //Combine volumes into a single volume
    union()
    {
        //Nut of the bolt
        hexagon_wrench( in_nut_length, in_nut_diameter );
        //Grip of the bolt
        translate([0,0,in_nut_length])
        centered_cylinder( in_grip_length, in_thread_diameter, 100 );
        // Thread of the bolt
        translate( [0,0,in_nut_length+in_grip_length]) 
        my_thread(in_pitch, in_thread_diameter, in_thread_length); 
    }
}

//Nut
// in_pitch: Distance between each thread
// in_thread_diameter: Diameter of the thread
// in_nut_diameter: Outer diameter of the nut
// in_nut_length: Thickness of the nut
module my_nut(in_pitch, in_thread_diameter, in_nut_diameter, in_nut_length)
{    
    //Extrude a thread from the nut
    difference()
    {
        //Outer shape of the nut
        hexagon_wrench( in_nut_length, in_nut_diameter );
        // Inner thread of the nut
        my_thread(in_pitch, in_thread_diameter, in_nut_length); 
    }
}

    //PHYSICAL DIMENSIONS
//For 3D printing you want wider pitch than a standard Metric Thread
n_thread_pitch = 2.0;
//diameter of the thread
n_thread_diameter = 6.0;
//Size of the wrench you want to use
n_nut_wrench_size = 10;
//Thickness of the Nut
n_nut_thickness = 5;

    //MARGINS
//Margin to allow the threads on Nut and Bolt to mate
n_thread_margin = 1.2;
//Margin to allow the nut to fit inside the wrench
n_wrench_margin = 0.3;

//Distance between threads of the Nut
n_distance = 14;

//Instance a Bolt
translate([-n_distance/2,0,0])
my_bolt
(
    in_pitch=n_thread_pitch,
    in_thread_diameter=n_thread_diameter,
    in_nut_diameter=n_nut_wrench_size -n_wrench_margin,
    in_thread_length=15,
    in_grip_length=3,
    in_nut_length=n_nut_thickness
);

//Instance a Nut
translate([+n_distance/2,0,0])
my_nut
(
    in_pitch=n_thread_pitch,
    in_thread_diameter=n_thread_diameter +n_thread_margin,
    in_nut_diameter=n_nut_wrench_size -n_wrench_margin,
    in_nut_length=n_nut_thickness
);