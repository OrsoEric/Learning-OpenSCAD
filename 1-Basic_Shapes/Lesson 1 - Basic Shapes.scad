//Cube size as 3D vector
3d_size = [0, 0, 0];
//Instance a cube
cube( 3d_size );
//Only the last assignment of a var counts, it retroactively overwrites
3d_size = [1, 2, 3];

//Mirror the cube by tralsating
//functions apply as a chain until a semicolomn
translate( -3d_size )
    cube( 3d_size );

//Rough sphere
sphere_radious = 1;
translate( [0,0,5] )
    sphere(sphere_radious);

//smooth Sphere
translate( [0,0,5+sphere_radious*2] )
    sphere(sphere_radious, $fn=100);
        
//Cone
translate( [0,-10,0] )    
    cylinder(5,3,2);
//Polygon
polygon( [ [5,5],  [0,10],  [10,5] ] );