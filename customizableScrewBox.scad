//Customizable stackable screw box
include <Round-Anything/polyround.scad>


drawerDepth = 260;
/* [Outside Box Dimensions] */
//Box Length
boxLen=200;
//Box Width
boxWid=121.6;
//Box Height
boxHgt=51;
//Wall thickness
boxThick=1.2;
radius = 5;
// Percentage of slope to use
slope_radius_pct=0.8;//0.0:1.0

/* [Compartments] */
// Number of Compartments
numSections=1;
// Merge sections (make one side bigger, use 2 or more to merge, 0 or 1 to normal)
mergeSections=1;

/* [Hidden] */
$fn=$preview ? 32 : 64;

dividerCount=mergeSections?numSections-mergeSections:numSections-1;

module roundedCylinder(h, r, r1, r2) {
    radiiPoints=[
        [0,   0,   r ],
        [0,   r*2, r ],
        [r*2, r*2, r ],
        [r*2, 0,   r ]
    ];
    translate([-r, -r,-h/2])
        polyRoundExtrude(radiiPoints,h,r1,r2,fn=$fn*2/3);
}

module roundedCube(w, l, h, r, rt, rb) {
    radiiPoints=[
        [0, 0, r ],
        [0, l, r ],
        [w, l, r ],
        [w, 0, r ]
    ];
    translate([-w/2, -l/2,-h/2])
        polyRoundExtrude(radiiPoints,h,rt,rb,fn=$fn*2/3);
}

module extrudeInsides(l, w, h, r, slope_radius_pct = 1) {
    radiiPoints=[
        [0, 0, (w/2-r)*slope_radius_pct+r],
        [0, h*2, 0 ],
        [w, h*2, 0 ],
        [w, 0, r ]
    ];
    rotate([90, 0, -90])
    translate([-w/2, -h/2,-l/2])
    difference() {        
        polyRoundExtrude(radiiPoints,l,r,r,fn=$fn*2/3);
        translate([0, l, 0]) cube([w+.1, h+.1, l+.1]);
    }
}

screwBox();

module screwBox() {
	echo("Number of dividers:",dividerCount);
    
    compartmentLen = (boxLen-boxThick*(dividerCount+2))/(dividerCount+1);
    
	difference() {
		// outerbox
		translate([0,0,boxHgt/2])
			cube([boxLen,boxWid,boxHgt],center=true);
		
            //translate([0,0,0.1+(boxHgt/2+boxThick/2)]) 
//            extrudeInsides(boxLen-boxThick*2, boxWid-boxThick*2, boxHgt-boxThick+0.1, radius, slope_radius_pct);
        
        	// dividers
            for (sep=[1:dividerCount+1]) {
                translate([(boxLen-compartmentLen)/2-boxThick-(sep-1)*(compartmentLen+boxThick),0,boxHgt/2])
                    extrudeInsides(compartmentLen, boxWid-boxThick*2, boxHgt-boxThick+0.1, radius, slope_radius_pct);
	}
          
	}
	// dividers
	//for (sep=[1:dividerCount]) {
	//	translate([(boxLen-boxThick)/2-sep*(boxLen-boxThick)/numSections,0,boxHgt/2])
	//		cube([boxThick,boxWid,boxHgt],center=true);
	//}
	// rim
	rotate([180,0,0])union() {
		translate([0,0,0-boxHgt])difference() {
			cube([boxLen+boxThick*2+0.8,boxWid+boxThick*2+0.8,boxThick*2],center=true);
			cube([boxLen,boxWid,boxThick*2+1],center=true);
			// extra cut out for stacking
			translate([0,0,0-boxThick/2-0.1])cube([boxLen+0.8,boxWid+0.8,boxThick],center=true);
			// 45 degree support for outer edge
			translate([0,boxWid/2+boxThick*1.05,boxThick*0.7071]) 
				rotate([45,0,0])cube([boxLen+boxThick*2+1,boxThick,boxThick*2],center=true);
			translate([0,0-(boxWid/2+boxThick*1.05),boxThick*0.7071]) 
				rotate([-45,0,0])cube([boxLen+boxThick*2+1,boxThick,boxThick*2],center=true);
			translate([boxLen/2+boxThick*1.05,0,boxThick*0.7071]) 
				rotate([0,-45,0])cube([boxThick,boxWid+boxThick*2+1,boxThick*2],center=true);
			translate([0-(boxLen/2+boxThick*1.05),0,boxThick*0.7071]) 
				rotate([0,45,0])cube([boxThick,boxWid+boxThick*2+1,boxThick*2],center=true);
		}
	}
}


