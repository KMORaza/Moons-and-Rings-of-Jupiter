// ********* Detailed model of Jupiter ********* //

// ---- global parameters ----
R   = 40;
LAT = $preview ? 70 : 170;
LON = $preview ? 140 : 340;
FN  = $preview ? 16 : 32;

AXIAL_TILT = 3.13; // degrees

// ---- feature toggles ----
show_rotation_axis    = true;
show_equatorial_plane = true;
show_ecliptic_plane   = true;
show_rotation_arrow   = true;
show_magnetic_field   = true;
show_magnetosphere    = true;
show_plasma_torus     = true;
show_radiation_belts  = true;
show_aurorae_3d       = true;
show_roche_limit      = true;
show_tidal_lines      = true;
show_moons            = true;
show_rings            = true;
show_moon_axes        = true;
show_orbit_paths      = true;
resonance_mode        = true;   // Laplace 4:2:1 animation

// ---- stylised orbital radii ----
ORBIT_IO       = 80;
ORBIT_EUROPA   = 110;
ORBIT_GANYMEDE = 150;
ORBIT_CALLISTO = 200;

R_IO       = 3.5;
R_EUROPA   = 3.0;
R_GANYMEDE = 5.0;
R_CALLISTO = 4.5;


// COLOUR CONSTANTS  
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


// UTILITY FUNCTIONS  (unchanged)
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


// NOISE / BELT / FILAMENT FUNCTIONS 
function noise_large(lat,lon) =
  0.42*sin(lon*1.25+lat*0.80)
  +0.27*cos(lon*2.70-lat*1.10)
  +0.16*sin(lon*5.20+lat*2.20)
  +0.10*cos(lon*8.70-lat*3.40)
  +0.06*sin(lon*14.0+lat*4.70);
function noise_medium(lat,lon) =
  0.42*sin(lon*4.10+lat*2.00)
  +0.27*cos(lon*8.70-lat*3.70)
  +0.17*sin(lon*15.0+lat*5.20)
  +0.09*cos(lon*27.0-lat*8.00);
function noise_fine(lat,lon) =
  0.38*sin(lon*12.0+lat*5.0)
  +0.26*cos(lon*23.0-lat*8.0)
  +0.18*sin(lon*39.0+lat*13.0)
  +0.10*cos(lon*67.0-lat*21.0);
function wind_wave(lon,phase) =
  3.2*sin(lon*1.35+phase)
  +2.0*sin(lon*2.70-phase*0.70)
  +1.15*sin(lon*5.20+phase*1.40)
  +0.55*sin(lon*9.70-phase*1.90);
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
  +ribbon(lat,lon,-30,1.7,2.1,1.35,2.1)*0.70
  +ribbon(lat,lon,-26,2.2,3.5,0.82,4.2)*0.90
  +ribbon(lat,lon,-20,2.7,4.2,0.92,1.4)*0.72
  +ribbon(lat,lon,-15,1.4,2.5,1.20,3.7)*1.00
  +ribbon(lat,lon,-11,2.8,3.0,0.75,5.1)*0.70
  +ribbon(lat,lon,-5,3.4,4.4,0.67,2.4)*0.45
  +ribbon(lat,lon,3,3.0,3.7,0.82,4.9)*0.80
  +ribbon(lat,lon,9,1.6,2.7,1.13,1.2)*0.75
  +ribbon(lat,lon,14,2.7,3.8,0.88,3.8)*0.80
  +ribbon(lat,lon,20,1.7,2.5,1.25,5.2)*0.90
  +ribbon(lat,lon,25,2.3,3.0,0.90,2.2)*0.75
  +ribbon(lat,lon,30,1.8,2.4,1.20,4.5)*0.90
  +ribbon(lat,lon,35,2.2,2.8,0.83,1.0)*0.70;
function bright_belts(lat,lon) =
  ribbon(lat,lon,-33,2.0,2.9,1.05,1.0)
  +ribbon(lat,lon,-23,2.4,3.8,0.82,4.8)
  +ribbon(lat,lon,-17,1.8,3.2,1.00,2.3)
  +ribbon(lat,lon,-8,2.0,3.8,0.74,5.0)
  +ribbon(lat,lon,7,2.1,3.6,0.83,2.0)
  +ribbon(lat,lon,15,2.0,3.4,0.91,4.3)
  +ribbon(lat,lon,24,2.2,3.7,0.91,4.3)
  +ribbon(lat,lon,28,2.0,3.1,1.08,1.2)
  +ribbon(lat,lon,34,1.8,2.6,0.87,5.4);
function dark_filaments(lat,lon) =
  ribbon(lat,lon,-31,0.38,4.5,1.50,1.0)
  +ribbon(lat,lon,-28,0.32,3.5,1.90,3.0)
  +ribbon(lat,lon,-21,0.42,4.0,1.60,4.0)
  +ribbon(lat,lon,-18,0.30,3.0,2.10,0.8)
  +ribbon(lat,lon,-13,0.38,3.7,1.80,2.6)
  +ribbon(lat,lon,-4,0.42,4.5,1.30,5.0)
  +ribbon(lat,lon,1,0.34,3.2,1.90,2.0)
  +ribbon(lat,lon,11,0.40,4.0,1.70,4.7)
  +ribbon(lat,lon,16,0.34,3.4,1.90,1.1)
  +ribbon(lat,lon,23,0.42,4.2,1.45,3.4)
  +ribbon(lat,lon,28,0.32,3.0,1.80,5.2)
  +ribbon(lat,lon,34,0.35,3.7,1.55,0.5);
function bright_filaments(lat,lon) =
  ribbon(lat,lon,-34,0.32,4.0,1.30,3.2)
  +ribbon(lat,lon,-24,0.30,4.4,1.70,0.7)
  +ribbon(lat,lon,-19,0.35,3.6,1.40,4.1)
  +ribbon(lat,lon,-9,0.30,4.1,1.80,1.5)
  +ribbon(lat,lon,6,0.32,3.9,1.60,3.9)
  +ribbon(lat,lon,15,0.31,4.2,1.45,0.3)
  +ribbon(lat,lon,24,0.34,3.7,1.70,2.7)
  +ribbon(lat,lon,33,0.30,3.8,1.35,5.0);


// POLAR FUNCTIONS 
function polar_distance(lat) = 90-abs(lat);
function polar_blend(lat) =
  let(p=polar_distance(lat))
  smooth01((52-p)/16);
function polar_warp(lon,p,phase) =
  3.2*sin(lon+phase)
  +1.9*sin(lon*2.0-phase*1.7)
  +1.15*sin(lon*3.0+p*0.7+phase)
  +0.75*sin(lon*5.0-p*1.2)
  +0.40*sin(lon*9.0+p*2.0)
  +0.20*sin(lon*17.0-p*3.0);
function polar_micro(lon,p) =
  0.75*sin(lon*11.0+p*3.0)
  +0.48*sin(lon*19.0-p*4.5)
  +0.32*sin(lon*31.0+p*7.0)
  +0.19*sin(lon*47.0-p*10.0)
  +0.10*sin(lon*71.0+p*15.0);
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
      +0.30*sin(lon*2.0-phase*1.3)
      +0.20*sin(lon*4.0+phase*2.2)
      +0.12*sin(lon*7.0-phase)
  )
  0.20+0.80*smooth01((n+0.08)/0.35);
function broken_polar_ring(lat,lon,radius,width,phase,strength) =
  polar_ring(lat,lon,radius,width,phase,strength)
  * polar_break(lon,phase);

function polar_band_1(lat,lon) = broken_polar_ring(lat,lon,8.0,2.7,0.8,0.85);
function polar_band_2(lat,lon) = broken_polar_ring(lat,lon,13.0,2.0,2.4,0.72);
function polar_band_3(lat,lon) = broken_polar_ring(lat,lon,17.5,3.1,4.1,0.95);
function polar_band_4(lat,lon) = broken_polar_ring(lat,lon,22.5,2.6,1.5,0.80);
function polar_band_5(lat,lon) = broken_polar_ring(lat,lon,27.5,3.5,5.0,1.05);
function polar_band_6(lat,lon) = broken_polar_ring(lat,lon,33.0,2.8,2.7,0.90);
function polar_band_7(lat,lon) = broken_polar_ring(lat,lon,38.0,4.0,0.7,1.05);
function polar_band_8(lat,lon) = broken_polar_ring(lat,lon,43.0,3.3,3.8,1.12);
function polar_band_9(lat,lon) = broken_polar_ring(lat,lon,47.5,3.0,5.4,0.90);

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
  +polar_filament(lat,lon,12.5,0.32,7.0,2.0,0.60)
  +polar_filament(lat,lon,16.0,0.40,6.0,4.0,0.72)
  +polar_filament(lat,lon,18.5,0.30,9.0,1.0,0.58)
  +polar_filament(lat,lon,21.0,0.38,8.0,3.2,0.70)
  +polar_filament(lat,lon,24.0,0.32,11.0,5.0,0.62)
  +polar_filament(lat,lon,26.5,0.42,7.0,1.7,0.74)
  +polar_filament(lat,lon,29.5,0.31,13.0,4.3,0.60)
  +polar_filament(lat,lon,32.5,0.40,9.0,0.6,0.72)
  +polar_filament(lat,lon,35.0,0.30,15.0,2.8,0.55)
  +polar_filament(lat,lon,38.5,0.44,8.0,4.9,0.72)
  +polar_filament(lat,lon,42.0,0.34,12.0,1.4,0.60)
  +polar_filament(lat,lon,45.5,0.38,17.0,3.5,0.56);
function polar_crossflow(lat,lon) =
  let(
    p=polar_distance(lat),
    a=sin(lon*3.0+p*7.0+2*sin(lon*2.0)),
    b=sin(lon*6.0-p*4.0+sin(lon*5.0)),
    c=sin(lon*13.0+p*9.0),
    d=sin(lon*23.0-p*15.0)
  )
  a*0.45+b*0.28+c*0.17+d*0.10;
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
  +polar_vortex(lat,lon,11,92,1.2,0.48)
  +polar_vortex(lat,lon,12,178,1.4,0.62)
  +polar_vortex(lat,lon,13,267,1.3,0.52)
  +polar_vortex(lat,lon,14,340,1.2,0.48)
  +polar_vortex(lat,lon,17,48,1.4,0.55)
  +polar_vortex(lat,lon,18,133,1.3,0.60)
  +polar_vortex(lat,lon,19,220,1.5,0.48)
  +polar_vortex(lat,lon,20,306,1.3,0.57)
  +polar_vortex(lat,lon,23,12,1.5,0.52)
  +polar_vortex(lat,lon,24,78,1.2,0.50)
  +polar_vortex(lat,lon,25,157,1.4,0.58)
  +polar_vortex(lat,lon,26,239,1.5,0.53)
  +polar_vortex(lat,lon,27,321,1.3,0.56)
  +polar_vortex(lat,lon,30,35,1.6,0.48)
  +polar_vortex(lat,lon,31,109,1.4,0.56)
  +polar_vortex(lat,lon,32,188,1.5,0.50)
  +polar_vortex(lat,lon,33,274,1.4,0.55)
  +polar_vortex(lat,lon,37,63,1.7,0.50)
  +polar_vortex(lat,lon,39,151,1.5,0.53)
  +polar_vortex(lat,lon,40,247,1.7,0.48)
  +polar_vortex(lat,lon,42,334,1.6,0.52);


// POLAR FUNCTIONS
// Auroral oval  (~15-20° from pole)
function auroral_oval(lat,lon) =
  let(
    p    = polar_distance(lat),
    ctr  = 17,
    w    = 4.0,
    warp = 2.5*sin(lon*3.0+1.2)
           + 1.5*sin(lon*5.0-0.8)
           + 0.8*sin(lon*8.0+2.5)
  )
  exp(-pow((p-ctr-warp)/w, 2));

// Auroral red edge  (just outside main oval)
function auroral_edge(lat,lon) =
  let(
    p    = polar_distance(lat),
    ctr  = 22,
    w    = 2.5,
    warp = 2.0*sin(lon*3.0+1.5)
           + 1.2*sin(lon*7.0-1.0)
  )
  exp(-pow((p-ctr-warp)/w, 2));

// Subtle emission bands inside auroral zone
function auroral_bands(lat,lon) =
  let(
    p = polar_distance(lat),
    b = 0.5*sin(p*2.5+lon*4.0)
        + 0.3*sin(p*4.0-lon*6.0+1.0)
  )
  smooth01((b+0.3)/0.6) * smooth01((25-p)/10) * smooth01((p-8)/6);

// Central polar cyclone  (dark spot at pole centre)
function central_cyclone(lat,lon) =
  let(p=polar_distance(lat))
  exp(-pow(p/2.8, 2));

// Spiral arms near poles
function spiral_arms(lat,lon) =
  let(
    p  = polar_distance(lat),
    s1 = sin(lon*3.0 - p*2.5) * exp(-p/18.0),
    s2 = sin(lon*5.0 + p*1.8 - 1.5) * exp(-p/14.0)
  )
  (smooth01((s1+0.3)/0.6)*0.6 + smooth01((s2+0.3)/0.6)*0.4)
  * smooth01((35-p)/20);

// High-frequency polar turbulence
function polar_turbulence(lat,lon) =
  let(p=polar_distance(lat))
  (
    0.35*sin(lon*29.0+p*17.0)
    +0.28*cos(lon*43.0-p*23.0)
    +0.20*sin(lon*67.0+p*31.0)
    +0.12*cos(lon*97.0-p*41.0)
    +0.05*sin(lon*131.0+p*53.0)
  ) * smooth01((30-p)/18);

// North/South asymmetric circumpolar cyclones
// North: 8 cyclones at ~10° from pole
// South: 5 cyclones at ~10° from pole
function ns_cyclones(lat,lon) =
  let(
    n = lat > 0 ? 1 : 0,
    s = lat > 0 ? 0 : 1,
    n1=n*polar_vortex(lat,lon,10,  0,1.3,0.50),
    n2=n*polar_vortex(lat,lon,10, 45,1.3,0.50),
    n3=n*polar_vortex(lat,lon,10, 90,1.3,0.50),
    n4=n*polar_vortex(lat,lon,10,135,1.3,0.50),
    n5=n*polar_vortex(lat,lon,10,180,1.3,0.50),
    n6=n*polar_vortex(lat,lon,10,225,1.3,0.50),
    n7=n*polar_vortex(lat,lon,10,270,1.3,0.50),
    n8=n*polar_vortex(lat,lon,10,315,1.3,0.50),
    s1=s*polar_vortex(lat,lon,10,  0,1.5,0.55),
    s2=s*polar_vortex(lat,lon,10, 72,1.5,0.55),
    s3=s*polar_vortex(lat,lon,10,144,1.5,0.55),
    s4=s*polar_vortex(lat,lon,10,216,1.5,0.55),
    s5=s*polar_vortex(lat,lon,10,288,1.5,0.55)
  )
  n1+n2+n3+n4+n5+n6+n7+n8+s1+s2+s3+s4+s5;

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
      +0.30*cos(lon*37-p*11)
      +0.18*sin(lon*59+p*17)
      +0.10*cos(lon*91-p*23),
    c15 = mix_color(
            c14,
            [0.74,0.68,0.59],
            smooth01((-mottling+0.20)/0.75)*0.12
          ),

    // --- central polar cyclone (dark cap) ---
    cc = central_cyclone(lat,lon),
    c16 = mix_color(c15,[0.18,0.16,0.14],cc*0.50),

    // --- spiral arms ---
    sp = spiral_arms(lat,lon),
    c17 = mix_color(c16,[0.58,0.52,0.44],sp*0.18),

    // --- polar turbulence ---
    turb = polar_turbulence(lat,lon),
    c18 = mix_color(c17,[0.36,0.30,0.24],smooth01((turb+0.2)/0.6)*0.14),

    // --- N/S asymmetric circumpolar cyclones ---
    nsc = ns_cyclones(lat,lon),
    c19 = mix_color(c18,[0.25,0.22,0.18],clamp01(nsc)*0.22),

    // --- auroral oval (blue-green glow) ---
    ao = auroral_oval(lat,lon),
    c20 = mix_color(c19,[0.15,0.62,0.52],ao*0.55),

    // --- auroral red edge ---
    ae = auroral_edge(lat,lon),
    c21 = mix_color(c20,[0.78,0.12,0.06],ae*0.45),

    // --- subtle emission bands ---
    ab = auroral_bands(lat,lon),
    c22 = mix_color(c21,[0.30,0.75,0.60],ab*0.20),

    // --- N/S brightness asymmetry (south slightly dimmer) ---
    ns_dim = lat < 0 ? 0.08 : 0.0,
    c23 = mix_color(c22,[c22[0]*0.85,c22[1]*0.85,c22[2]*0.85],ns_dim)
  )
  c23;


// STORM / SPOT FUNCTIONS 
function storm(lat,lon,center_lat,center_lon,lat_size,lon_size) =
  let(
    dx=wrap_lon(lon-center_lon),
    dy=lat-center_lat,
    distance=sqrt(pow(dy/lat_size,2)+pow(dx/lon_size,2))
  )
  smooth01(1-distance);
function storm_field(lat,lon) =
  storm(lat,lon,32,-80,1.5,3.5)*0.40
  +storm(lat,lon,28,55,1.2,3.0)*0.32
  +storm(lat,lon,17,-130,1.4,3.8)*0.35
  +storm(lat,lon,12,105,1.2,3.2)*0.30
  +storm(lat,lon,-8,-100,1.3,3.4)*0.28
  +storm(lat,lon,-14,70,1.4,3.6)*0.30
  +storm(lat,lon,-28,-55,1.3,3.0)*0.34
  +storm(lat,lon,-34,120,1.5,3.8)*0.32;
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
  +0.23*sin(lon*8.0+lat*12.0)
  +0.17*cos(lon*17.0-lat*9.0)
  +0.10*sin(lon*29.0+lat*21.0)
  +0.08*cos(lon*47.0-lat*32.0);
function apply_red_spot(lat,lon,base) =
  let(
    mask=spot_mask(lat,lon),
    texture=clamp01(spot_texture(lat,lon)),
    red_color=mix_color(RED_DARK,RED_LIGHT,texture)
  )
  mix_color(base,red_color,mask*0.88);

// ================================================================
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
    c8=mix_color(c7,pc,pb),

    // --- NEW: latitudinal temperature-zone gradient ---
    temp = smooth01(abs(lat)/90),
    c9 = mix_color(c8,[0.38,0.44,0.52],temp*0.09)
  )
  apply_red_spot(lat,lon,c9);
// ================================================================

// GEOMETRY HELPERS 
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

module label3d(txt, sz=3) {
  linear_extrude(height=0.3)
    text(txt, size=sz, halign="center", valign="center");
}

module polyline(pts, d=0.5) {
  for (i=[0:len(pts)-2])
    hull() {
      translate(pts[i])   sphere(d=d,$fn=6);
      translate(pts[i+1]) sphere(d=d,$fn=6);
    }
}


// ROTATION AXIS 
module rotation_axis_mod() {
  color([1,0.25,0.25,0.85])
    cylinder(h=R*3.2, d=1.0, center=true, $fn=8);
  // north-pole arrowhead
  translate([0,0,R*1.6])
    color([1,0.25,0.25,0.95])
      cylinder(h=5, r1=2.8, r2=0, $fn=8);
  // south-pole cap
  translate([0,0,-R*1.6-5])
    color([1,0.25,0.25,0.95])
      cylinder(h=5, r1=0, r2=2.8, $fn=8);
  // period label
  translate([5,0,R*1.6+7])
    rotate([90,0,90])
      color([1,0.4,0.4])
        label3d("P = 9h 56min", 2.5);
}


// EQUATORIAL PLANE  
module equatorial_plane_mod() {
  color([0.25,0.65,1.0,0.10])
    cylinder(h=0.3, r=R*5.5, center=true, $fn=64);
  translate([R*5.7,0,1])
    rotate([90,0,90])
      color([0.25,0.65,1.0,0.7])
        label3d("Equatorial Plane", 2.8);
}


// ECLIPTIC PLANE  
module ecliptic_plane_mod() {
  color([1.0,0.78,0.15,0.08])
    cylinder(h=0.3, r=R*6, center=true, $fn=64);
  translate([R*6.2,0,-1])
    rotate([90,0,90])
      color([1.0,0.78,0.15,0.7])
        label3d("Ecliptic Plane", 2.8);
}


// ROTATION DIRECTION ARROW 
module rotation_arrow_mod() {
  color([1,0.95,0.15,0.75])
    rotate_extrude(angle=310,$fn=64)
      translate([R+5,0,0])
        circle(d=1.4,$fn=8);
  // arrowhead
  rotate([0,0,310])
    translate([R+5,0,0])
      rotate([0,-90,0])
        color([1,0.95,0.15,0.95])
          cylinder(h=6, r1=3.2, r2=0, $fn=8);
}


// MAGNETIC FIELD LINES  
function dipole_pts(Lsh, phi, n=36) = [
  for (i=[0:n])
    let(
      theta = 8 + i*164/n,
      rr    = Lsh * R * pow(sin(theta),2),
      x     = rr*sin(theta)*cos(phi),
      y     = rr*sin(theta)*sin(phi),
      z     = rr*cos(theta)
    ) [x,y,z]
];

module field_line(Lsh, phi, th=0.45) {
  polyline(dipole_pts(Lsh,phi), th);
}

module magnetotail_seg(z0, len=180) {
  pts = [for (i=[0:24])
    let(f=i/24)
    [-f*len, 0, z0*(1-f*0.4)+sin(f*3.1416)*12]
  ];
  polyline(pts, 0.4);
}

module magnetic_field_mod() {
  color([0.30,0.50,1.0,0.55])
    for (phi=[0:60:300]) {
      field_line(2.0, phi, 0.50);
      field_line(3.2, phi, 0.40);
      field_line(4.8, phi, 0.30);
    }
  // magnetotail
  color([0.30,0.50,1.0,0.35])
    for (z=[-18,-9,9,18])
      magnetotail_seg(z, 190);
}


// MAGNETOSPHERE BOUNDARY 
module magnetosphere_mod() {
  color([0.25,0.45,0.90,0.05])
    scale([2.8,1.0,1.0])
      sphere(r=R*4.5, $fn=FN);
  translate([R*12,0,R*3])
    rotate([90,0,90])
      color([0.3,0.5,0.9,0.45])
        label3d("Magnetosphere", 3);
}


// Io PLASMA TORUS 
module plasma_torus_mod() {
  color([0.75,0.25,0.55,0.14])       // purple-red
    rotate_extrude($fn=64)
      translate([ORBIT_IO,0,0])
        scale([1,0.35])
          circle(r=9,$fn=16);
  // secondary warm layer
  color([0.90,0.45,0.15,0.08])       // orange
    rotate_extrude($fn=64)
      translate([ORBIT_IO,0,0])
        scale([1,0.55])
          circle(r=6,$fn=12);
}


// RADIATION BELTS  
module radiation_belts_mod() {
  // inner
  color([1.0,0.25,0.08,0.11])
    rotate_extrude($fn=48)
      translate([R*1.4,0,0])
        scale([1,0.30]) circle(r=5,$fn=12);
  // middle
  color([1.0,0.50,0.10,0.08])
    rotate_extrude($fn=48)
      translate([R*1.85,0,0])
        scale([1,0.35]) circle(r=7,$fn=12);
  // outer
  color([1.0,0.70,0.20,0.05])
    rotate_extrude($fn=48)
      translate([R*2.35,0,0])
        scale([1,0.40]) circle(r=9,$fn=12);
}

// 3-D AURORAE  
module aurorae_3d_mod() {
  pulse = 0.22 + 0.10*sin($t*360*3);
  // north glow
  translate([0,0,R*0.88])
    color([0.18,0.68,0.50,pulse])
      cylinder(h=R*0.28, r1=R*0.38, r2=R*0.18, $fn=FN);
  // north red edge
  translate([0,0,R*0.84])
    color([0.80,0.12,0.08,0.13])
      difference(){
        cylinder(h=R*0.14,r1=R*0.46,r2=R*0.34,$fn=FN);
        cylinder(h=R*0.14+0.1,r1=R*0.38,r2=R*0.26,$fn=FN);
      }
  // south glow
  translate([0,0,-R*0.88-R*0.28])
    color([0.18,0.68,0.50,pulse])
      cylinder(h=R*0.28, r1=R*0.18, r2=R*0.38, $fn=FN);
  // south red edge
  translate([0,0,-R*0.84-R*0.14])
    color([0.80,0.12,0.08,0.13])
      difference(){
        cylinder(h=R*0.14,r1=R*0.34,r2=R*0.46,$fn=FN);
        cylinder(h=R*0.14+0.1,r1=R*0.26,r2=R*0.38,$fn=FN);
      }
}


// ROCHE LIMIT 
module roche_limit_mod() {
  rl = R*1.75;
  color([1,0.18,0.18,0.18])
    for (a=[0:30:150]) {
      rotate([a,0,0])
        rotate_extrude($fn=48)
          translate([rl,0,0]) circle(d=0.5,$fn=4);
      rotate([0,a,0])
        rotate_extrude($fn=48)
          translate([rl,0,0]) circle(d=0.5,$fn=4);
    }
  translate([rl+6,0,0])
    rotate([90,0,90])
      color([1,0.3,0.3,0.65])
        label3d("Roche Limit", 2.5);
}


// RING SYSTEM  
module ring_torus(ir,or,h) {
  difference(){
    cylinder(h=h,r=or,center=true,$fn=64);
    cylinder(h=h+1,r=ir,center=true,$fn=64);
  }
}
module rings_mod() {
  // main ring
  color([0.72,0.66,0.55,0.50])
    ring_torus(R*1.15, R*1.26, 0.9);
  // halo
  color([0.50,0.45,0.40,0.22])
    ring_torus(R*1.05, R*1.18, 2.5);
  // gossamer (Amalthea)
  color([0.60,0.55,0.50,0.12])
    ring_torus(R*1.30, R*1.52, 0.35);
  // gossamer (Thebe)
  color([0.60,0.55,0.50,0.08])
    ring_torus(R*1.52, R*1.82, 0.35);
}


// GALILEAN MOONS + ORBIT PATHS 
// ================================================================
module moon_orbit_path(radius) {
  color([0.5,0.5,0.5,0.25])
    rotate_extrude($fn=64)
      translate([radius,0,0])
        circle(d=0.5,$fn=6);
}

module moon_axis(mr) {
  color([0.85,0.85,0.85,0.55])
    cylinder(h=mr*3.5, d=0.35, center=true, $fn=6);
  // tiny arrowhead
  translate([0,0,mr*1.75])
    color([0.85,0.85,0.85,0.7])
      cylinder(h=1.5, r1=1.0, r2=0, $fn=6);
}

module galilean_moons_mod() {
  // orbital angles (resonance 4:2:1 for Io:Eu:Ga)
  a_io  = $t * 360 * 4;
  a_eu  = $t * 360 * 2;
  a_ga  = $t * 360 * 1;
  a_ca  = $t * 360 * 0.427;

  // orbit paths
  if (show_orbit_paths) {
    moon_orbit_path(ORBIT_IO);
    moon_orbit_path(ORBIT_EUROPA);
    moon_orbit_path(ORBIT_GANYMEDE);
    moon_orbit_path(ORBIT_CALLISTO);
  }

  // Io
  translate([ORBIT_IO*cos(a_io), ORBIT_IO*sin(a_io), 0]) {
    color([0.92,0.85,0.28]) sphere(r=R_IO,$fn=FN);
    if (show_moon_axes) moon_axis(R_IO);
    translate([0,0,R_IO+3])
      rotate([90,0,0]) color([0.9,0.85,0.3,0.7])
        label3d("Io",2);
  }
  // Europa
  translate([ORBIT_EUROPA*cos(a_eu), ORBIT_EUROPA*sin(a_eu), 0]) {
    color([0.74,0.82,0.88]) sphere(r=R_EUROPA,$fn=FN);
    if (show_moon_axes) moon_axis(R_EUROPA);
    translate([0,0,R_EUROPA+3])
      rotate([90,0,0]) color([0.74,0.82,0.88,0.7])
        label3d("Europa",2);
  }
  // Ganymede
  translate([ORBIT_GANYMEDE*cos(a_ga), ORBIT_GANYMEDE*sin(a_ga), 0]) {
    color([0.60,0.55,0.48]) sphere(r=R_GANYMEDE,$fn=FN);
    if (show_moon_axes) moon_axis(R_GANYMEDE);
    translate([0,0,R_GANYMEDE+3])
      rotate([90,0,0]) color([0.6,0.55,0.48,0.7])
        label3d("Ganymede",2);
  }
  // Callisto
  translate([ORBIT_CALLISTO*cos(a_ca), ORBIT_CALLISTO*sin(a_ca), 0]) {
    color([0.44,0.40,0.36]) sphere(r=R_CALLISTO,$fn=FN);
    if (show_moon_axes) moon_axis(R_CALLISTO);
    translate([0,0,R_CALLISTO+3])
      rotate([90,0,0]) color([0.44,0.40,0.36,0.7])
        label3d("Callisto",2);
  }
}


// TIDAL INTERACTION LINES
module tidal_dash(orbit_r, angle) {
  color([1,0.78,0.28,0.28])
    for (i=[0:2:18]) {
      f1 = i/20;  f2 = (i+1)/20;
      hull(){
        translate([orbit_r*f1*cos(angle),orbit_r*f1*sin(angle),0])
          sphere(d=0.6,$fn=4);
        translate([orbit_r*f2*cos(angle),orbit_r*f2*sin(angle),0])
          sphere(d=0.6,$fn=4);
      }
    }
}
module tidal_lines_mod() {
  tidal_dash(ORBIT_IO,       $t*360*4);
  tidal_dash(ORBIT_EUROPA,   $t*360*2);
  tidal_dash(ORBIT_GANYMEDE, $t*360*1);
  tidal_dash(ORBIT_CALLISTO, $t*360*0.427);
}


//  MAIN ASSEMBLY
module jupiter_system() {

  // --- ecliptic plane (reference, NOT tilted) ---
  if (show_ecliptic_plane)
    ecliptic_plane_mod();

  // --- everything tilted by Jupiter's axial tilt ---
  rotate([AXIAL_TILT, 0, 0]) {

    // Jupiter surface (animated spin)
    rotate([0, 0, $t*360])
      jupiter();

    // rings (co-rotate)
    if (show_rings) rings_mod();

    // rotation axis
    if (show_rotation_axis) rotation_axis_mod();

    // rotation-direction arrow
    if (show_rotation_arrow) rotation_arrow_mod();

    // 3-D auroral glow (animated pulse)
    if (show_aurorae_3d) aurorae_3d_mod();

    // equatorial plane (tilted with planet)
    if (show_equatorial_plane) equatorial_plane_mod();

    // magnetic field lines
    if (show_magnetic_field) magnetic_field_mod();

    // Io plasma torus
    if (show_plasma_torus) plasma_torus_mod();

    // radiation belts
    if (show_radiation_belts) radiation_belts_mod();

    // Galilean moons (animated orbits)
    if (show_moons) galilean_moons_mod();

    // tidal interaction lines
    if (show_tidal_lines) tidal_lines_mod();
  }

  // --- magnetosphere boundary (solar-wind frame, untilted) ---
  if (show_magnetosphere) magnetosphere_mod();

  // --- Roche limit (untilted for clarity) ---
  if (show_roche_limit) roche_limit_mod();
}

// ---- render ----
jupiter_system();