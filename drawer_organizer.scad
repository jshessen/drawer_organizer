/* [Global Parameters] */
test=true;
part = "connector_all"; // [connector_all:All Connectors,connector_zero:Zero Length Straight Connector,connector_straight:Straight Connector,connector_t:Edgy T-Connector,connector_t_round:Round T-Connector,connector_x:Edgy X-Connector,connector_x_round:Round X-Connector,connector_corner_edgy:Edgy Corner Connector,connector_corner:Corner Connector,connector_corner_round:Round Corner Connector,divider:Straight Divider,divider_lowered:Divider With Lowered Section,divider_bend_right:Divider With Right Bend, divider_bend_left:Divider With Left Bend,connector_all_border:All Border Connectors,connector_zero_border:Border Zero Length Straight Connector,connector_straight_border:Border Straight Connector,connector_t_border:Border Edgy T-Connector,connector_t_round_border:Border Round T-Connector,connector_corner_edgy_border:Border Edgy Corner Connector,connector_corner_border:Border Corner Connector,connector_corner_round_border:Border Round Corner Connector,divider_border:Border Divider Parts]

height = 50;
width_bottom = 12;
width_top = 5;
// size of connector pieces
connector_length = 18;
// use overhang for border pieces, in case your (side-) walls are not fully vertical
border_overhang = 13;
// adds a little bump on the connector, that locks pieces in the right position
snap_connection_size = 1;

/* [Divider Settings] */
divider_length = 72;
// radius for bending the bend divider relative to divider length
bend_radius_factor = 0.5;
// amount of displacement for bend dividers
bend_distance = 18;
// height of the lowered divider in the lowered section relative to total height
lowered_height = 0.5; // [0:0.01:1]
// radius for lowering the lowered divider on one side relative to divider length
lowered_radius1_factor = 0.4;
// radius for lowering the lowered divider on the other side relative to divider length
lowered_radius2_factor = 0.08;

/* [Tolerances] */
// Horizontal gap between parts
gap = 0.15;
// Vertical gap between parts
gap_top = 0.8;

$fa = 5;
$fs = 0.1;
// Space between dividers and connectors, when multiple pieces are in one .stl file
line_up_space = 40;

/* [Hidden] */
// derived variables
radius_bottom = width_bottom/2;
radius_top = width_top/2;
height_linear = height-radius_top;


if(test)
    test();
else
    parts(part);


module parts(part) {
    if (part == "connector_all") {
        line_up([0, line_up_space]) {
            connector_zero();
            connector_straight();
            connector_t(round=false);
            connector_t(round=true);
            connector_x(round=false);
            connector_x(round=true);
            connector_corner(round_outside=false, round_inside=false);
            connector_corner(round_outside=false, round_inside=true);
            connector_corner(round_outside=true, round_inside=true);        
        }
        translate([40,0,0]) line_up([0, line_up_space]) {
            //connector_zero();
            connector(0,width_bottom,width_top,height);            
            //connector_straight();
            connector(connector_length,width_bottom,width_top,height);
            connector_t(round=false);
            connector_t(round=true);
            //connector_x(round=false);
            connector(connector_length,width_bottom,width_top,height,connections=4);
            connector_x(round=true);
            connector_corner(round_outside=false, round_inside=false);
            connector_corner(round_outside=false, round_inside=true);
            connector_corner(round_outside=true, round_inside=true);
        }
    } else if (part == "connector_zero")
        connector_zero();
    else if (part == "connector_straight")
        connector_straight();
    else if (part == "connector_t")
        connector_t(round=false);
    else if (part == "connector_t_round")
        connector_t(round=true);
    else if (part == "connector_x")
        connector_x(round=false);
    else if (part == "connector_x_round")
        connector_x(round=true);
    else if (part == "connector_corner_edgy")
        connector_corner(round_outside=false, round_inside=false);
    else if (part == "connector_corner")
        connector_corner(round_outside=false, round_inside=true);
    else if (part == "connector_corner_round")
        connector_corner(round_outside=true, round_inside=true);
    else if (part == "divider")
        divider(divider_length,width_bottom,width_top,height);
    else if (part == "divider_lowered")
        divider_lowered(length=divider_length);
    else if (part == "divider_bend_right")
        divider_bend(length=divider_length, distance=-bend_distance);
    else if (part == "divider_bend_left")
        divider_bend(length=divider_length);
    else if (part == "connector_zero_border")
        connector_zero(border=true);
    else if (part == "connector_straight_border")
        connector_straight(border=true);
    else if (part == "connector_t_border")
        connector_t(round=false, border=true);
    else if (part == "connector_t_round_border")
        connector_t(round=true, border=true);
    else if (part == "connector_corner_edgy_border")
        connector_corner(round_outside=false, round_inside=false, border=true);
    else if (part == "connector_corner_border")
        connector_corner(round_outside=false, round_inside=true, border=true);
    else if (part == "connector_corner_round_border")
        connector_corner(round_outside=true, round_inside=true, border=true);
    else if (part == "connector_all_border") {
        line_up([line_up_space, 0]) {
            connector_zero(border=true);
            connector_straight(border=true);
            connector_t(round=false, border=true);
            connector_t(round=true, border=true);
            connector_corner(round_outside=false, round_inside=false, border=true);
            connector_corner(round_outside=false, round_inside=true, border=true);
            connector_corner(round_outside=true, round_inside=true, border=true);
        }
    } else if (part == "divider_border")
        divider(divider_length,width_bottom,width_top,height, border=true);
    else
        assert(false, "invalid part");
}

module line_up(space) {
   for (i = [0 : 1 : $children-1])
     translate([space[0]*i, space[1]*i, 0 ]) children(i);
}

// from thehans: http://forum.openscad.org/rotate-extrude-angle-always-360-tp19035p19040.html
module rotate_extrude2(angle=360, size=1000) {
    module angle_cut(angle,size=1000) {
        x = size*cos(angle/2);
        y = size*sin(angle/2);
        translate([0,0,-size])
            linear_extrude(2*size)
                polygon([[0,0],[x,y],[x,size],[-size,size],[-size,-size],[x,-size],[x,-y]]);
    }

    // support for angle parameter in rotate_extrude was added after release 2015.03
    // Thingiverse customizer is still on 2015.03
    angleSupport = (version_num() > 20150399) ? true : false; // Next OpenSCAD releases after 2015.03.xx will have support angle parameter
    // Using angle parameter when possible provides huge speed boost, avoids a difference operation

    if (angleSupport) {
        rotate_extrude(angle=angle)
        children();
    } else {
        non_negative_angle = angle >= 0 ? angle : 360 + angle;
        rotate([0,0,non_negative_angle/2]) difference() {
            rotate_extrude() children();
            angle_cut(angle, size);
        }
    }
}


module profile_shape(border=false) {
    skew = border_overhang;
    multmatrix(m=[
        [1,border?skew/height:0,0,border?-skew:0],
        [0,1,0,0],
        [0,0,1,0],
        [0,0,0,1]]) {
        polygon([
            [-radius_bottom, 0],
            [border ? radius_top : radius_bottom, 0],
            [radius_top, height_linear],
            [-radius_top, height_linear]
        ]);
        translate([0, height_linear])
            circle(r=radius_top);
    }
}

/*module profile(length=150, border=false) {
    rotate([90,0,0])
        linear_extrude(height=length)
            profile_shape(border=border);
}*/

module profile_round(radius, angle=90, border=false) {
    border_overhang = border ? border_overhang : 0;
    translate([-radius-border_overhang,0]) {
        rotate_extrude2(angle=angle) {
            translate([radius+border_overhang,0])
                profile_shape(border=border);
        }
    }
}

module profile_corner(round=false, border=false) {
    border_overhang = border ? border_overhang : 0;
    translate([0,0.5*connector_length,0])
        scale([-1,-1,1])
            profile_round(radius=0.5*connector_length, border=border);
    if (!round) {
        // add corner
        skew1 = border ? (radius_bottom-radius_top)/2 : 0;
        skew = skew1 + border_overhang;
        difference() {
            translate([0.5*connector_length+border_overhang,0.5*connector_length,0]) {
                scale([-1,-1,1]) {
                    size = 0.5*connector_length-skew1;
                    linear_extrude(height=height, scale=(size+skew)/size) {
                        square(size);
                    }
                }
            }
            radius_bottom2 = border ? (radius_bottom-radius_top)/2 : radius_bottom;
            translate([0.5*connector_length+border_overhang,0.5*connector_length,0]) {
                radius = 0.5*connector_length-skew1;
                linear_extrude(height=height, scale=(radius+skew)/radius) {
                    circle(r=radius);
                }
            }
        }
    }
}

/*module fitting(male=true, border=false) {
    // shrink male piece a little bit
    gap = male ? gap : 0;
    gap_top = male ? gap_top : 0;
    connector_length = radius_bottom;
    // For crazy people, that choose width_top > width_bottom. Otherwise pieces
    // cannot be stuck together. Such a design actually looks quite nice ;)
    radius_top = radius_top <= radius_bottom ? radius_top : radius_bottom;
    radius_top_gap = radius_top+(radius_bottom-radius_top)*gap_top/height_linear;
    skew = (radius_bottom-radius_top)/2 + border_overhang;
    radius_bottom = border ? (radius_top+radius_bottom)/2 : radius_bottom;
    // snap connection variables
    snap_height_factor = 0.2;
    snap_height = height_linear * snap_height_factor;
    snap_radius = 0.3 * (radius_bottom * (1-snap_height_factor) +
                         radius_top * snap_height_factor) +
                  snap_connection_size;
    multmatrix(m=[
        [1,0,border?skew/height:0,border?-skew:0],
        [0,1,0,0],
        [0,0,1,0],
        [0,0,0,1]]) {
        union() {
            linear_extrude(height=height_linear-gap_top, scale=radius_top_gap/radius_bottom) {
                polygon([
                    [-0.3*radius_bottom+gap, 0],
                    [0.3*radius_bottom-gap, 0],
                    [0.5*radius_bottom-gap, connector_length],
                    [-0.5*radius_bottom+gap, connector_length]
                ]);
                translate([0,connector_length]) {
                    circle(r=0.6*radius_bottom-gap);
                    // add "air channel" for female piece
                    if (!male)
                        translate([-0.1*radius_bottom,0])
                            square([0.2*radius_bottom, radius_bottom]);
                }
            }
            // snap connection
            if (snap_connection_size > 0)
                translate([0,0,snap_height])
                    rotate([-90,0,0])
                        cylinder(h=connector_length, r1=snap_radius - gap, r2=0.8*snap_radius - gap);
        }
    }
}*/

/*module divider(length=100, border=false) {
    difference() {
        //profile(length=length, border=border);
        profile(length,width_bottom,width_top,height, border=border);
        scale([1,-1,1])
            fitting(width_bottom,width_top,height, male=false, border=border);
            //fitting(male=false, border=border);
        translate([0,-length])
            fitting(width_bottom,width_top,height, male=false, border=border);
            //fitting(male=false, border=border);
    }
}*/

module divider_lowered(length=100, lower=lowered_height, radius1_factor=lowered_radius1_factor,
                       radius2_factor=lowered_radius2_factor) {
    radius1 = length*radius1_factor;
    radius2 = length*radius2_factor;
    assert(radius1 >= radius_top, "divider_lowered: radius1 must be greater than width_top/2!");
    assert(radius2 >= radius_top, "divider_lowered: radius2 must be greater than width_top/2!");

    height_lower = height_linear*lower;
    angle1 = height_lower > 2*radius1 ? 90 : acos(1-0.5*height_lower/radius1);
    length_round1 = sin(angle1)*radius1;
    height_round1 = (1-cos(angle1))*radius1;
    height_ortho1 = height_lower > 2*radius1 ? height_lower-2*radius1 : 0;
    angle2 = height_lower > 2*radius2 ? 90 : acos(1-0.5*height_lower/radius2);
    length_round2 = sin(angle2)*radius2;
    height_round2 = (1-cos(angle2))*radius2;
    height_ortho2 = height_lower > 2*radius2 ? height_lower-2*radius2 : 0;
    length_ortho = length - 2*(length_round1 + length_round2);
    assert(length_ortho >= 0, "divider_lowered: radius1+radius2 too big or length too small");

    module round_edge(radius, angle, length_round, height_round, height_ortho) {
        translate([0, 0, height_linear-radius])
            rotate([0,-90,180])
                rotate_extrude2(angle=angle)
                    translate([radius, 0])
                        circle(r=radius_top);
        if (height_ortho > 0) {
            translate([0, -length_round, height-height_lower+height_round-radius_top])
                linear_extrude(height_ortho)
                    circle(r=radius_top);
        }
        translate([0, -2*length_round, height-height_lower+radius-radius_top])
            rotate([0,90,0])
                rotate_extrude2(angle=angle)
                    translate([radius, 0])
                        circle(r=radius_top);
    }

    module spread() {
        angle = asin((radius_bottom - radius_top) / height_linear);
        z_correction = 1/cos(angle);
        translate([0, 0, height_linear])
            scale([1, 1, z_correction])
                rotate([0, angle, 0])
                    translate([0, 0, -height_linear])
                        children();
        translate([0, 0, height_linear])
            scale([1, 1, z_correction])
                rotate([0, -angle, 0])
                    translate([0, 0, -height_linear])
                        children();
    }

    module flat_profile(radius, length_round, height_round, height_ortho) {
        intersection() {
            translate([0, height-height_round-radius_top])
                square([length_round, height_round]);
            translate([0, height-radius-radius_top])
                circle(r=radius);
        }
        difference() {
            translate([length_round, height-height_lower-radius_top])
                square([length_round, height_round]);
            translate([2*length_round, height-height_lower-radius_top+radius]) {
                circle(r=radius);
            }
        }
        translate([0, height-height_lower-radius_top])
            square([length_round, height_round+height_ortho]);
    }

    module flat_cap(top=true) {
        max_radius = max(radius_top, radius_bottom);
        rotate([90,0,270]) {
            translate([0,0,-max_radius]) {
                linear_extrude(height=2*max_radius) {
                    offset(r=top?radius_top:0) {
                        union() {
                            square([length, height-height_lower-radius_top]);
                            flat_profile(radius1, length_round1, height_round1, height_ortho1);
                            translate([length, 0])
                                scale([-1, 1])
                                    flat_profile(radius2, length_round2, height_round2, height_ortho2);
                        }
                    }
                }
            }
        }
    }

    difference() {
        union() {
            // top round edge
            spread() {
                // radius1 round edge
                round_edge(radius1, angle1, length_round1, height_round1, height_ortho1);
                // center round edge
                if (length_ortho > 0) {
                    translate([0, -2*length_round1, height-height_lower-radius_top])
                        rotate([90, 0, 0])
                            linear_extrude(length_ortho)
                                circle(r=radius_top);
                }
                // radius2 round edge
                translate([0, -length, 0])
                    rotate([0,0,180])
                        round_edge(radius2, angle2, length_round2, height_round2, height_ortho2);
            }

            // flat top
            intersection() {
                flat_cap(top=true);
                rotate([90, 0, 0]) {
                    linear_extrude(height=length) {
                        polygon([
                            [-max(0,(radius_bottom-radius_top)), 0],
                            [max(0,(radius_bottom-radius_top)), 0],
                            [0, height]
                        ]);
                    }
                }
            }

            // body
            intersection() {
                //profile(length);
                profile(length,width_bottom,width_top,height, border=border);
                flat_cap(top=false);
            }
        }
        rotate([0,0,180])
            fitting(width_bottom,width_top,height, male=false);
            //fitting(male=false);
        translate([0,-length])
            fitting(width_bottom,width_top,height, male=false);
            //fitting(male=false);
    }
}

module divider_bend(length=100, distance=bend_distance, radius_factor=bend_radius_factor) {
    radius = length * radius_factor;
    // more helpful error message for rotate_extrude() error in profile_round()
    assert(radius >= radius_bottom, str("divider_bend: radius (", radius, ") too small, must be >= ", radius_bottom));
    angle = (abs(distance) >= 2*radius ? 90 : acos(1-0.5*abs(distance)/radius))*sign(distance);
    length_ortho = abs(distance) >= 2*radius ? abs(distance)-2*radius : 0;
    length_round = abs(distance) >= 2*radius ? radius : abs(sin(angle))*radius;
    length_start = 0.5*(length-2*length_round);
    assert(length >= 2*length_round, "divider_bend: length too short or radius too big");
    epsilon_angle = $fa * sign(angle);
    difference() {
        union() {
            // initial straight part and final straight part
            if (length_start > 0) {
                //profile(length_start);
                profile(length_start,width_bottom,width_top,height, border=border);
                translate([distance,length_start-length])
                    //profile(length_start);
                    profile(length_start,width_bottom,width_top,height, border=border);
            }
            // bend profile in one direction
            translate([0,-length_start])
                rotate([0,0,180])
                    profile_round(radius=radius*sign(angle), angle=angle);
            // bend profile in other direction
            translate([distance, length_start-length])
                profile_round(radius=radius*sign(angle), angle=angle);
            // straight middle part
            // In case the middle part is not needed, this is a tiny little glue piece
            // between the previous two parts. It fixes an issue with broken geometry, that
            // is caused by rounding errors. OpenSCAD does not like to union pieces, that
            // only touch. So far this is the only place where I experienced actual errors
            // when union exactly touching pieces.
            hull() {
                translate([0,-length_start])
                    rotate([0,0,180])
                        translate([-radius*sign(angle),0,0])
                            rotate([0,0,angle])
                                translate([radius*sign(angle),0,0])
                                    profile_round(radius=radius*sign(angle), angle=-epsilon_angle);
                translate([distance, length_start-length])
                    translate([-radius*sign(angle),0,0])
                        rotate([0,0,angle])
                            translate([radius*sign(angle),0,0])
                                profile_round(radius=radius*sign(angle), angle=-epsilon_angle);
            }
        }
        rotate([0,0,180])
            fitting(width_bottom,width_top,height, male=false);
            //fitting(male=false);
        translate([distance,-length])
            fitting(width_bottom,width_top,height, male=false);
            //fitting(male=false);
    }
}

module connector_zero(border=false) {
    union() {
        fitting(width_bottom,width_top,height, male=true, border=border);
        //fitting(male=true, border=border);
        scale([-1,1,1])
            fitting(width_bottom,width_top,height, male=true, border=border);
            //fitting(male=true, border=border);
    }
}

module connector_straight(border=false) {
    half_connector=connector_length/2;
    translate([0,half_connector,0]) {
        union() {
            //profile(length=connector_length, border=border);
            profile(connector_length,width_bottom,width_top,height, border=border);
            translate([-(half_connector),0,0])
                fitting(width_bottom,width_top,height, male=true, border=border);
            //fitting(male=true, border=border);
            translate([half_connector,0,0])
                scale([-1,1,1])
                    fitting(width_bottom,width_top,height, male=true, border=border);
                    //fitting(male=true, border=border);
        }
    }
}

module connector_x(round=true) {
    half_connector=connector_length/2;
    union() {
        for (r=[0, 90, 180, 270]) {
            rotate([0,0,r]) {
                translate([-(half_connector),0,0])
                    fitting(width_bottom,width_top,height, male=true);
                    //fitting(male=true);
                if (round) {
                    profile_corner();
                } else {
                    translate([-(half_connector/2),0,0])
                        //profile(0.5*connector_length);
                        profile(half_connector,width_bottom,width_top,height);
                }
            }
        }
    }
}

module connector_t_normal(round=true) {
    half_connector=connector_length/2;
    union() {
        for (r=[0, 90, 180]) {
            rotate([0,0,r])
                translate([-(half_connector),0,0])
                    fitting(width_bottom,width_top,height, male=true);
                    //fitting(male=true);
        }
        if (round) {
            for (r=[-90, 180]) {
                rotate([0,0,r])
                    profile_corner();
            }
        } else {
            translate([0,-(half_connector/2),0])
            rotate([0,0,90])
                //profile(0.5*connector_length);
                profile(half_connector,width_bottom,width_top,height);
        }
        //profile(connector_length);
        profile(connector_length,width_bottom,width_top,height);
    }
}

module connector_t_border(round=true) {
    connector_straight(border=true);
    rotate([0,0,90]) {
        translate([0,0.5*connector_length+border_overhang,0]) {
            fitting(width_bottom,width_top,height, male=true);
            //fitting(male=true);
            intersection() {
                //profile(connector_length+border_overhang);
                profile(connector_length+border_overhang,width_bottom,width_top,height);
                skew = border_overhang;
                max_radius = max(radius_top,radius_bottom);
                multmatrix(m=[
                    [1,0,0,-max_radius],
                    [0,1,-skew/height,-0.5*connector_length],
                    [0,0,1,0],
                    [0,0,0,1]]) {
                    cube([2*max_radius,connector_length+skew,height]);
                }
            }
        }
    }
    if (round) {
        skew = border_overhang;
        multmatrix(m=[
            [1,0,skew/height,-border_overhang],
            [0,1,0,0],
            [0,0,1,0],
            [0,0,0,1]]) {
            difference() {
                for (r=[90, 180]) {
                    rotate([0,0,r]) {
                        profile_corner(round=false, border=false);
                    }
                }
                translate([radius_top,-0.5*connector_length,0])
                    cube([radius_bottom,connector_length,height]);
            }
        }
    }
}

module connector_t(round=true, border=false) {
    if (border)
        connector_t_border(round=round);
    else
        connector_t_normal(round=round);
}

module connector_corner_normal(round_outside=true, round_inside=true) {
    border=false;
    half_connector=connector_length/2;
    union() {
        if (round_inside) {
            profile_corner(round=round_outside, border=border);
        }

        translate([-half_connector,0,0]) {
            fitting(width_bottom,width_top,height, male=true, border=border);
            //fitting(male=true, border=border);
            if (!round_outside)
                //profile(length=0.5*connector_length, border=border);
                translate([half_connector/2,0,0])
                    profile(half_connector,width_bottom,width_top,height, border=border);
        }
        
        translate([0,half_connector,0]) {
            rotate([0,0,270]) {
                fitting(width_bottom,width_top,height, male=true, border=border);
                //fitting(male=true, border=border);
                if (!round_outside)
                    //profile(length=0.5*connector_length, border=border);
                    translate([half_connector/2,0,0])
                        profile(half_connector,width_bottom,width_top,height, border=border);
            }
        }

        if (!round_outside) {
            rotate([0,0,180]) {
                rotate_extrude2(angle=90) {
                    intersection() {
                        profile_shape(border=border);
                        square([max(radius_bottom, radius_top), height]);
                    }
                }
            }
        }
    }
}

module connector_corner_border(round_outside=true, round_inside=true) {
    border = true;

    module side_wall() {
        intersection() {
            //profile(length=0.5*connector_length+border_overhang, border=border);
            profile(.5*connector_length+border_overhang,width_bottom,width_top,height, border=border);
            skew = border_overhang;
            translate([-(0.5*connector_length+border_overhang)+0.5*radius_bottom,0,0]) {
                scale([1,-1,1]) {
                    size = 0.5*connector_length;
                    linear_extrude(height=height, scale=(size+skew)/size) {
                        square(size);
                    }
                }
            }
        }
    }

    union() {
        if (round_inside) {
            profile_corner(round=round_outside, border=border);
        }

        scale([-1,1,1]) {
            translate([0,0.5*connector_length,0]) {
                fitting(width_bottom,width_top,height, male=true, border=border);
                //fitting(male=true, border=border);
                if (!round_outside) {
                    side_wall();
                }
            }
        }
        translate([0.5*connector_length+border_overhang,-border_overhang,0]) {
            rotate([0,0,270]) {
                fitting(width_bottom,width_top,height, male=true, border=border);
                //fitting(male=true, border=border);
                if (!round_outside) {
                    side_wall();
                }
            }
        }

        if (!round_outside) {
            skew = border_overhang;
            multmatrix(m=[
                [1,0,-skew/height,skew],
                [0,1,-skew/height,0],
                [0,0,1,0],
                [0,0,0,1]]) {
                rotate([0,0,180]) {
                    rotate_extrude2(angle=90) {
                        union() {
                            square([radius_top, height_linear]);
                            translate([0,height_linear]) {
                                intersection() {
                                    circle(r=radius_top);
                                    square(radius_top);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module connector_corner(round_outside=true, round_inside=true, border=false) {
    if (border)
        connector_corner_border(round_outside=round_outside, round_inside=round_inside);
    else
        connector_corner_normal(round_outside=round_outside, round_inside=round_inside);
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
module test(){
    h=height-(width_top/2);

    border=false;
    p=false;
    if(p){
        if(border){
            offset_border(h,border_overhang)
                profile(divider_length,width_bottom,width_top,height, border=border);
        } else {
            profile(divider_length,width_bottom,width_top,height);
        }
    } else {
        fitting(width_bottom,width_top,height);
    }
}
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/



/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
/*///////////////////////////////////////////////////////
// Module: connector()
//
    Description:
        Creates a "Connector" object

    Arguments:
        l      (undef) = The "length" distance on the X-axis
        b1     (undef) = The "width" of the "bottom" of the profile on Y-axis
        b2     (undef) = The "width" of the "top" of the profile on Y-axis
        h      (undef) = The "height" distance on the Z-axis
        border (undef) = Boolean used to create a right trapezoid
*/
/* Example: Make sample object
//   connector(connector_length,width_bottom,width_top,height,connections=3);
//   translate([40,0,0]) connector(0,width_bottom,width_top,height);
///////////////////////////////////////////////////////*/
module connector(l,b1,b2,h, connections, border=false){
    connections=(!is_undef(connections)) ? abs(connections) : 2;
    l=(!is_undef(l))? l
     :(connections==1)?0.4
     :0;
    r=(!is_undef(r))? r
     :(connections==1)? [0]
     :(connections==3)? split_angle(270,connections)
     :split_angle(360,connections);
    
    union() {
        for (r=r) {
            rotate([0,0,r]){
                if(l) translate([l/4,0,0])
                    profile(l/2,b1,b2,h, border=border);
                translate([l/2,0,0])
                   #fitting(b1,b2,h, male=true, border=border);
            }
        }
    }
}
/*///////////////////////////////////////////////////////
// Module: divider()
//
    Description:
        Creates a "Divider" object

    Arguments:
        l      (undef) = The "length" distance on the X-axis
        b1     (undef) = The "width" of the "bottom" of the profile on Y-axis
        b2     (undef) = The "width" of the "top" of the profile on Y-axis
        h      (undef) = The "height" distance on the Z-axis
        border (undef) = Boolean used to create a right trapezoid
*/
/* Example: Make sample object
//   divider(divider_length,width_bottom,width_top,height);
///////////////////////////////////////////////////////*/
module divider(l,b1,b2,h, border=false) {
    shear(h,border?border_overhang:0){
        difference() {
            profile(l,b1,b2,h, border=border);
            mirror_copy(){
                translate([-(l/2),0]){
                    fitting(b1,b2,h, female=true, border=border);
                }
            }
        }
    }
}
/*///////////////////////////////////////////////////////
// Module: profile()
//
    Description:
        Creates 3D profile object

    Arguments:
        l      (undef) = The "length" distance on the X-axis
        b1     (undef) = The "width" of the "bottom" of the profile on Y-axis
        b2     (undef) = The "width" of the "top" of the profile on Y-axis
        h      (undef) = The "height" distance on the Z-axis
        border (undef) = Boolean used to create a right trapezoid
*/
/* Example: Make sample object
//   profile(divider_length,width_bottom,width_top,height, border=border);
///////////////////////////////////////////////////////*/
module profile(l,b1,b2,h, border, center=true){
    border=(!is_undef(border))?border:false;
    r1=b1/2;
    r2=b2/2;
    r3=border?r2:r1;
    h=h-r2;
    
    b1_coord=[[-(r3),0], [r1,0]];
    b2_coord=[[-(r2),h], [r2,h]];
    points=concat([b1_coord], [b2_coord]);
    origin=(center)?[-(l/2),0,0] : [0,r3,0];
    // Build 3D Polygon
    translate(origin) rotate([90,0,90])
        linear_extrude(l)
    profile_2d(points);
}
/*///////////////////////////////////////////////////////
// Module: profile_2d()
//
    Description:
        Creates 2D profile object

    Arguments:
        points (undef)  = Vector containing the trapezoidal coordinates
        r      (r2)     = radius of circle incorporated into top of profile
*/
/* Example: Make sample object
//   profile_2d(points);
///////////////////////////////////////////////////////*/
module profile_2d(points, r){
    h=get_height(get_second(get_top(points)));
    r=(!is_undef(r))
        ? r
        : abs(get_radius(get_second(get_top(points))));
    
    // Build 2D Polygon
    polygon(concat(get_bottom(points), get_top(points)),[[0,1,3,2]]);
    translate([0,h])
        circle(r=r, $fn=360);
}
/*///////////////////////////////////////////////////////
// Module: fitting()
//
    Description:
        Creates 3D profile object

    Arguments:
        b1     (undef) = The "width" of the "bottom" of the fitting on X-axis
        b2     (undef) = The "width" of the "top" of the profile on X-axis
        h      (undef) = The "height" distance on the Z-axis
        male   (true)  = Apply Male/Female characteristics to object
        female (undef) = Apply Male/Female characteristics to object
        border (undef) = Boolean used to create a right trapezoid
*/
/* Example: Make sample object
//   fitting(width_bottom,width_top,height);
///////////////////////////////////////////////////////*/
module fitting(b1,b2,h, male, female, border=false, center=false){
    male=(!is_undef(male))?male:((!is_undef(female))?!female:true);
    // Offset value to eliminate coplanar face conflict
    coplanar=0.0075;
    
    // shrink male piece a little bit
    gap = male ? gap : 0;
    gap_top = male ? gap_top : 0;
    

    // For crazy people, that choose width_top > width_bottom. Otherwise pieces
    // cannot be stuck together. Such a design actually looks quite nice ;)
    r2 = b2 <= b1 ? b2/2 : b1/2;
    h=h-r2;
    r1 = border ? (r2+(b1/2)/2) : b1/2;
    r2_gap = r2+(r1-r2)*gap_top/h;
    r3=0.6*r1;
    
    bottom=(0.3*r1);
    top=(0.5*r1);
    b1_coord=[[-(bottom),0], [bottom,0]];
    b2_coord=[[-(top),r1], [top,r1]];
    points=concat([b1_coord], [b2_coord]);
    origin=(center)?[-((r1+r3)/2+coplanar),0,-(h/2+coplanar)]
                   :[-(coplanar),0,-(coplanar)];
    
    /* Build 3D Polygon */
    shear(h,border?(r1-r2)/2:0){
        translate(origin){
            rotate([0,0,-90]){
                union(){
                    linear_extrude(height=h-gap_top, scale=r2_gap/r1){
                        translate([0,-(gap),0]) offset(delta=-(gap)){
                            profile_2d(points,r=r3);
                            // add "air channel" for female piece
                            if (!male)
                                translate([-0.1*r1,r1])
                                    square([0.2*r1, (r1)]);
                        }
                    }
                        snap_height_factor = 0.2;
                        snap_height = h * snap_height_factor;
                    if (snap_connection_size > 0){
                        translate([0,0,snap_height])
                            snap_fit(r1,r2);
                    }
                }
            }
        }
    }
}
/*///////////////////////////////////////////////////////
// Module: snap_fit()
//
    Description:
        Creates a snap joint which can be incororated into a fitting to lock pieces into the correct position

    Arguments:
        r1     (undef) = The "width" of the "bottom" of the profile on X-axis
        r2     (undef) = The "width" of the "top" of the profile on X-axis
//
///////////////////////////////////////////////////////*/
module snap_fit(r1,r2){
    // snap connection variables
    snap_height_factor = 0.2;
    snap_r = (r1 * (1-snap_height_factor) + r2 * snap_height_factor);
    snap_small_r = 0.3*snap_r;
    snap_radius = snap_small_r + snap_connection_size;
    
    rotate([-90,0,0])
        cylinder(h=r1, r1=snap_radius - gap, r2=0.8*snap_radius - gap, $fn=360);
}
/*///////////////////////////////////////////////////////
// Module: shear()
//
    Description:
        Shear/Skew object

    Arguments:
        h       (undef) = The "height" distance on the Z-axis
        shear   (undef) = The "shear" distance on the Y-axis
//
///////////////////////////////////////////////////////*/
module shear(h, shear){
    // Shear Value (Shear Y along Z)
    m=[[1,0,0,0],
       [0,1,-(shear/h),shear],
       [0,0,1,0],
       [0,0,0,1]];
    multmatrix(m) children();
}
/*///////////////////////////////////////////////////////
// Module: mirror_copy()
//
    Description:
        A custom mirror module that retains the original
        object in addition to the mirrored one.
    https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Create_a_mirrored_object_while_retaining_the_original
//
///////////////////////////////////////////////////////*/
module mirror_copy(v = [1, 0, 0]) {
    children();
    mirror(v) children();
}





/*#################################################################
## Section: Functions
*/
/*#######################################################
## Function: split_angle()
##
    Description:
        Build an vector of equadistant angles
    Arguments:
        a (360)   = Angle to be segmented
        n (undef) = Number of segments
        r ([])    = Return vector
*/
/* Example: Make sample object
##  echo(split_angle(360,4);
#######################################################*/
function split_angle(a=360,n,r=[]) =
    a==0 ? r : split_angle(a-(a/n),n-1,concat([a-(a/n)],r));
/*#######################################################
## Function: get_radius() = get_bottom() = get_x() = get_first() = vector[0]
##
    Description:
        Given an array of length >0, return the first element
    Arguments:
        vector = Array of vertices.
##
#######################################################*/
function get_first(vector)  = vector[0];
function get_x(vector)      = get_first(vector);
function get_bottom(vector) = get_first(vector);
function get_radius(vector) = get_first(vector);
/*#######################################################
## Function: get_height() = get_top() = get_y() = get_second() = vector[1]
##
    Description:
        Given an array of length >1, return the first element
    Arguments:
        vector = Array of vertices.
##
#######################################################*/
function get_second(vector) = vector[1];
function get_y(vector)      = get_second(vector);
function get_top(vector) = get_second(vector);
function get_height(vector) = get_second(vector);
/*#######################################################
## Function: get_z() = get_last() = vector[len(vector)-1]
##
    Description:
        Given an array of length >2, return the first element
    Arguments:
        vector = Array of vertices.
##
#######################################################*/
function get_last(vector) = vector[len(vector)-1];
function get_z(vector) = get_last(vector);
/*#######################################################
## Function: distance()
##
    Description:
        Given an array of length >2, return the first element
    Arguments:
        vector = Array of vertices.
##
#######################################################*/
function distance(vector) = sqrt(pow((get_x(get_first(vector))-get_x(get_second(vector))),2)
                               + pow((get_y(get_first(vector))-get_y(get_second(vector))),2)
                               + pow((get_z(get_first(vector))-get_z(get_second(vector))),2));