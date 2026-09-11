/***** MODEL OF SMALLER MOONS OF JUPITER *****/

R = 40;

// Preview is deliberately lower resolution.
LAT = $preview ? 70  : 170;
LON = $preview ? 140 : 340;

// Jupiter sphere patch resolution.
// Increase for higher detail, decrease for faster rendering.
JUPITER_FN = $preview ? 40 : 80;


// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

function clamp01(x) =
    max(0, min(1, x));

function smooth01(x) =
    let(q = clamp01(x))
    q*q*(3 - 2*q);

function mix_color(a, b, t) =
    let(q = clamp01(t))
    [
        a[0] + (b[0] - a[0]) * q,
        a[1] + (b[1] - a[1]) * q,
        a[2] + (b[2] - a[2]) * q
    ];

function wrap_lon(x) =
    x > 180 ? x - 360 :
    x < -180 ? x + 360 :
    x;


// ============================================================================
// JUPITER COLOR PALETTE
// ============================================================================

DARK       = [0.24, 0.16, 0.10];
DARK_B     = [0.32, 0.20, 0.12];
BROWN      = [0.45, 0.27, 0.16];
RED_BROWN  = [0.56, 0.30, 0.15];
OCHRE      = [0.67, 0.40, 0.20];
TAN        = [0.70, 0.54, 0.40];
CREAM      = [0.84, 0.77, 0.66];
LIGHT      = [0.91, 0.86, 0.77];
WHITE      = [0.975, 0.955, 0.90];

BLUE_WHITE = [0.79, 0.84, 0.84];
POLAR_GRAY = [0.53, 0.57, 0.55];
POLAR_DARK = [0.30, 0.28, 0.25];

RED_DARK   = [0.40, 0.075, 0.025];
RED_MID    = [0.64, 0.16, 0.045];
RED        = [0.78, 0.25, 0.065];
RED_LIGHT  = [0.91, 0.40, 0.13];


// ============================================================================
// LARGE-SCALE ATMOSPHERIC NOISE
// ============================================================================

function noise_large(lat, lon) =
      0.42 * sin(lon*1.25 + lat*0.80)
    + 0.27 * cos(lon*2.70 - lat*1.10)
    + 0.16 * sin(lon*5.20 + lat*2.20)
    + 0.10 * cos(lon*8.70 - lat*3.40)
    + 0.06 * sin(lon*14.0 + lat*4.70);


function noise_medium(lat, lon) =
      0.42 * sin(lon*4.10 + lat*2.00)
    + 0.27 * cos(lon*8.70 - lat*3.70)
    + 0.17 * sin(lon*15.0 + lat*5.20)
    + 0.09 * cos(lon*27.0 - lat*8.00);


function noise_fine(lat, lon) =
      0.38 * sin(lon*12.0 + lat*5.0)
    + 0.26 * cos(lon*23.0 - lat*8.0)
    + 0.18 * sin(lon*39.0 + lat*13.0)
    + 0.10 * cos(lon*67.0 - lat*21.0);


// ============================================================================
// JET STREAM / WIND WAVES
// ============================================================================

function wind_wave(lon, phase) =
      3.2  * sin(lon*1.35 + phase)
    + 2.0  * sin(lon*2.70 - phase*0.70)
    + 1.15 * sin(lon*5.20 + phase*1.40)
    + 0.55 * sin(lon*9.70 - phase*1.90);


// ============================================================================
// ATMOSPHERIC RIBBON
// ============================================================================

function ribbon(
    lat,
    lon,
    center,
    width,
    amplitude,
    frequency,
    phase
) =
    let(
        shifted_center =
            center
            + amplitude * sin(lon*frequency + phase)
            + wind_wave(lon, phase) * 0.35,

        distance = lat - shifted_center
    )
    exp(-pow(distance/width, 2));


// ============================================================================
// DARK JUPITER BELTS
// ============================================================================

function dark_belts(lat, lon) =
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


// ============================================================================
// BRIGHT BELTS
// ============================================================================

function bright_belts(lat, lon) =
      ribbon(lat,lon,-33,2.0,2.9,1.05,1.0)
    + ribbon(lat,lon,-23,2.4,3.8,0.82,4.8)
    + ribbon(lat,lon,-17,1.8,3.2,1.00,2.3)
    + ribbon(lat,lon,-8,2.0,3.8,0.74,5.0)
    + ribbon(lat,lon,7,2.1,3.6,0.83,2.0)
    + ribbon(lat,lon,15,2.0,3.4,0.91,4.3)
    + ribbon(lat,lon,24,2.2,3.7,0.91,4.3)
    + ribbon(lat,lon,28,2.0,3.1,1.08,1.2)
    + ribbon(lat,lon,34,1.8,2.6,0.87,5.4);


// ============================================================================
// DARK FILAMENTS
// ============================================================================

function dark_filaments(lat, lon) =
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


// ============================================================================
// BRIGHT FILAMENTS
// ============================================================================

function bright_filaments(lat, lon) =
      ribbon(lat,lon,-34,0.32,4.0,1.30,3.2)
    + ribbon(lat,lon,-24,0.30,4.4,1.70,0.7)
    + ribbon(lat,lon,-19,0.35,3.6,1.40,4.1)
    + ribbon(lat,lon,-9,0.30,4.1,1.80,1.5)
    + ribbon(lat,lon,6,0.32,3.9,1.60,3.9)
    + ribbon(lat,lon,15,0.31,4.2,1.45,0.3)
    + ribbon(lat,lon,24,0.34,3.7,1.70,2.7)
    + ribbon(lat,lon,33,0.30,3.8,1.35,5.0);


// ============================================================================
// POLAR FUNCTIONS
// ============================================================================

function polar_distance(lat) =
    90 - abs(lat);


function polar_blend(lat) =
    let(p = polar_distance(lat))
    smooth01((52-p)/16);


function polar_warp(lon, p, phase) =
      3.2  * sin(lon + phase)
    + 1.9  * sin(lon*2.0 - phase*1.7)
    + 1.15 * sin(lon*3.0 + p*0.7 + phase)
    + 0.75 * sin(lon*5.0 - p*1.2)
    + 0.40 * sin(lon*9.0 + p*2.0)
    + 0.20 * sin(lon*17.0 - p*3.0);


function polar_micro(lon, p) =
      0.75 * sin(lon*11.0 + p*3.0)
    + 0.48 * sin(lon*19.0 - p*4.5)
    + 0.32 * sin(lon*31.0 + p*7.0)
    + 0.19 * sin(lon*47.0 - p*10.0)
    + 0.10 * sin(lon*71.0 + p*15.0);


function polar_ring(
    lat,
    lon,
    radius,
    width,
    phase,
    strength
) =
    let(
        p = polar_distance(lat),

        center =
            radius
            + polar_warp(lon,p,phase)*strength
            + polar_micro(lon,p)*0.35,

        distance = p-center,

        varying_width =
            width *
            (
                0.72
                + 0.28 *
                (
                    0.5
                    + 0.5*sin(lon*3.0+phase)
                )
            )
    )
    exp(-pow(distance/varying_width,2));


function polar_break(lon, phase) =
    let(
        n =
              0.45*sin(lon+phase)
            + 0.30*sin(lon*2.0-phase*1.3)
            + 0.20*sin(lon*4.0+phase*2.2)
            + 0.12*sin(lon*7.0-phase)
    )
    0.20 + 0.80*smooth01((n+0.08)/0.35);


function broken_polar_ring(
    lat,
    lon,
    radius,
    width,
    phase,
    strength
) =
    polar_ring(lat,lon,radius,width,phase,strength)
    * polar_break(lon,phase);


// ============================================================================
// POLAR BANDS
// ============================================================================

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


// ============================================================================
// POLAR FILAMENTS
// ============================================================================

function polar_filament(
    lat,
    lon,
    radius,
    width,
    frequency,
    phase,
    strength
) =
    let(
        p = polar_distance(lat),

        center =
            radius
            + polar_warp(lon,p,phase)*0.65
            + 1.1*sin(lon*frequency+p*3.0+phase),

        distance = p-center
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


// ============================================================================
// POLAR CROSS FLOW
// ============================================================================

function polar_crossflow(lat,lon) =
    let(
        p = polar_distance(lat),

        a =
            sin(
                lon*3.0
                + p*7.0
                + 2*sin(lon*2.0)
            ),

        b =
            sin(
                lon*6.0
                - p*4.0
                + sin(lon*5.0)
            ),

        c = sin(lon*13.0+p*9.0),
        d = sin(lon*23.0-p*15.0)
    )
      a*0.45
    + b*0.28
    + c*0.17
    + d*0.10;


// ============================================================================
// POLAR VORTICES
// ============================================================================

function polar_vortex(
    lat,
    lon,
    radius,
    angle,
    size,
    strength
) =
    let(
        p = polar_distance(lat),
        delta_lon = wrap_lon(lon-angle),

        x = delta_lon*cos(radius),
        y = p-radius,

        distance = sqrt(x*x+y*y)
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


// ============================================================================
// POLAR COLOR
// ============================================================================

function polar_color(lat,lon) =
    let(
        p = polar_distance(lat),

        b1 = polar_band_1(lat,lon),
        b2 = polar_band_2(lat,lon),
        b3 = polar_band_3(lat,lon),
        b4 = polar_band_4(lat,lon),
        b5 = polar_band_5(lat,lon),
        b6 = polar_band_6(lat,lon),
        b7 = polar_band_7(lat,lon),
        b8 = polar_band_8(lat,lon),
        b9 = polar_band_9(lat,lon),

        fil = polar_filament_field(lat,lon),
        cross = polar_crossflow(lat,lon),
        vort = polar_vortices(lat,lon),

        c0 = [0.82,0.84,0.80],

        cap =
            smooth01((9-p)/6),

        c1 =
            mix_color(
                c0,
                [0.62,0.67,0.65],
                cap*0.65
            ),

        c2 =
            mix_color(
                c1,
                [0.34,0.31,0.27],
                b1*0.75
            ),

        c3 =
            mix_color(
                c2,
                [0.72,0.82,0.84],
                b2*0.72
            ),

        c4 =
            mix_color(
                c3,
                [0.48,0.34,0.24],
                b3*0.76
            ),

        c5 =
            mix_color(
                c4,
                [0.90,0.91,0.87],
                b4*0.68
            ),

        c6 =
            mix_color(
                c5,
                [0.35,0.32,0.28],
                b5*0.67
            ),

        c7 =
            mix_color(
                c6,
                [0.77,0.81,0.79],
                b6*0.65
            ),

        c8 =
            mix_color(
                c7,
                [0.58,0.35,0.20],
                b7*0.78
            ),

        c9 =
            mix_color(
                c8,
                [0.80,0.86,0.87],
                b8*0.67
            ),

        c10 =
            mix_color(
                c9,
                [0.62,0.48,0.36],
                b9*0.35
            ),

        dark_fil =
            smooth01((fil-0.15)/0.55),

        c11 =
            mix_color(
                c10,
                [0.28,0.25,0.22],
                dark_fil*0.27
            ),

        light_fil =
            smooth01((-fil+0.15)/0.55),

        c12 =
            mix_color(
                c11,
                [0.94,0.94,0.89],
                light_fil*0.22
            ),

        cross_dark =
            smooth01((-cross+0.10)/0.60),

        c13 =
            mix_color(
                c12,
                [0.42,0.31,0.23],
                cross_dark*0.18
            ),

        c14 =
            mix_color(
                c13,
                [0.62,0.47,0.35],
                clamp01(vort)*0.20
            ),

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


// ============================================================================
// STORMS
// ============================================================================

function storm(
    lat,
    lon,
    center_lat,
    center_lon,
    lat_size,
    lon_size
) =
    let(
        dx = wrap_lon(lon-center_lon),
        dy = lat-center_lat,

        distance =
            sqrt(
                pow(dy/lat_size,2)
                +
                pow(dx/lon_size,2)
            )
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


// ============================================================================
// GREAT RED SPOT
// ============================================================================

function spot_distance(lat,lon) =
    let(
        dx = wrap_lon(lon+20),
        dy = lat+22,

        x = dx/18.0,
        y = dy/7.8
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
        mask = spot_mask(lat,lon),

        texture =
            clamp01(
                spot_texture(lat,lon)
            ),

        red_color =
            mix_color(
                RED_DARK,
                RED_LIGHT,
                texture
            )
    )
    mix_color(
        base,
        red_color,
        mask*0.88
    );


// ============================================================================
// COMPLETE JUPITER COLOR FUNCTION
// ============================================================================

function jupiter_color(lat,lon) =
    let(
        dark =
            clamp01(
                dark_belts(lat,lon)*0.58
            ),

        bright =
            clamp01(
                bright_belts(lat,lon)*0.52
            ),

        dark_f =
            clamp01(
                dark_filaments(lat,lon)*0.52
            ),

        bright_f =
            clamp01(
                bright_filaments(lat,lon)*0.38
            ),

        large =
            noise_large(lat,lon),

        medium =
            noise_medium(lat,lon),

        fine =
            noise_fine(lat,lon),

        c0 =
            mix_color(
                CREAM,
                BROWN,
                dark
            ),

        warm =
            clamp01(
                dark*0.65
                + (-large)*0.12
            ),

        c1 =
            mix_color(
                c0,
                OCHRE,
                warm*0.35
            ),

        c2 =
            mix_color(
                c1,
                DARK,
                dark_f*0.42
            ),

        c3 =
            mix_color(
                c2,
                LIGHT,
                bright*0.42
            ),

        c4 =
            mix_color(
                c3,
                WHITE,
                bright_f*0.52
            ),

        c5 =
            mix_color(
                c4,
                TAN,
                clamp01((-medium+0.5)*0.11)
            ),

        c6 =
            mix_color(
                c5,
                WHITE,
                smooth01((fine-0.40)/0.60)*0.13
            ),

        storms =
            storm_field(lat,lon),

        c7 =
            mix_color(
                c6,
                [0.53,0.34,0.22],
                clamp01(storms)*0.18
            ),

        pc =
            polar_color(lat,lon),

        pb =
            polar_blend(lat),

        c8 =
            mix_color(
                c7,
                pc,
                pb
            )
    )
    apply_red_spot(lat,lon,c8);


// ============================================================================
// SPHERE COORDINATES
// ============================================================================

function sphere_point(r,lat,lon) =
[
    r*cos(lat)*cos(lon),
    r*cos(lat)*sin(lon),
    r*sin(lat)
];


// ============================================================================
// JUPITER SURFACE PATCH
// ============================================================================

module patch(lat1,lat2,lon1,lon2)
{
    lat = (lat1+lat2)/2;
    lon = (lon1+lon2)/2;

    color(
        jupiter_color(lat,lon)
    )
    polyhedron(
        points =
        [
            sphere_point(R,lat1,lon1),
            sphere_point(R,lat1,lon2),
            sphere_point(R,lat2,lon2),
            sphere_point(R,lat2,lon1)
        ],

        faces =
        [
            [0,1,2,3]
        ],

        convexity = 2
    );
}


// ============================================================================
// JUPITER
// ============================================================================

module jupiter()
{
    for(i = [0:LAT-1])
    {
        lat1 = -90 + 180*i/LAT;
        lat2 = -90 + 180*(i+1)/LAT;

        for(j = [0:LON-1])
        {
            lon1 = -180 + 360*j/LON;
            lon2 = -180 + 360*(j+1)/LON;

            patch(
                lat1,
                lat2,
                lon1,
                lon2
            );
        }
    }
}


// ============================================================================
// JUPITER RINGS
// ============================================================================

module jupiter_rings()
{
    color(
        [0.85,0.80,0.70],
        0.35
    )
    {

        // Main ring
        difference()
        {
            cylinder(
                h = 0.15,
                r = 129.5,
                center = true,
                $fn = 100
            );

            cylinder(
                h = 0.30,
                r = 122.5,
                center = true,
                $fn = 100
            );
        }


        // Amalthea gossamer ring
        difference()
        {
            cylinder(
                h = 0.10,
                r = 182,
                center = true,
                $fn = 100
            );

            cylinder(
                h = 0.25,
                r = 129.5,
                center = true,
                $fn = 100
            );
        }


        // Thebe gossamer ring
        difference()
        {
            cylinder(
                h = 0.08,
                r = 222.5,
                center = true,
                $fn = 100
            );

            cylinder(
                h = 0.20,
                r = 182,
                center = true,
                $fn = 100
            );
        }
    }
}


// ============================================================================
// JUPITER AXIS
// ============================================================================

module jupiter_axis()
{
    color(
        [1,0.2,0.2],
        0.8
    )
    rotate([3.13,0,0])
    {
        cylinder(
            h = 120,
            r = 0.8,
            center = true,
            $fn = 20
        );

        // North pole
        translate([0,0,60])
            cylinder(
                h = 6,
                r1 = 3,
                r2 = 0,
                center = false,
                $fn = 20
            );

        // South pole
        translate([0,0,-60])
            cylinder(
                h = 6,
                r1 = 3,
                r2 = 0,
                center = false,
                $fn = 20
            );
    }
}


// ============================================================================
// ORBIT MODULE
// ============================================================================
//
// The orbit is built from many small rectangular segments.
// This gives a lightweight visual orbit without expensive torus geometry.
// radius = orbital radius,
// segments = number of segments,
// thickness = visible orbit width,
// Inclination is applied outside this module.
//
// ============================================================================

module orbit(
    radius,
    segments = 180,
    thickness = 0.25
)
{
    circumference =
        2*PI*radius;

    segment_length =
        circumference/segments;

    angle_step =
        360/segments;

    for(i = [0:segments-1])
    {
        rotate(i*angle_step)
        translate([0,radius,0])
        square(
            [
                segment_length,
                thickness
            ],
            center = true
        );
    }
}


// ============================================================================
// MOON LABEL
// ============================================================================

module moon_label(
    name,
    period,
    x,
    y,
    label_size = 3,
    period_size = 2,
    flip = false
)
{
    direction =
        flip ? 90 : -90;

    translate([x,y,0])
    rotate([0,0,direction])
    {
        color([1,1,1])
        text(
            name,
            size = label_size,
            valign = "center",
            halign = "center"
        );
    }

    translate([x,y-4,0])
    rotate([0,0,direction])
    {
        color([0.8,0.8,0.8])
        text(
            period,
            size = period_size,
            valign = "center",
            halign = "center"
        );
    }
}


// ============================================================================
// MOON MODULE
// ============================================================================

module moon(
    name,
    period,
    distance,
    position = [0,0,0],
    moon_radius = 5,
    moon_color = [0.7,0.7,0.7],
    orbit_inclination = [0,0,0],
    orbit_segments = 180,
    orbit_thickness = 0.25,
    label_offset = 10,
    label_size = 3,
    period_size = 2,
    flip_label = false,
    moon_fn = 60
)
{
    // Orbit
    color(
        [0.65,0.65,0.65],
        0.45
    )
    rotate(orbit_inclination)
        orbit(
            distance,
            orbit_segments,
            orbit_thickness
        );


    // Moon
    color(moon_color)
    translate(position)
    sphere(
        r = moon_radius,
        $fn = moon_fn
    );


    // Labels
    moon_label(
        name,
        period,
        position[0] + label_offset,
        position[1],
        label_size,
        period_size,
        flip_label
    );
}


// ============================================================================
// JUPITER
// ============================================================================

jupiter();


// ============================================================================
// JUPITER RINGS
// ============================================================================

jupiter_rings();


// ============================================================================
// JUPITER ROTATION AXIS
// ============================================================================

jupiter_axis();


// ============================================================================
// INNER MOONS
// ============================================================================


// ----------------------------------------------------------------------------
// METIS
// ----------------------------------------------------------------------------

moon(
    "Metis",
    "0.30 d",
    128,
    [128,0,0],
    3,
    [173/255,216/255,230/255],
    [0,0,0],
    180,
    0.25,
    4.5,
    2,
    1.5
);


// ----------------------------------------------------------------------------
// ADRASTEA
// ----------------------------------------------------------------------------

moon(
    "Adrastea",
    "0.30 d",
    132,
    [129,-30,0],
    1.5,
    [240/255,128/255,128/255],
    [15,90,92],
    180,
    0.25,
    4.5,
    2,
    1.5
);


// ----------------------------------------------------------------------------
// AMALTHEA
// ----------------------------------------------------------------------------

moon(
    "Amalthea",
    "0.50 d",
    181,
    [181,0,0],
    9,
    [255/255,160/255,122/255],
    [25,0,0],
    180,
    0.25,
    11,
    2.5,
    2
);


// ----------------------------------------------------------------------------
// THEBE
// ----------------------------------------------------------------------------

moon(
    "Thebe",
    "0.67 d",
    221.9,
    [221.9,5,0],
    5,
    [176/255,196/255,222/255],
    [-5,0,0],
    180,
    0.25,
    6,
    2.5,
    2
);


// ============================================================================
// GALILEAN MOONS
// ============================================================================


// ----------------------------------------------------------------------------
// IO
// ----------------------------------------------------------------------------

moon(
    "Io",
    "1.77 d",
    421.8,
    [421.8,0,0],
    15,
    [255/255,239/255,213/255],
    [25,0,0],
    180,
    0.25,
    21,
    8,
    6,
    false,
    100
);


// ----------------------------------------------------------------------------
// EUROPA
// ----------------------------------------------------------------------------

moon(
    "Europa",
    "3.55 d",
    671.1,
    [671.1,0,0],
    12,
    [255/255,250/255,240/255],
    [20,0,0],
    180,
    0.25,
    17,
    7,
    5,
    false,
    100
);


// ----------------------------------------------------------------------------
// GANYMEDE
// ----------------------------------------------------------------------------

moon(
    "Ganymede",
    "7.15 d",
    1070,
    [1070,0,0],
    20,
    [255/255,222/255,173/255],
    [10,0,0],
    500,
    0.50,
    21,
    2.5,
    2,
    false,
    100
);


// ----------------------------------------------------------------------------
// CALLISTO
// ----------------------------------------------------------------------------

moon(
    "Callisto",
    "16.69 d",
    1882.7,
    [1882.7,0,0],
    16,
    [160/255,82/255,45/255],
    [0,0,0],
    500,
    0.50,
    21,
    7,
    5,
    false,
    100
);


// ============================================================================
// IRREGULAR MOONS
// ============================================================================


// ----------------------------------------------------------------------------
// HIMALIA
// ----------------------------------------------------------------------------

moon(
    "Himalia",
    "250.6 d",
    4500,
    [4500,0,0],
    8,
    [0.6,0.6,0.6],
    [27.5,0,0],
    500,
    0.50,
    12,
    3,
    2,
    false,
    50
);


// ----------------------------------------------------------------------------
// ELARA
// ----------------------------------------------------------------------------

moon(
    "Elara",
    "259.6 d",
    4600,
    [4600,100,0],
    4,
    [0.5,0.5,0.55],
    [26.6,0,45],
    500,
    0.50,
    12,
    2.5,
    1.8,
    false,
    50
);


// ----------------------------------------------------------------------------
// PASIPHAE
// ----------------------------------------------------------------------------

moon(
    "Pasiphae",
    "743.6 d",
    6000,
    [-6000,0,0],
    3,
    [0.4,0.4,0.45],
    [151,0,0],
    500,
    0.50,
    12,
    2.5,
    1.8,
    true,
    50
);


// ----------------------------------------------------------------------------
// ANANKE
// ----------------------------------------------------------------------------

moon(
    "Ananke",
    "629.8 d",
    5500,
    [-5500,100,0],
    2,
    [0.45,0.4,0.4],
    [149,0,30],
    500,
    0.50,
    12,
    2.5,
    1.8,
    true,
    50
);

