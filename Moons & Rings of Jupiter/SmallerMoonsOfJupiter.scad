/***** MODEL OF SMALLER MOONS OF JUPITER *****/

//+++++++++++++++++++++++++++++ Jupiter +++++++++++++++++++++++++++++//
R = 40;
LAT = $preview ? 70 : 170;
LON = $preview ? 140 : 340;

DARK       = [0.24,0.16,0.10];
DARK_B     = [0.32,0.20,0.12];
BROWN      = [0.45,0.27,0.16];
RED_BROWN  = [0.56,0.30,0.15];
OCHRE      = [0.67,0.40,0.20];
TAN        = [0.70,0.54,0.40];
CREAM      = [0.84,0.77,0.66];
LIGHT      = [0.91,0.86,0.77];
WHITE      = [0.975,0.955,0.90];
BLUE_WHITE = [0.79,0.84,0.84];
POLAR_GRAY = [0.53,0.57,0.55];
POLAR_DARK = [0.30,0.28,0.25];
RED_DARK   = [0.40,0.075,0.025];
RED_MID    = [0.64,0.16,0.045];
RED        = [0.78,0.25,0.065];
RED_LIGHT  = [0.91,0.40,0.13];

function clamp01(x) = max(0,min(1,x));

function smooth01(x) =
    let(q=clamp01(x))
    q*q*(3-2*q);

function mix_color(a,b,t) =
    let(q=clamp01(t))
    [
        a[0]+(b[0]-a[0])*q,
        a[1]+(b[1]-a[1])*q,
        a[2]+(b[2]-a[2])*q
    ];

function wrap_lon(x) =
    x > 180 ? x-360 :
    x < -180 ? x+360 :
    x;

function noise_large(lat,lon) =
      0.42*sin(lon*1.25+lat*0.80)
    + 0.27*cos(lon*2.70-lat*1.10)
    + 0.16*sin(lon*5.20+lat*2.20)
    + 0.10*cos(lon*8.70-lat*3.40)
    + 0.06*sin(lon*14.0+lat*4.70);

function noise_medium(lat,lon) =
      0.42*sin(lon*4.10+lat*2.00)
    + 0.27*cos(lon*8.70-lat*3.70)
    + 0.17*sin(lon*15.0+lat*5.20)
    + 0.09*cos(lon*27.0-lat*8.00);

function noise_fine(lat,lon) =
      0.38*sin(lon*12.0+lat*5.0)
    + 0.26*cos(lon*23.0-lat*8.0)
    + 0.18*sin(lon*39.0+lat*13.0)
    + 0.10*cos(lon*67.0-lat*21.0);

function wind_wave(lon,phase) =
      3.2*sin(lon*1.35+phase)
    + 2.0*sin(lon*2.70-phase*0.70)
    + 1.15*sin(lon*5.20+phase*1.40)
    + 0.55*sin(lon*9.70-phase*1.90);

function ribbon(lat,lon,center,width,amplitude,frequency,phase) =
    let(
        shifted_center =
            center
            + amplitude*sin(lon*frequency+phase)
            + wind_wave(lon,phase)*0.35,
        distance = lat-shifted_center
    )
    exp(-pow(distance/width,2));

function dark_belts(lat,lon) =
      ribbon(lat,lon,-35,2.0,2.7,1.05,0.4)*0.95
    + ribbon(lat,lon,-30,1.7,2.1,1.35,2.1)*0.70
    + ribbon(lat,lon,-26,2.2,3.5,0.82,4.2)*0.90
    + ribbon(lat,lon,-20,2.7,4.2,0.92,1.4)*0.72
    + ribbon(lat,lon,-15,1.4,2.5,1.20,3.7)*1.00
    + ribbon(lat,lon,-11,2.8,3.0,0.75,5.1)*0.70
    + ribbon(lat,lon,-5,3.4,4.4,0.67,2.4)*0.45
    + ribbon(lat,lon,3,3.0,3.7,0.82,4.9)*0.80
    + ribbon(lat,lon,9,1.6,2.7,1.13,1.2)*0.75
    + ribbon(lat,lon,14,2.7,3.8,0.88,3.8)*0.80
    + ribbon(lat,lon,20,1.7,2.5,1.25,5.2)*0.90
    + ribbon(lat,lon,25,2.3,3.0,0.90,2.2)*0.75
    + ribbon(lat,lon,30,1.8,2.4,1.20,4.5)*0.90
    + ribbon(lat,lon,35,2.2,2.8,0.83,1.0)*0.70;

function bright_belts(lat,lon) =
      ribbon(lat,lon,-33,2.0,2.9,1.05,1.0)
    + ribbon(lat,lon,-23,2.4,3.8,0.82,4.8)
    + ribbon(lat,lon,-17,1.8,3.2,1.00,2.3)
    + ribbon(lat,lon,-8,2.0,3.8,0.74,5.0)
    + ribbon(lat,lon,7,2.1,3.6,0.83,2.0)
    + ribbon(lat,lon,15,2.0,3.4,0.91,4.3)
    + ribbon(lat,lon,24,2.2,3.7,0.91,4.3)
    + ribbon(lat,lon,28,2.0,3.1,1.08,1.2)
    + ribbon(lat,lon,34,1.8,2.6,0.87,5.4);

function dark_filaments(lat,lon) =
      ribbon(lat,lon,-31,0.38,4.5,1.50,1.0)
    + ribbon(lat,lon,-28,0.32,3.5,1.90,3.0)
    + ribbon(lat,lon,-21,0.42,4.0,1.60,4.0)
    + ribbon(lat,lon,-18,0.30,3.0,2.10,0.8)
    + ribbon(lat,lon,-13,0.38,3.7,1.80,2.6)
    + ribbon(lat,lon,-4,0.42,4.5,1.30,5.0)
    + ribbon(lat,lon,1,0.34,3.2,1.90,2.0)
    + ribbon(lat,lon,11,0.40,4.0,1.70,4.7)
    + ribbon(lat,lon,16,0.34,3.4,1.90,1.1)
    + ribbon(lat,lon,23,0.42,4.2,1.45,3.4)
    + ribbon(lat,lon,28,0.32,3.0,1.80,5.2)
    + ribbon(lat,lon,34,0.35,3.7,1.55,0.5);

function bright_filaments(lat,lon) =
      ribbon(lat,lon,-34,0.32,4.0,1.30,3.2)
    + ribbon(lat,lon,-24,0.30,4.4,1.70,0.7)
    + ribbon(lat,lon,-19,0.35,3.6,1.40,4.1)
    + ribbon(lat,lon,-9,0.30,4.1,1.80,1.5)
    + ribbon(lat,lon,6,0.32,3.9,1.60,3.9)
    + ribbon(lat,lon,15,0.31,4.2,1.45,0.3)
    + ribbon(lat,lon,24,0.34,3.7,1.70,2.7)
    + ribbon(lat,lon,33,0.30,3.8,1.35,5.0);

function polar_distance(lat) = 90-abs(lat);

function polar_blend(lat) =
    let(p=polar_distance(lat))
    smooth01((52-p)/16);

function polar_warp(lon,p,phase) =
      3.2*sin(lon+phase)
    + 1.9*sin(lon*2.0-phase*1.7)
    + 1.15*sin(lon*3.0+p*0.7+phase)
    + 0.75*sin(lon*5.0-p*1.2)
    + 0.40*sin(lon*9.0+p*2.0)
    + 0.20*sin(lon*17.0-p*3.0);

function polar_micro(lon,p) =
      0.75*sin(lon*11.0+p*3.0)
    + 0.48*sin(lon*19.0-p*4.5)
    + 0.32*sin(lon*31.0+p*7.0)
    + 0.19*sin(lon*47.0-p*10.0)
    + 0.10*sin(lon*71.0+p*15.0);

function polar_ring(lat,lon,radius,width,phase,strength) =
    let(
        p=polar_distance(lat),
        center =
            radius
            + polar_warp(lon,p,phase)*strength
            + polar_micro(lon,p)*0.35,
        distance=p-center,
        varying_width =
            width*
            (
                0.72
                + 0.28*
                (
                    0.5
                    + 0.5*sin(lon*3.0+phase)
                )
            )
    )
    exp(-pow(distance/varying_width,2));

function polar_break(lon,phase) =
    let(
        n =
              0.45*sin(lon+phase)
            + 0.30*sin(lon*2.0-phase*1.3)
            + 0.20*sin(lon*4.0+phase*2.2)
            + 0.12*sin(lon*7.0-phase)
    )
    0.20+0.80*smooth01((n+0.08)/0.35);

function broken_polar_ring(lat,lon,radius,width,phase,strength) =
    polar_ring(lat,lon,radius,width,phase,strength)
    * polar_break(lon,phase);

function polar_band_1(lat,lon) =
    broken_polar_ring(lat,lon,8.0,2.7,0.8,0.85);

function polar_band_2(lat,lon) =
    broken_polar_ring(lat,lon,13.0,2.0,2.4,0.72);

function polar_band_3(lat,lon) =
    broken_polar_ring(lat,lon,17.5,3.1,4.1,0.95);

function polar_band_4(lat,lon) =
    broken_polar_ring(lat,lon,22.5,2.6,1.5,0.80);

function polar_band_5(lat,lon) =
    broken_polar_ring(lat,lon,27.5,3.5,5.0,1.05);

function polar_band_6(lat,lon) =
    broken_polar_ring(lat,lon,33.0,2.8,2.7,0.90);

function polar_band_7(lat,lon) =
    broken_polar_ring(lat,lon,38.0,4.0,0.7,1.05);

function polar_band_8(lat,lon) =
    broken_polar_ring(lat,lon,43.0,3.3,3.8,1.12);

function polar_band_9(lat,lon) =
    broken_polar_ring(lat,lon,47.5,3.0,5.4,0.90);

function polar_filament(lat,lon,radius,width,frequency,phase,strength) =
    let(
        p=polar_distance(lat),
        center =
            radius
            + polar_warp(lon,p,phase)*0.65
            + 1.1*sin(lon*frequency+p*3.0+phase),
        distance=p-center
    )
    exp(-pow(distance/width,2))*strength;

function polar_filament_field(lat,lon) =
      polar_filament(lat,lon,10.5,0.38,5.0,0.4,0.75)
    + polar_filament(lat,lon,12.5,0.32,7.0,2.0,0.60)
    + polar_filament(lat,lon,16.0,0.40,6.0,4.0,0.72)
    + polar_filament(lat,lon,18.5,0.30,9.0,1.0,0.58)
    + polar_filament(lat,lon,21.0,0.38,8.0,3.2,0.70)
    + polar_filament(lat,lon,24.0,0.32,11.0,5.0,0.62)
    + polar_filament(lat,lon,26.5,0.42,7.0,1.7,0.74)
    + polar_filament(lat,lon,29.5,0.31,13.0,4.3,0.60)
    + polar_filament(lat,lon,32.5,0.40,9.0,0.6,0.72)
    + polar_filament(lat,lon,35.0,0.30,15.0,2.8,0.55)
    + polar_filament(lat,lon,38.5,0.44,8.0,4.9,0.72)
    + polar_filament(lat,lon,42.0,0.34,12.0,1.4,0.60)
    + polar_filament(lat,lon,45.5,0.38,17.0,3.5,0.56);

function polar_crossflow(lat,lon) =
    let(
        p=polar_distance(lat),
        a =
            sin(
                lon*3.0
                +p*7.0
                +2*sin(lon*2.0)
            ),
        b =
            sin(
                lon*6.0
                -p*4.0
                +sin(lon*5.0)
            ),
        c=sin(lon*13.0+p*9.0),
        d=sin(lon*23.0-p*15.0)
    )
      a*0.45
    + b*0.28
    + c*0.17
    + d*0.10;

function polar_vortex(lat,lon,radius,angle,size,strength) =
    let(
        p=polar_distance(lat),
        delta_lon=wrap_lon(lon-angle),
        x=delta_lon*cos(radius),
        y=p-radius,
        distance=sqrt(x*x+y*y)
    )
    exp(-pow(distance/size,2))*strength;

function polar_vortices(lat,lon) =
      polar_vortex(lat,lon,10,20,1.3,0.55)
    + polar_vortex(lat,lon,11,92,1.2,0.48)
    + polar_vortex(lat,lon,12,178,1.4,0.62)
    + polar_vortex(lat,lon,13,267,1.3,0.52)
    + polar_vortex(lat,lon,14,340,1.2,0.48)
    + polar_vortex(lat,lon,17,48,1.4,0.55)
    + polar_vortex(lat,lon,18,133,1.3,0.60)
    + polar_vortex(lat,lon,19,220,1.5,0.48)
    + polar_vortex(lat,lon,20,306,1.3,0.57)
    + polar_vortex(lat,lon,23,12,1.5,0.52)
    + polar_vortex(lat,lon,24,78,1.2,0.50)
    + polar_vortex(lat,lon,25,157,1.4,0.58)
    + polar_vortex(lat,lon,26,239,1.5,0.53)
    + polar_vortex(lat,lon,27,321,1.3,0.56)
    + polar_vortex(lat,lon,30,35,1.6,0.48)
    + polar_vortex(lat,lon,31,109,1.4,0.56)
    + polar_vortex(lat,lon,32,188,1.5,0.50)
    + polar_vortex(lat,lon,33,274,1.4,0.55)
    + polar_vortex(lat,lon,37,63,1.7,0.50)
    + polar_vortex(lat,lon,39,151,1.5,0.53)
    + polar_vortex(lat,lon,40,247,1.7,0.48)
    + polar_vortex(lat,lon,42,334,1.6,0.52);

function polar_color(lat,lon) =
    let(
        p=polar_distance(lat),
        b1=polar_band_1(lat,lon),
        b2=polar_band_2(lat,lon),
        b3=polar_band_3(lat,lon),
        b4=polar_band_4(lat,lon),
        b5=polar_band_5(lat,lon),
        b6=polar_band_6(lat,lon),
        b7=polar_band_7(lat,lon),
        b8=polar_band_8(lat,lon),
        b9=polar_band_9(lat,lon),
        fil=polar_filament_field(lat,lon),
        cross=polar_crossflow(lat,lon),
        vort=polar_vortices(lat,lon),
        c0=[0.82,0.84,0.80],
        cap=smooth01((9-p)/6),
        c1=mix_color(c0,[0.62,0.67,0.65],cap*0.65),
        c2=mix_color(c1,[0.34,0.31,0.27],b1*0.75),
        c3=mix_color(c2,[0.72,0.82,0.84],b2*0.72),
        c4=mix_color(c3,[0.48,0.34,0.24],b3*0.76),
        c5=mix_color(c4,[0.90,0.91,0.87],b4*0.68),
        c6=mix_color(c5,[0.35,0.32,0.28],b5*0.67),
        c7=mix_color(c6,[0.77,0.81,0.79],b6*0.65),
        c8=mix_color(c7,[0.58,0.35,0.20],b7*0.78),
        c9=mix_color(c8,[0.80,0.86,0.87],b8*0.67),
        c10=mix_color(c9,[0.62,0.48,0.36],b9*0.35),
        dark_fil=smooth01((fil-0.15)/0.55),
        c11=mix_color(c10,[0.28,0.25,0.22],dark_fil*0.27),
        light_fil=smooth01((-fil+0.15)/0.55),
        c12=mix_color(c11,[0.94,0.94,0.89],light_fil*0.22),
        cross_dark=smooth01((-cross+0.10)/0.60),
        c13=mix_color(c12,[0.42,0.31,0.23],cross_dark*0.18),
        c14=mix_color(c13,[0.62,0.47,0.35],clamp01(vort)*0.20),
        mottling =
              0.42*sin(lon*23+p*8)
            + 0.30*cos(lon*37-p*11)
            + 0.18*sin(lon*59+p*17)
            + 0.10*cos(lon*91-p*23),
        c15 =
            mix_color(
                c14,
                [0.74,0.68,0.59],
                smooth01((-mottling+0.20)/0.75)*0.12
            )
    )
    c15;

function storm(lat,lon,center_lat,center_lon,lat_size,lon_size) =
    let(
        dx=wrap_lon(lon-center_lon),
        dy=lat-center_lat,
        distance=sqrt(pow(dy/lat_size,2)+pow(dx/lon_size,2))
    )
    smooth01(1-distance);

function storm_field(lat,lon) =
      storm(lat,lon,32,-80,1.5,3.5)*0.40
    + storm(lat,lon,28,55,1.2,3.0)*0.32
    + storm(lat,lon,17,-130,1.4,3.8)*0.35
    + storm(lat,lon,12,105,1.2,3.2)*0.30
    + storm(lat,lon,-8,-100,1.3,3.4)*0.28
    + storm(lat,lon,-14,70,1.4,3.6)*0.30
    + storm(lat,lon,-28,-55,1.3,3.0)*0.34
    + storm(lat,lon,-34,120,1.5,3.8)*0.32;

function spot_distance(lat,lon) =
    let(
        dx=wrap_lon(lon+20),
        dy=lat+22,
        x=dx/18.0,
        y=dy/7.8
    )
    sqrt(x*x+y*y);

function spot_mask(lat,lon) =
    smooth01(1-spot_distance(lat,lon));

function spot_texture(lat,lon) =
      0.42
    + 0.23*sin(lon*8.0+lat*12.0)
    + 0.17*cos(lon*17.0-lat*9.0)
    + 0.10*sin(lon*29.0+lat*21.0)
    + 0.08*cos(lon*47.0-lat*32.0);

function apply_red_spot(lat,lon,base) =
    let(
        mask=spot_mask(lat,lon),
        texture=clamp01(spot_texture(lat,lon)),
        red_color=mix_color(RED_DARK,RED_LIGHT,texture)
    )
    mix_color(base,red_color,mask*0.88);

function jupiter_color(lat,lon) =
    let(
        dark=clamp01(dark_belts(lat,lon)*0.58),
        bright=clamp01(bright_belts(lat,lon)*0.52),
        dark_f=clamp01(dark_filaments(lat,lon)*0.52),
        bright_f=clamp01(bright_filaments(lat,lon)*0.38),
        large=noise_large(lat,lon),
        medium=noise_medium(lat,lon),
        fine=noise_fine(lat,lon),
        c0=mix_color(CREAM,BROWN,dark),
        warm=clamp01(dark*0.65+(-large)*0.12),
        c1=mix_color(c0,OCHRE,warm*0.35),
        c2=mix_color(c1,DARK,dark_f*0.42),
        c3=mix_color(c2,LIGHT,bright*0.42),
        c4=mix_color(c3,WHITE,bright_f*0.52),
        c5=mix_color(c4,TAN,clamp01((-medium+0.5)*0.11)),
        c6=mix_color(c5,WHITE,smooth01((fine-0.40)/0.60)*0.13),
        storms=storm_field(lat,lon),
        c7=mix_color(c6,[0.53,0.34,0.22],clamp01(storms)*0.18),
        pc=polar_color(lat,lon),
        pb=polar_blend(lat),
        c8=mix_color(c7,pc,pb)
    )
    apply_red_spot(lat,lon,c8);

function sphere_point(r,lat,lon) =
[
    r*cos(lat)*cos(lon),
    r*cos(lat)*sin(lon),
    r*sin(lat)
];

module patch(lat1,lat2,lon1,lon2)
{
    lat=(lat1+lat2)/2;
    lon=(lon1+lon2)/2;
    color(jupiter_color(lat,lon))
    polyhedron(
        points=[
            sphere_point(R,lat1,lon1),
            sphere_point(R,lat1,lon2),
            sphere_point(R,lat2,lon2),
            sphere_point(R,lat2,lon1)
        ],
        faces=[
            [0,1,2,3]
        ],
        convexity=2
    );
}

module jupiter()
{
    for(i=[0:LAT-1])
    {
        lat1=-90+180*i/LAT;
        lat2=-90+180*(i+1)/LAT;
        for(j=[0:LON-1])
        {
            lon1=-180+360*j/LON;
            lon2=-180+360*(j+1)/LON;
            patch(lat1,lat2,lon1,lon2);
        }
    }
}

jupiter();
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//


/***********************************************/
// Themisto 
color([173/255, 216/255, 230/255])  
translate([73.9, 0, 0]) 
{
    sphere(r = 2, $fn = 100);  
}
translate([73.9 + 4.5, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Themisto", size = 2, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfThemisto = 0.25;  
heightOfOrbitOfThemisto = 0.2;     
fn_Themisto = 180;          
module orbitOfThemisto(radius, fn_Themisto, thicknessOfOrbitOfThemisto, heightOfOrbitOfThemisto) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Themisto;
    angle_step = 360 / fn_Themisto;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfThemisto], center = true);
    }
}
rotate([0,0,0]){
orbitOfThemisto(73.9, fn_Themisto, thicknessOfOrbitOfThemisto, heightOfOrbitOfThemisto);
}
/***********************************************/

/***********************************************/
// Leda
color([255/255, 223/255, 186/255])  
translate([111.4, 0, 0]) 
{
    sphere(r = 2, $fn = 100);  
}
translate([111.4 + 2.5, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Leda", size = 1, valign = "center", halign = "center");  
}}
thicknessOfOrbitOfLeda = 0.25;  
heightOfOrbitOfLeda = 0.2;     
fn_Leda = 180;          

module orbitOfLeda(radius, fn_Leda, thicknessOfOrbitOfLeda, heightOfOrbitOfLeda) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Leda;
    angle_step = 360 / fn_Leda;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfLeda], center = true);
    }
}

rotate([5,0,0]){
    orbitOfLeda(111.4, fn_Leda, thicknessOfOrbitOfLeda, heightOfOrbitOfLeda);
}
/***********************************************/

/***********************************************/
// Ersa
color([200/255, 200/255, 200/255])  
rotate([0,10,0]){
translate([114, 0, 10]) {
    sphere(r = 1.2, $fn = 100);  
}}
translate([114 + 2, 0, -10]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Ersa", size = 1, valign = "center", halign = "center");  
}}
thicknessOfOrbitOfErsa = 0.1;  
heightOfOrbitOfErsa = 0.01;     
fn_Ersa = 180;          

module orbitOfErsa(radius, fn_Ersa, thicknessOfOrbitOfErsa, heightOfOrbitOfErsa) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Ersa;
    angle_step = 360 / fn_Ersa;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfErsa], center = true);
    }
}

rotate([0,5,0]){
    orbitOfErsa(114+0.5, fn_Ersa, thicknessOfOrbitOfErsa, heightOfOrbitOfErsa);
}
/***********************************************/

/***********************************************/
// Himalia
color([216/255,191/255,216/255])  
translate([114.4, 10, -20]) 
{
    sphere(r = 7, $fn = 100);  
}
translate([114.4 + 8.5, 10, -20]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Himalia", size = 1.5, valign = "center", halign = "center");  
}}
thicknessOfOrbitOfHimalia = 0.25;  
heightOfOrbitOfHimalia = 0.2;     
fn_Himalia = 180;          

module orbitOfHimalia(radius, fn_Himalia, thicknessOfOrbitOfHimalia, heightOfOrbitOfHimalia) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Himalia;
    angle_step = 360 / fn_Himalia;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfHimalia], center = true);
    }
}

rotate([0,10,0]){
    orbitOfHimalia(114.4, fn_Himalia, thicknessOfOrbitOfHimalia, heightOfOrbitOfHimalia);
}
/***********************************************/

/***********************************************/
// Pandia
color([220/255, 220/255, 220/255])  
translate([114.8, 10, 0]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([114.8 + 2, 10, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Pandia", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfPandia = 0.25;  
heightOfOrbitOfPandia = 0.2;     
fn_Pandia = 180;          
module orbitOfPandia(radius, fn_Pandia, thicknessOfOrbitOfPandia, heightOfOrbitOfPandia) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Pandia;
    angle_step = 360 / fn_Pandia;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfPandia], center = true);
    }
}

rotate([0,0,0]){
    orbitOfPandia(114.8, fn_Pandia, thicknessOfOrbitOfPandia, heightOfOrbitOfPandia);
}
/***********************************************/

/***********************************************/
// Lysithea
color([143/255,188/255,143/255])  
translate([117, 0, 20]) // Shifting to a new octant (z shifted)
{
    sphere(r = 4, $fn = 100);  
}
translate([117 + 6, 0, 20]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Lysithea", size = 2, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfLysithea = 0.25;  
heightOfOrbitOfLysithea = 0.2;     
fn_Lysithea = 180;          

module orbitOfLysithea(radius, fn_Lysithea, thicknessOfOrbitOfLysithea, heightOfOrbitOfLysithea) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Lysithea;
    angle_step = 360 / fn_Lysithea;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfLysithea], center = true);
    }
}
rotate([0,-10,0]){
    orbitOfLysithea(117, fn_Lysithea, thicknessOfOrbitOfLysithea, heightOfOrbitOfLysithea);
}

/***********************************************/
// Elara
color([192/255, 192/255, 192/255])  
translate([-117.12, 0, 0]) 
{
    sphere(r = 3, $fn = 100);  
}
translate([-(117.12 + 4.2), 0, 0]) {
    rotate([0, 0, 90]) {  
    color([1,1,1])  
    text("Elara", size = 2, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfElara = 0.25;  
heightOfOrbitOfElara = 0.2;     
fn_Elara = 180;          

module orbitOfElara(radius, fn_Elara, thicknessOfOrbitOfElara, heightOfOrbitOfElara) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Elara;
    angle_step = 360 / fn_Elara;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfElara], center = true);
    }
}

rotate([10,0,0]){
    orbitOfElara(117.12, fn_Elara, thicknessOfOrbitOfElara, heightOfOrbitOfElara);
}
/***********************************************/

/***********************************************/
// Dia
color([205/255, 133/255, 63/255])  
translate([-122.6, 10, 0]) 
{
    sphere(r = 1.5, $fn = 100);  
}
translate([-(122.6 + 3), 10, 0]) {
    rotate([0, 0, 90]) {  
    color([1,1,1])  
    text("Dia", size = 2, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfDia = 0.25;  
heightOfOrbitOfDia = 0.2;     
fn_Dia = 180;          

module orbitOfDia(radius, fn_Dia, thicknessOfOrbitOfDia, heightOfOrbitOfDia) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Dia;
    angle_step = 360 / fn_Dia;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfDia], center = true);
    }
}

rotate([0,0,0]){
    orbitOfDia(122.6, fn_Dia, thicknessOfOrbitOfDia, heightOfOrbitOfDia);
}
/***********************************************/

/***********************************************/
// S/2018 J 4
color([180/255, 180/255, 180/255])  
translate([163.2, 0, 0]) 
{
    sphere(r = 1, $fn = 100);  
}
translate([163.2 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("S/2018 J 4", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2018J4 = 0.25;  
heightOfOrbitOfS2018J4 = 0.2;     
fn_S2018J4 = 180;          
module orbitOfS2018J4(radius, fn_S2018J4, thicknessOfOrbitOfS2018J4, heightOfOrbitOfS2018J4) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2018J4;
    angle_step = 360 / fn_S2018J4;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2018J4], center = true);
    }
}

rotate([0,0,0]){
    orbitOfS2018J4(163.2, fn_S2018J4, thicknessOfOrbitOfS2018J4, heightOfOrbitOfS2018J4);
}
/***********************************************/

/***********************************************/
// Carpo
color([169/255, 169/255, 169/255])  
translate([170.4, 0, 0]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([170.4 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Carpo", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfCarpo = 0.25;  
heightOfOrbitOfCarpo = 0.2;     
fn_Carpo = 180;          
module orbitOfCarpo(radius, fn_Carpo, thicknessOfOrbitOfCarpo, heightOfOrbitOfCarpo) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Carpo;
    angle_step = 360 / fn_Carpo;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfCarpo], center = true);
    }
}

rotate([10,0,0]){
    orbitOfCarpo(170.4, fn_Carpo, thicknessOfOrbitOfCarpo, heightOfOrbitOfCarpo);
}
/***********************************************/

/***********************************************/
// Valetudo
color([160/255, 160/255, 160/255])  
translate([186.9, 0, 0]) 
{
    sphere(r = 0.8, $fn = 100);  
}
translate([186.9 + 1.5, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Valetudo", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfValetudo = 0.25;  
heightOfOrbitOfValetudo = 0.2;     
fn_Valetudo = 180;          
module orbitOfValetudo(radius, fn_Valetudo, thicknessOfOrbitOfValetudo, heightOfOrbitOfValetudo) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Valetudo;
    angle_step = 360 / fn_Valetudo;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfValetudo], center = true);
    }
}

rotate([15,0,0]){
    orbitOfValetudo(186.9, fn_Valetudo, thicknessOfOrbitOfValetudo, heightOfOrbitOfValetudo);
}
/***********************************************/

/***********************************************/
// Euporie
color([192/255, 192/255, 192/255])  
translate([192.6, 0, 0]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([192.6 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Euporie", size = 1, valign = "center", halign = "center");  
}}
thicknessOfOrbitOfEuporie = 0.25;  
heightOfOrbitOfEuporie = 0.02;     
fn_Euporie = 180;          

module orbitOfEuporie(radius, fn_Euporie, thicknessOfOrbitOfEuporie, heightOfOrbitOfEuporie) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Euporie;
    angle_step = 360 / fn_Euporie;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfEuporie], center = true);
    }
}
rotate([20,0,0]){
    orbitOfEuporie(192.6, fn_Euporie, thicknessOfOrbitOfEuporie, heightOfOrbitOfEuporie);
}
/***********************************************/

/***********************************************/
// S/2003 J 18
color([245/255,222/255,179/255])  
translate([203.3, 0, 0]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([203.3 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("S/2003 J 18", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2003J18 = 0.25;  
heightOfOrbitOfS2003J18 = 0.2;     
fn_S2003J18 = 180;          
module orbitOfS2003J18(radius, fn_S2003J18, thicknessOfOrbitOfS2003J18, heightOfOrbitOfS2003J18) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2003J18;
    angle_step = 360 / fn_S2003J18;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2003J18], center = true);
    }
}
rotate([0,0,0]){
    orbitOfS2003J18(203.3, fn_S2003J18, thicknessOfOrbitOfS2003J18, heightOfOrbitOfS2003J18);
}
/***********************************************/

/***********************************************/
// Eupheme
color([188/255,143/255,143/255])  
translate([207.6, 0, 0]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([207.6 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Eupheme", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfEupheme = 0.25;  
heightOfOrbitOfEupheme = 0.2;     
fn_Eupheme = 180;          
module orbitOfEupheme(radius, fn_Eupheme, thicknessOfOrbitOfEupheme, heightOfOrbitOfEupheme) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Eupheme;
    angle_step = 360 / fn_Eupheme;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfEupheme], center = true);
    }
}
rotate([10,0,0]){
    orbitOfEupheme(207.6, fn_Eupheme, thicknessOfOrbitOfEupheme, heightOfOrbitOfEupheme);
}
/***********************************************/

/***********************************************/
// S/2021 J 3
color([255/255,228/255,225/255])  
translate([-207.7, 10, -2]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([-(207.7 + 2), 10, -2]) {
    rotate([0, 0, 90]) {  
    color([1,1,1])  
    text("S/2021 J 3", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2021J3 = 0.25;  
heightOfOrbitOfS2021J3 = 0.2;     
fn_S2021J3 = 180;          
module orbitOfS2021J3(radius, fn_S2021J3, thicknessOfOrbitOfS2021J3, heightOfOrbitOfS2021J3) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2021J3;
    angle_step = 360 / fn_S2021J3;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2021J3], center = true);
    }
}

rotate([-10,0,0]){
    orbitOfS2021J3(207.7, fn_S2021J3, thicknessOfOrbitOfS2021J3, heightOfOrbitOfS2021J3);
}
/***********************************************/

/***********************************************/
// S/2010 J 2
color([255/255, 182/255, 193/255])  
translate([-207.9, 10, 4.5]) 
{
    sphere(r = 0.8, $fn = 100);  
}
translate([-(207.9 + 2), 10, 4.5]) {
    rotate([0, 0, 90]) {  
    color([1,1,1])  
    text("S/2010 J 2", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2010J2 = 0.25;  
heightOfOrbitOfS2010J2 = 0.2;     
fn_S2010J2 = 180;          
module orbitOfS2010J2(radius, fn_S2010J2, thicknessOfOrbitOfS2010J2, heightOfOrbitOfS2010J2) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2010J2;
    angle_step = 360 / fn_S2010J2;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2010J2], center = true);
    }
}

rotate([25,0,0]){
    orbitOfS2010J2(207.9, fn_S2010J2, thicknessOfOrbitOfS2010J2, heightOfOrbitOfS2010J2);
}
/***********************************************/

/***********************************************/
// S/2016 J 1
color([0.7, 0.9, 1])  
translate([208, 10, 0]) 
{
    sphere(r = 0.8, $fn = 100);  
}
translate([208 + 2, 10, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("S/2016 J 1", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2016J1 = 0.25;  
heightOfOrbitOfS2016J1 = 0.2;     
fn_S2016J1 = 180;          

module orbitOfS2016J1(radius, fn_S2016J1, thicknessOfOrbitOfS2016J1, heightOfOrbitOfS2016J1) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2016J1;
    angle_step = 360 / fn_S2016J1;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2016J1], center = true);
    }
}

rotate([30,1.5,0]){
    orbitOfS2016J1(208, fn_S2016J1, thicknessOfOrbitOfS2016J1, heightOfOrbitOfS2016J1);
}
/***********************************************/

/***********************************************/
// Mneme
color([222/255,184/255,135/255])  
translate([-208.2, 10, -6]) 
{
    sphere(r = 1.2, $fn = 100);  
}
translate([-208.2 - 2, 10, -6]) {
    rotate([0, 0, 90]) {  
    color([1,1,1])  
    text("Mneme", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfMneme = 0.25;  
heightOfOrbitOfMneme = 0.2;     
fn_Mneme = 180;          
module orbitOfMneme(radius, fn_Mneme, thicknessOfOrbitOfMneme, heightOfOrbitOfMneme) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Mneme;
    angle_step = 360 / fn_Mneme;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfMneme], center = true);
    }
}

rotate([-30,0,0]){
    orbitOfMneme(208.2, fn_Mneme, thicknessOfOrbitOfMneme, heightOfOrbitOfMneme);
}
/***********************************************/

/***********************************************/
// Euanthe
color([0.8, 0.8, 0.6])  
translate([208.2, 0, 0]) { 
    rotate([0, 0, 90]) {
        sphere(r = 1.4, $fn = 100);  
    }
}
translate([208.2 + 2, 0, 0]) {
    rotate([0, 0, -90]) {  
    color([1,1,1])  
    text("Euanthe", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfEuanthe = 0.25;  
heightOfOrbitOfEuanthe = 0.2;     
fn_Euanthe = 180;          
module orbitOfEuanthe(radius, fn_Euanthe, thicknessOfOrbitOfEuanthe, heightOfOrbitOfEuanthe) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Euanthe;
    angle_step = 360 / fn_Euanthe;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfEuanthe], center = true);
    }
}

rotate([0,90,0]){
    orbitOfEuanthe(208.2, fn_Euanthe, thicknessOfOrbitOfEuanthe, heightOfOrbitOfEuanthe);
}
/***********************************************/

/***********************************************/
// S/2003 J 16
color([0.7, 0.6, 0.5])  
translate([0, 208.8, 0]) { 
    rotate([0, 0, 135]) {  
        sphere(r = 1.2, $fn = 100);  
    }
}
translate([0, 208.8 + 2, 0]) {
    rotate([180, 0, 180]) {  
    color([1,1,1])  
    text("S/2003 J 16", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfS2003J16 = 0.25;  
heightOfOrbitOfS2003J16 = 0.2;     
fn_S2003J16 = 180;          
module orbitOfS2003J16(radius, fn_S2003J16, thicknessOfOrbitOfS2003J16, heightOfOrbitOfS2003J16) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_S2003J16;
    angle_step = 360 / fn_S2003J16;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfS2003J16], center = true);
    }
}

rotate([0,0,0]){
    orbitOfS2003J16(208.8, fn_S2003J16, thicknessOfOrbitOfS2003J16, heightOfOrbitOfS2003J16);
}
/***********************************************/

/***********************************************/
// Harpalyke
color([0.9, 0.6, 0.4])  
translate([0, 0, 208.9]) {  
    rotate([0, 0, 180]) {  
        sphere(r = 1.8, $fn = 100);  
    }
}
translate([0, 0, 208.9 + 3]) {
    rotate([90, 0, 0]) {  
        color([1,1,1])  
        text("Harpalyke", size = 1, valign = "center", halign = "center");  
}}

thicknessOfOrbitOfHarpalyke = 0.25;  
heightOfOrbitOfHarpalyke = 0.2;     
fn_Harpalyke = 180;          
module orbitOfHarpalyke(radius, fn_Harpalyke, thicknessOfOrbitOfHarpalyke, heightOfOrbitOfHarpalyke) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Harpalyke;
    angle_step = 360 / fn_Harpalyke;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfHarpalyke], center = true);
    }
}
rotate([90,0,0]){
    orbitOfHarpalyke(208.9, fn_Harpalyke, thicknessOfOrbitOfHarpalyke, heightOfOrbitOfHarpalyke);
}
/***********************************************/

/***********************************************/
// Orthosie
color([0.6, 0.8, 1])  
translate([0, 0, 209]) {  
    sphere(r = 1.2, $fn = 100);  
}

translate([0, 0, 209 + 2]) {  // Move label to the right of the moon
    color([1, 1, 1])  
    text("Orthosie", size = 1, valign = "center", halign = "center");  
}

thicknessOfOrbitOfOrthosie = 0.25;  
heightOfOrbitOfOrthosie = 0.2;     
fn_Orthosie = 180;          

module orbitOfOrthosie(radius, fn_Orthosie, thicknessOfOrbitOfOrthosie, heightOfOrbitOfOrthosie) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Orthosie;
    angle_step = 360 / fn_Orthosie;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate(i)
            translate([0, radius, 0]) 
                square([length, thicknessOfOrbitOfOrthosie], center = true);
    }
}

rotate([0,90,0]){
    orbitOfOrthosie(209, fn_Orthosie, thicknessOfOrbitOfOrthosie, heightOfOrbitOfOrthosie);
}
/***********************************************/

/***********************************************/
// Helike
color([0.7, 0.7, 1])  
translate([-209.1, 0, 20]) {  
    sphere(r = 1.8, $fn = 100);  
}
translate([-209.1-4.5, 0, 20]) {
    color([1, 1, 1])  
    text("Helike", size = 1, valign = "center", halign = "center");  
}
thicknessOfOrbitOfHelike = 0.25;  
heightOfOrbitOfHelike = 0.2;     
fn_Helike = 180;          
inclinationOfHelike = 154.4; 
module orbitOfHelike(radius, fn_Helike, thicknessOfOrbitOfHelike, heightOfOrbitOfHelike, inclinationOfHelike) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    length = circumference / fn_Helike;
    angle_step = 360 / fn_Helike;
    for(i = [0 : angle_step : 360 - angle_step]) {
        rotate([inclinationOfHelike, 0, 0]) 
            rotate(i)
                translate([0, radius, 0]) 
                    square([length, thicknessOfOrbitOfHelike], center = true);
    }
}
rotate([inclinationOfHelike, 0, 0]) {
    }
    rotate([225, 90, 109]) { 
        orbitOfHelike(209.1, fn_Helike, thicknessOfOrbitOfHelike, heightOfOrbitOfHelike, inclinationOfHelike); 
    }

/***********************************************/

