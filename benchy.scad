/*

[x] Smooth, overhanging curved surface.

[x] Symmetry.

[x] High-resolution STL file.

[x] Planar horizontal surfaces.

[x] Tiny surface details (text oriented to face sideways).

[x] Cylindrical shapes.

[x] Overhangs.

[x] Low-slope surfaces (like the roof).

[x] Large and small horizontal holes (cylinders punched through the side horizontally).

[x] Small slanted holes (it has a fishing rod holder).

[x] First layer details (the shallow letters on the bottom).

*/

back_thickness = 5;
lip_width = 2;
lip_thickness = 1;
curve_length = 10;

curve_circumference = 4 * curve_length;
curve_radius = curve_circumference / 2 / PI;

armrest_width = 8;
armrest_length = 40;
armrest_height = 35;
armrest_thickness = 7;

pillar_width = 8;
pillar_wall_thickness = 3.5;

scale([0.5, 0.5, 0.5])
{
  intersection()
  {
    rotate([-5, 0, 0])
    difference()
    {
      union()
      {
        translate([0, back_thickness / 2, 0])
        rotate([90, 0, 0])
        linear_extrude(back_thickness)
        polygon(
          [
            for (x = [-100 : 100])
              [ x, 50 * pow(1.1, -x*x / 200) ]
          ]);

        translate([0, back_thickness / 2, 0])
        rotate([90, 0, 0])
        linear_extrude(back_thickness + lip_thickness)
        polygon(
          [
            [100, 0],
            [-100, 0],
            
            for (x = [-100 : 100])
              let (y = 50 * pow(1.1, -x*x / 200))
              [ x, y ],
            for (x = [100 : -1 : 100])
              let (y = 50 * pow(1.1, -x*x / 200))
              let (slope = 0.0476551 * exp(0.000476551 * x * x) * x)
              let (tangent_angle = atan(slope))
              [ x - lip_width * sin(tangent_angle), y - lip_width * cos(tangent_angle) ]
          ]);

        translate([0, -back_thickness / 2, 0])
        polyhedron(
          [
            for (z = [0 : -1 : -50 + curve_length / 2])
              let (w = 200 + z / 2)
              each
              [
                [-w/2, 0, z],
                [w/2, 0, z],
                [w/2, back_thickness, z],
                [-w/2, back_thickness, z]
              ],

            let (mz = -50 + curve_length / 2)
            for (z = [mz : -1 : -50 - curve_length / 2])
              let (t = (mz - z) / curve_length)
              let (u = (1 - t) / 4)
              let (v = u * u)
              let (q = v * 16)
              let (r = q * 2.5)
              let (w = (200 - 45 / 2 - 10 / 4 + r))
              let (a = -t * 90)
              each
              [
                [-w/2, -curve_radius + curve_radius * cos(a), mz + curve_radius * sin(a)],
                [w/2, -curve_radius + curve_radius * cos(a), mz + curve_radius * sin(a)],
                [w/2, -curve_radius + (curve_radius + back_thickness) * cos(a), mz + (curve_radius + back_thickness) * sin(a)],
                [-w/2, -curve_radius + (curve_radius + back_thickness) * cos(a), mz + (curve_radius + back_thickness) * sin(a)]
              ],
            
            let (mz = -50 + curve_length / 2)
            let (zv = mz - curve_radius)
            let (z1 = -50 - curve_length / 2)
            for (z = [z1 : -1 : -100])
              let (t = (z - z1) / (-100 - z1))
              let (y = -curve_radius - (z1 - z) * 1.265 - 1)
              let (w = 200 - (50 - curve_length / 2) / 2 - 10 / 4 + t * 5)
              each
              [
                [-w/2, y, zv],
                [w/2, y, zv],
                [w/2, y, zv - back_thickness],
                [-w/2, y, zv - back_thickness]
              ]
          ],
          [
            [0, 1, 2, 3],
            for (z = [0 : -1 : -100])
              let (r = -z * 4)
              each
              [
                [r, r + 1, r + 5, r + 4],
                [r + 1, r + 2, r + 6, r + 5],
                [r + 2, r + 3, r + 7, r + 6],
                [r + 3, r, r + 4, r + 7]
              ],
              
            let (c = 4 * 102)
            [c - 4, c - 3, c - 2, c - 1]
          ]);
      }

      translate([0, 0, 25])
      rotate([90, 0, 0])
      cylinder(10, d = 30, center = true, $fn = 80);
      
      for (i = [-1, 1])
      {
        translate([i * 30, 0, 10])
        rotate([90, 0, 0])
        cylinder(10, d = 15, center = true, $fn = 50);

        translate([i * 50, 0, 5])
        rotate([90, 0, 0])
        cylinder(10, d = 8, center = true, $fn = 50);
      }
    }

    union()
    {
      difference()
      {
        translate([0, 0, -50])
        minkowski()
        {
          union()
          {
            translate([0, -20, 0])
            for (i = [-1, 1])
              multmatrix(
                [[1, i * 0.125, 0, 0],
                 [0, 1, 0, 0],
                 [0, 0, 1, 0],
                 [0, 0, 0, 1]])
              translate([0, -5, 0])
              cube([145, 10, 10], center = true);
          }
          
          scale([2, 4, 1])
          sphere(d = 20, $fn = 100);
        }
      }
      
      rotate([-5, 0, 0])
      cube([200, back_thickness, 200], center = true);
    }
  }

  for (i = [-1, 1])
    difference()
    {
      translate([i * 100, 0, 0])
      rotate([-5, atan2(1, 4) * i, 0])
      translate([0, 0, -32])
      difference()
      {
        cylinder(74, d = pillar_width, center = true, $fn = 100);
        cylinder(80, d = pillar_width - pillar_wall_thickness, center = true, $fn = 100);
      }

      translate([0, 0, -165])
      cube([200, 200, 200], center = true);
    };

  difference()
  {
    translate([0, 0, -50])
    minkowski()
    {
      union()
      {
        translate([0, -15, 0])
        for (i = [-1, 1])
          multmatrix(
            [[1, i * 0.125, 0, 0],
             [0, 1, 0, 0],
             [0, 0, 1, 0],
             [0, 0, 0, 1]])
          translate([0, -5, 0])
          cube([145, 20, 10], center = true);
      }
      
      scale([2, 4, 1])
      sphere(d = 20, $fn = 100);
    }

    rotate([-5, 0, 0])
    translate([0, 102.5, 0])
    cube([200, 200, 200], center = true);
    
    rotate([-5, 0, 0])
    translate([0, -100, 100 - 52])
    cube([200, 200, 200], center = true);

    color("yellow")
    translate([0, -18, -65])
    linear_extrude(2)
    rotate([180, 0, 0])
    text("I'm doing my level best", size = 9, font = "Courgette-Regular", halign = "center");
  }

  translate([0, -1.5, -30])
  rotate([95, 0, 180])
  linear_extrude(2)
  text("I can do 4D, just give time", size = 9, font = "Courgette-Regular", halign = "center");

  for (i = [-1, 1])
  {
    scale([i, 1, 1])
    translate([90, -armrest_length / 2, armrest_height / 2 - 65])
    rotate([0, 0, atan(0.1) / 2])
    difference()
    {
      cube([armrest_width, armrest_length, armrest_height], center = true);
      
      translate([0, armrest_length / 2 + armrest_thickness, 0])
      scale([1, 1, 0.3])
      rotate([0, 90, 0])
      cylinder(50, d = armrest_length * 2, center = true, $fn = 100);
      
      translate([0, 50 - armrest_length / 2 + armrest_thickness, -50])
      cube([100, 100, 100], center = true);
    }
  }
}
