//
// stepper_tensioner (rev 3) - 20121118-1017
//
// (c)Jeremie Francois (jeremie.francois@gmail.com)
//	http://www.thingiverse.com/MoonCactus
//	http://betterprinter.blogspot.com
//
// Licence: Attribution - Share Alike - Creative Commons
//

$fn=40;
tol=0.02;

main_th= 2; // base plate thickness

m3_d= 3;
m3_d_free= 3 + 0.2;
m3_head_d= 5.5 + 0.2;
m3_nylock_th= 3.8;
m3_nylock_d= 6.1 + 0.1;
m3_nylock_d_freeplay= 6.1 + 2.0;
m3_washer= 6.8 + 0.2;
m3_washer_th= 0.5 + 0.5;

holder_margin= 3; // margin around screw holes
balance_distance= 3; // leave some length on the motor side!
idle_holder_len= 8; // how long is the "tunnel" that hold the screw head
lock_holder_len= 10; // how long is the "tunnel" that hold nylock nut

// Swap the two spacing_xxx and set balance to zero if you want the adjustment screw head to point downwards
spacing_lock_side= 15; // narrow side
hole_d_lock_side= m3_d_free;

// NEMA 17 dimensions
spacing_idle_side= 1.220*2.54*10; // mounting holes distance (31mm)
hole_d_idle_side= m3_d_free; // add 6mm for a piece of bowden as thermal insulator

// How thick are the walls around the adjusting screw
holder_nut_wall_th= 9.5; // must be > m3_washer

// Misc computed dimensions
holder_width= holder_nut_wall_th/2;
motor_margin= 10-balance_distance;
idle_holder_hole_x= 15 + balance_distance;
ear_r= hole_d_lock_side/2+holder_margin;

module motor_side()
{
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					// The motor plate
					hull()
					{
						translate([-motor_margin,0,0])
						{
							translate([0,+spacing_lock_side/2,0]) cylinder(r=ear_r, h=main_th);
							translate([0,-spacing_lock_side/2,0]) cylinder(r=ear_r, h=main_th);
						}
						translate([lock_holder_len-ear_r,0,0])
						{
							translate([0,+holder_width,0]) cylinder(r=ear_r, h=main_th);
							translate([0,-holder_width,0]) cylinder(r=ear_r, h=main_th);
						}
					}
					// The screw nest on the motor plate
					translate([-m3_nylock_th,0,0])
						screw_nest(lock_holder_len + m3_nylock_th);
				}
				// The m3 void
				translate([lock_holder_len-lock_holder_len-tol,0,holder_nut_wall_th/2+tol])
					rotate([0,90,0])
						cylinder(r=m3_d_free/2, h= lock_holder_len+20);

				// The m3 nylock hole
				translate([0,0,holder_nut_wall_th/2+tol])
				{
					hull()
					{
						// tight
						rotate([0,90,0])
							cylinder(r=m3_nylock_d/2, h= m3_nylock_th, $fn=6);
						// conic
						translate([-m3_nylock_th-m3_nylock_th,0,0])
							rotate([0,90,0])
								cylinder(r=m3_nylock_d_freeplay/2, h= tol, $fn=6);
					}
				}
			}
		}

		// Remove holes
		translate([0,0,-tol])
		{
			// Screw mount holes with some freeplay
			translate([-motor_margin,+spacing_lock_side/2,0]) cylinder(r=hole_d_lock_side/2, h=main_th+2*tol);
			translate([-motor_margin,-spacing_lock_side/2,0]) cylinder(r=hole_d_lock_side/2, h=main_th+2*tol);
		}
		// Make sure it's flat on the bottom
		translate([-50,-50,-100]) cube([100,100,100]);
	}
}

module screw_nest(len)
{
	hull()
	{
		translate([0,-holder_nut_wall_th/2-1,0])
			cube([len,holder_nut_wall_th+2,main_th]);

		translate([0,0,holder_nut_wall_th/2+tol])
			rotate([0,90,0])
				cylinder(r=holder_nut_wall_th/2, h= len);
	}
}


module fixed_side()
{
	translate([lock_holder_len+1,0,0])
	{
		difference()
		{
			union()
			{
				// plate
				hull()
				{
					translate([ear_r,0,0])
					{
						translate([0,+holder_width,0]) cylinder(r=ear_r, h=main_th);
						translate([0,-holder_width,0]) cylinder(r=ear_r, h=main_th);
					}
					translate([idle_holder_hole_x,0,0])
					{
						translate([0,+spacing_idle_side/2,0]) cylinder(r=hole_d_idle_side/2+holder_margin, h=main_th);
						translate([0,-spacing_idle_side/2,0]) cylinder(r=hole_d_idle_side/2+holder_margin, h=main_th);
					}
				}
				screw_nest(idle_holder_len);
			}

			// The m3 void
			translate([-tol,0,holder_nut_wall_th/2+tol])
				rotate([0,90,0])
					cylinder(r=m3_d_free/2, h= idle_holder_len+2*tol);
			// The m3 washer void
			translate([-tol+idle_holder_len,0,holder_nut_wall_th/2+tol])
				rotate([0,90,0])
					cylinder(r=m3_washer/2, h= m3_washer_th+2*tol);
			// The m3 head void
			translate([-tol+idle_holder_len+1,0,holder_nut_wall_th/2+tol])
				rotate([0,90,0])
					cylinder(r=m3_head_d/2, h= idle_holder_len+2*tol+100);

			translate([idle_holder_hole_x,0,-tol])
			{
				translate([0,+spacing_idle_side/2,0]) cylinder(r=hole_d_idle_side/2, h=main_th+2*tol);
				translate([0,-spacing_idle_side/2,0]) cylinder(r=hole_d_idle_side/2, h=main_th+2*tol);
			}

		}
	}
}

motor_side();

fixed_side();


