// Model of Jupiter

R = 40;
LAT = $preview ? 70 : 170;
LON = $preview ? 140 : 340;

/**
LAT and LON determine the number of subdivisions in latitude and longitude.
Latitude covers:  -90° ≤ lat ≤ 90°
Longitude covers:  -180° ≤ lon < 180°
The approximate angular increments are:  Δlat = 180° / LAT
The approximate angular increments are:  Δlon = 360° / LON
**/

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

/**
CLAMPING/BOUNDED FUNCTION
clamp01(x) restricts x to the closed interval [0,1].
Mathematically:  clamp(x,0,1) = max(0,min(1,x))
Therefore:  x < 0 → 0
Therefore:  0 ≤ x ≤ 1 → x
Therefore:  x > 1 → 1
This is useful for keeping interpolation weights and color coefficients within their valid range.
**/
function clamp01(x) = max(0,min(1,x));

/**
SMOOTHSTEP INTERPOLATION
First x is clamped:  q = clamp01(x)
Then the cubic smoothstep polynomial is:  S(q) = q²(3 - 2q)
Equivalent form:  S(q) = 3q² - 2q³
Its endpoint values are:  S(0) = 0
Its endpoint values are:  S(1) = 1
Its derivative is:  S'(q) = 6q(1-q)
Therefore:  S'(0) = S'(1) = 0
This creates a smooth transition between 0 and 1 without the sharp boundary produced by ordinary linear interpolation.
**/
function smooth01(x) =
    let(q=clamp01(x))
    q*q*(3-2*q);

/**
LINEAR INTERPOLATION
For two vectors/colors a and b, interpolation is:  C(t) = a + t(b-a)
Component-wise:  C_i(t) = a_i + t(b_i-a_i)
where:  0 ≤ t ≤ 1
t = 0 gives a.
t = 1 gives b.
Intermediate values produce a weighted combination.
The parameter is clamped so the interpolation remains bounded.
**/
function mix_color(a,b,t) =
    let(q=clamp01(t))
    [
        a[0]+(b[0]-a[0])*q,
        a[1]+(b[1]-a[1])*q,
        a[2]+(b[2]-a[2])*q
    ];

/**
PERIODIC ANGULAR WRAPPING
Longitude is periodic with period 360°:  f(lon) = f(lon + 360°k)
for any integer k.
This function maps longitude back toward:  -180° ≤ lon ≤ 180°
The transformation is equivalent to reducing an angle modulo 360°, with the chosen interval centered around zero.
**/
function wrap_lon(x) =
    x > 180 ? x-360 :
    x < -180 ? x+360 :
    x;

/**
FOURIER-LIKE TRIGONOMETRIC SUPERPOSITION
noise_large is a weighted sum of sine and cosine waves:  N(lat,lon) = Σ A_k sin(α_k lon + β_k lat + φ_k) + Σ B_k cos(γ_k lon + δ_k lat + ψ_k)
Each term introduces a spatial frequency and phase.
The coefficients control relative amplitude.
Higher frequencies create smaller spatial features.
**/
function noise_large(lat,lon) =
      0.42*sin(lon*1.25+lat*0.80)
    + 0.27*cos(lon*2.70-lat*1.10)
    + 0.16*sin(lon*5.20+lat*2.20)
    + 0.10*cos(lon*8.70-lat*3.40)
    + 0.06*sin(lon*14.0+lat*4.70);

/**
MULTI-SCALE PERIODIC NOISE
The medium-scale field is another finite Fourier-like series:  N_m(lat,lon) = Σ A_k f_k(α_k lon + β_k lat + φ_k)
where f_k is sin or cos.
Increasing the angular frequencies reduces the characteristic spatial wavelength:  λ ∝ 2π/k
Thus this field contains smaller structures than noise_large.
**/
function noise_medium(lat,lon) =
      0.42*sin(lon*4.10+lat*2.00)
    + 0.27*cos(lon*8.70-lat*3.70)
    + 0.17*sin(lon*15.0+lat*5.20)
    + 0.09*cos(lon*27.0-lat*8.00);

/**
HIGH-FREQUENCY TRIGONOMETRIC DETAIL
The fine noise field uses still higher spatial frequencies:  N_f(lat,lon) = Σ A_k sin/cos(k_lon lon + k_lat lat + φ)
High frequency means:  shorter wavelength → smaller visible structures → finer atmospheric texture.
**/
function noise_fine(lat,lon) =
      0.38*sin(lon*12.0+lat*5.0)
    + 0.26*cos(lon*23.0-lat*8.0)
    + 0.18*sin(lon*39.0+lat*13.0)
    + 0.10*cos(lon*67.0-lat*21.0);

//**************************
// JUPITER WIND STRUCTURE
//**************************

/**
SUPERPOSITION OF WAVES
The wind-wave displacement is:  W(lon,phase) = 3.2 sin(1.35lon + phase) + 2.0 sin(2.70lon - 0.70phase) + 1.15 sin(5.20lon + 1.40phase) + 0.55 sin(9.70lon - 1.90phase)
This is a finite Fourier-like series.
The different frequencies interfere through superposition, creating a non-repeating-looking but deterministic flow pattern.
**/
function wind_wave(lon,phase) =
      3.2*sin(lon*1.35+phase)
    + 2.0*sin(lon*2.70-phase*0.70)
    + 1.15*sin(lon*5.20+phase*1.40)
    + 0.55*sin(lon*9.70-phase*1.90);

//**************************
// ATMOSPHERIC RIBBON
//**************************

/**
GAUSSIAN-LIKE FALLOFF
The ribbon center is:  C(lon) = center + amplitude sin(frequency·lon + phase) + 0.35 W(lon,phase)
The perpendicular latitude displacement is:  d = lat - C(lon)
The ribbon intensity is:  G(d) = exp(-(d/width)²)
At d = 0:  G(0) = 1
As |d| increases:  G(d) → 0
Thus width controls the thickness of the atmospheric band.
**/
function ribbon(lat,lon,center,width,amplitude,frequency,phase) =
    let(
        shifted_center =
            center
            + amplitude*sin(lon*frequency+phase)
            + wind_wave(lon,phase)*0.35,
        distance = lat-shifted_center
    )
    exp(-pow(distance/width,2));

//**************************
// MAJOR DARK BELTS
//**************************

/**
WEIGHTED SUPERPOSITION
The complete dark-belt field is:  D(lat,lon) = Σ w_i R_i(lat,lon)
where R_i is an individual ribbon and w_i is its strength.
Superposition allows multiple atmospheric bands to coexist.
**/
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

//**************************
// BRIGHT BELTS
//**************************

/**
SECOND SUPERPOSED SCALAR FIELD
Bright belts are another weighted sum:  B(lat,lon) = Σ R_i(lat,lon)
Their eventual contribution to color is independently scaled from the dark-belt field.
**/
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

//**************************
// FINE DARK CLOUD STREAMS
//**************************

/**
SMALLER-SCALE GAUSSIAN RIBBONS
The same Gaussian-like ribbon:  G(d) = exp(-(d/w)²)
Smaller w gives narrower filaments.
Larger frequency gives more rapid longitudinal variation.
**/
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

//**************************
// FINE BRIGHT STREAMS
//**************************

/**
ADDITIVE FIELD CONSTRUCTION
The bright filament field is another sum:  F_bright(lat,lon) = Σ R_i(lat,lon)
Each ribbon contributes independently before the result is scaled during color synthesis.
**/
function bright_filaments(lat,lon) =
      ribbon(lat,lon,-34,0.32,4.0,1.30,3.2)
    + ribbon(lat,lon,-24,0.30,4.4,1.70,0.7)
    + ribbon(lat,lon,-19,0.35,3.6,1.40,4.1)
    + ribbon(lat,lon,-9,0.30,4.1,1.80,1.5)
    + ribbon(lat,lon,6,0.32,3.9,1.60,3.9)
    + ribbon(lat,lon,15,0.31,4.2,1.45,0.3)
    + ribbon(lat,lon,24,0.34,3.7,1.70,2.7)
    + ribbon(lat,lon,33,0.30,3.8,1.35,5.0);

//**************************
// POLAR GEOMETRY
//**************************

/**
ABSOLUTE VALUE AND DISTANCE FROM POLE
Latitude is measured from the equator:  lat = 0° at the equator
Latitude is measured from the equator:  lat = ±90° at the poles
The angular distance from the nearest pole is:  p = 90° - |lat|
Therefore:  lat = ±90° → p = 0°
Therefore:  lat = 0° → p = 90°
**/
function polar_distance(lat) = 90-abs(lat);

/**
POLAR BLENDING
The polar blend begins approximately when:  p < 52°
and reaches full strength near:  p ≤ 36°
The normalized transition argument is:  x = (52-p)/16
followed by smoothstep:  B(p) = S(clamp(x,0,1))
This creates a continuous transition from ordinary atmosphere to polar atmosphere.
**/
function polar_blend(lat) =
    let(p=polar_distance(lat))
    smooth01((52-p)/16);

//**************************
// POLAR WARP
//**************************

/**
MULTI-FREQUENCY POLAR PERTURBATION
The polar warp is:  W(lon,p) = Σ A_k sin(k_lon lon + k_p p + φ_k)
Different frequencies generate nested and irregular polar structures.
The dependence on p couples radial distance from the pole to longitudinal oscillations.
**/
function polar_warp(lon,p,phase) =
      3.2*sin(lon+phase)
    + 1.9*sin(lon*2.0-phase*1.7)
    + 1.15*sin(lon*3.0+p*0.7+phase)
    + 0.75*sin(lon*5.0-p*1.2)
    + 0.40*sin(lon*9.0+p*2.0)
    + 0.20*sin(lon*17.0-p*3.0);

/**
HIGH-FREQUENCY POLAR PERTURBATION
The polar microstructure adds smaller-scale oscillations:  M(lon,p) = Σ A_k sin(k_lon lon + k_p p + φ_k)
Because the frequencies are larger, the characteristic wavelength is smaller.
**/
function polar_micro(lon,p) =
      0.75*sin(lon*11.0+p*3.0)
    + 0.48*sin(lon*19.0-p*4.5)
    + 0.32*sin(lon*31.0+p*7.0)
    + 0.19*sin(lon*47.0-p*10.0)
    + 0.10*sin(lon*71.0+p*15.0);

//**************************
// POLAR RING
//**************************

/**
RADIAL DISTANCE AND GAUSSIAN RING
The polar-ring center is:  C = radius + strength·W(lon,p,phase) + 0.35M(lon,p)
The radial difference is:  d = p-C
The ring intensity is:  G = exp(-(d/w)²)
The ring is strongest when:  p = C
and decays as the radial distance from the center increases.
**/
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

//**************************
// POLAR RING BREAKING
//**************************

/**
NORMALIZATION AND SMOOTH THRESHOLD
First a weighted oscillatory field is constructed:  n = 0.45 sin(lon+phase) + 0.30 sin(2lon-1.3phase) + 0.20 sin(4lon+2.2phase) + 0.12 sin(7lon-phase)
Then it is transformed:  x = (n+0.08)/0.35
and passed through smoothstep:  S(x) = clamp(x,0,1)² [3 - 2clamp(x,0,1)]
Finally:  break = 0.20 + 0.80S(x)
Therefore:  0.20 ≤ break ≤ 1
The nonzero minimum prevents the ring from disappearing completely.
**/
function polar_break(lon,phase) =
    let(
        n =
              0.45*sin(lon+phase)
            + 0.30*sin(lon*2.0-phase*1.3)
            + 0.20*sin(lon*4.0+phase*2.2)
            + 0.12*sin(lon*7.0-phase)
    )
    0.20+0.80*smooth01((n+0.08)/0.35);

//**************************
// BROKEN POLAR RING
//**************************

/**
MULTIPLICATIVE MODULATION
The broken ring is:  B(lat,lon) = R(lat,lon) × Q(lon)
where R is the continuous ring field and Q is the break field.
Multiplication acts as an amplitude modulation:  large Q → strong ring
Multiplication acts as an amplitude modulation:  small Q → weak/broken ring.
**/
function broken_polar_ring(lat,lon,radius,width,phase,strength) =
    polar_ring(lat,lon,radius,width,phase,strength)
    * polar_break(lon,phase);

//**************************
// MAIN POLAR STRUCTURES
//**************************

/**
CONCENTRIC RADIAL STRUCTURES
Each band is a Gaussian-like annular field centered at a different polar radius.
The complete polar-band field is conceptually:  P(lat,lon) = Σ B_i(lat,lon)
**/
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

//**************************
// POLAR FILAMENTS
//**************************

/**
ELLIPTICALLY SCALED DISTANCE
A polar filament uses:  d = p - C(lon,p)
where:  C = radius + 0.65W(lon,p,phase) + 1.1 sin(frequency·lon + 3p + phase)
The resulting field is:  F = strength × exp(-(d/width)²)
The width parameter controls the radial thickness.
**/
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

//**************************
// FILAMENT FIELD
//**************************

/**
SUPERPOSITION OF POLAR FILAMENTS
The complete filament field is the sum:  F(lat,lon) = Σ strength_i exp[-((p-C_i)/width_i)²]
Different radii, frequencies, phases and strengths produce multiple interacting filamentary structures.
**/
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

//**************************
// POLAR CROSS-FLOW
//**************************

/**
NESTED NONLINEAR OSCILLATIONS
Four oscillatory fields are defined:  a = sin(3lon + 7p + 2sin(2lon))
Four oscillatory fields are defined:  b = sin(6lon - 4p + sin(5lon))
Four oscillatory fields are defined:  c = sin(13lon + 9p)
Four oscillatory fields are defined:  d = sin(23lon - 15p)
They are combined as:  C = 0.45a + 0.28b + 0.17c + 0.10d
The inner sine terms create phase modulation, producing more complex structure than a simple Fourier sum.
**/
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

//**************************
// POLAR VORTEX
//**************************

/**
LOCAL POLAR COORDINATES AND EUCLIDEAN DISTANCE
The vortex center is located at:  p = radius
The vortex center is located at:  lon = angle
The longitude displacement is wrapped:  Δlon = wrap_lon(lon-angle)
The local coordinates are:  x = Δlon cos(radius)
The local coordinates are:  y = p-radius
The Euclidean distance is:  d = √(x²+y²)
The vortex field is:  V = strength exp[-(d/size)²]
The cosine factor approximately compensates for longitudinal convergence toward the pole when constructing local distances.
**/
function polar_vortex(lat,lon,radius,angle,size,strength) =
    let(
        p=polar_distance(lat),
        delta_lon=wrap_lon(lon-angle),
        x=delta_lon*cos(radius),
        y=p-radius,
        distance=sqrt(x*x+y*y)
    )
    exp(-pow(distance/size,2))*strength;

//**************************
// VORTEX FIELD
//**************************

/**
SUPERPOSITION OF LOCALIZED RADIAL FIELDS
The complete vortex field is:  V_total(lat,lon) = Σ V_i(lat,lon)
Each vortex is:  V_i = s_i exp[-(d_i/σ_i)²]
Each vortex has its own radius, angular position, size and strength.
**/
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

//**************************
// POLAR REGION
//**************************

/**
SEQUENTIAL COLOR TRANSFORMATIONS
The polar color is generated through repeated interpolation:  C_(n+1) = mix(C_n,T_n,w_n)
Mathematically this means:  C_(n+1) = (1-w_n)C_n + w_n T_n
Each stage adds one mathematical field:  polar bands → filaments → cross-flow → vortices → small-scale mottling.
**/
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

        /**
        CENTRAL POLAR CAP
        cap = smoothstep(clamp((9-p)/6,0,1))
        This creates a smooth radial transition from the central polar region toward the surrounding atmosphere.
        **/
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

        /**
        THRESHOLDED FIELD
        The filament value is remapped:  x = (fil-0.15)/0.55
        followed by:  S(x) = smoothstep(x)
        This converts the filament field into a smooth weighting function.
        **/
        dark_fil=smooth01((fil-0.15)/0.55),
        c11=mix_color(c10,[0.28,0.25,0.22],dark_fil*0.27),

        /**
        INVERTED NORMALIZATION
        The bright filament weighting is:  x = (-fil+0.15)/0.55
        so that positive and negative portions of the filament field can influence opposite color directions.
        **/
        light_fil=smooth01((-fil+0.15)/0.55),
        c12=mix_color(c11,[0.94,0.94,0.89],light_fil*0.22),

        /**
        SIGN INVERSION AND THRESHOLDING
        Cross-flow is emphasized when it is sufficiently negative:  x = (-cross+0.10)/0.60
        followed by smoothstep.
        **/
        cross_dark=smooth01((-cross+0.10)/0.60),
        c13=mix_color(c12,[0.42,0.31,0.23],cross_dark*0.18),

        /**
        BOUNDED VORTEX MODULATION
        vort is first clamped:  V_b = clamp(vort,0,1)
        Then it controls interpolation strength.
        **/
        c14=mix_color(c13,[0.62,0.47,0.35],clamp01(vort)*0.20),

        /**
        SMALL-SCALE FOURIER TEXTURE
        The texture is:  M = 0.42 sin(23lon+8p) + 0.30 cos(37lon-11p) + 0.18 sin(59lon+17p) + 0.10 cos(91lon-23p)
        The weighted sum produces fine polar mottling.
        **/
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

//**************************
// SMALL ATMOSPHERIC STORMS
//**************************

/**
ELLIPTICAL DISTANCE
For a storm centered at:  (lat_c,lon_c)
The normalized coordinate differences are:  dx = wrapped(lon-lon_c)
The normalized coordinate differences are:  dy = lat-lat_c
The elliptical distance is:  d = √[(dy/a)² + (dx/b)²]
where:  a = lat_size
where:  b = lon_size
The storm intensity is:  S = smoothstep(1-d)
Therefore the storm has maximum intensity at its center and smoothly approaches zero outside its elliptical boundary.
**/
function storm(lat,lon,center_lat,center_lon,lat_size,lon_size) =
    let(
        dx=wrap_lon(lon-center_lon),
        dy=lat-center_lat,
        distance=sqrt(pow(dy/lat_size,2)+pow(dx/lon_size,2))
    )
    smooth01(1-distance);

/**
SUPERPOSITION OF ELLIPTICAL STORMS
The storm field is:  S_total(lat,lon) = Σ w_i S_i(lat,lon)
where w_i controls the contribution of each storm.
**/
function storm_field(lat,lon) =
      storm(lat,lon,32,-80,1.5,3.5)*0.40
    + storm(lat,lon,28,55,1.2,3.0)*0.32
    + storm(lat,lon,17,-130,1.4,3.8)*0.35
    + storm(lat,lon,12,105,1.2,3.2)*0.30
    + storm(lat,lon,-8,-100,1.3,3.4)*0.28
    + storm(lat,lon,-14,70,1.4,3.6)*0.30
    + storm(lat,lon,-28,-55,1.3,3.0)*0.34
    + storm(lat,lon,-34,120,1.5,3.8)*0.32;

//**************************
// GREAT RED SPOT
//**************************

/**
NORMALIZED ELLIPTICAL DISTANCE
The Great Red Spot is centered approximately at:  lat = -22°
The Great Red Spot is centered approximately at:  lon = -20°
The coordinate differences are:  dx = wrap(lon + 20)
The coordinate differences are:  dy = lat + 22
The normalized coordinates are:  x = dx/18
The normalized coordinates are:  y = dy/7.8
The radial elliptical distance is:  d = √(x²+y²)
This means the spot is wider longitudinally than latitudinally.
**/
function spot_distance(lat,lon) =
    let(
        dx=wrap_lon(lon+20),
        dy=lat+22,
        x=dx/18.0,
        y=dy/7.8
    )
    sqrt(x*x+y*y);

/**
RADIAL MASK
The spot mask is:  M = smoothstep(1-d)
where d is the normalized elliptical distance.
At the center:  d=0 → M=1
At d≥1:  M=0
The result creates a soft elliptical boundary.
**/
function spot_mask(lat,lon) =
    smooth01(1-spot_distance(lat,lon));

/**
MULTI-FREQUENCY TEXTURE
The spot texture is:  T = 0.42 + 0.23 sin(8lon+12lat) + 0.17 cos(17lon-9lat) + 0.10 sin(29lon+21lat) + 0.08 cos(47lon-32lat)
This combines multiple spatial frequencies to prevent the Great Red Spot from appearing as a perfectly uniform shape.
**/
function spot_texture(lat,lon) =
      0.42
    + 0.23*sin(lon*8.0+lat*12.0)
    + 0.17*cos(lon*17.0-lat*9.0)
    + 0.10*sin(lon*29.0+lat*21.0)
    + 0.08*cos(lon*47.0-lat*32.0);

/**
TEXTURE NORMALIZATION AND COLOR MIXING
The texture is bounded:  T_b = clamp(T,0,1)
The red color is interpolated between RED_DARK and RED_LIGHT according to T_b:  C_red = (1-T_b)RED_DARK + T_b RED_LIGHT
The final spot blending weight is:  w = 0.88M
The final color is:  C_final = (1-w)C_base + wC_red
**/
function apply_red_spot(lat,lon,base) =
    let(
        mask=spot_mask(lat,lon),
        texture=clamp01(spot_texture(lat,lon)),
        red_color=mix_color(RED_DARK,RED_LIGHT,texture)
    )
    mix_color(base,red_color,mask*0.88);

//**************************
// JUPITER COLOR
//**************************

/**
COMPOSITION OF SCALAR FIELDS
The final Jupiter color is constructed from several scalar fields:  D = dark-belt field
The final Jupiter color is constructed from several scalar fields:  B = bright-belt field
The final Jupiter color is constructed from several scalar fields:  F_d = dark filament field
The final Jupiter color is constructed from several scalar fields:  F_b = bright filament field
The final Jupiter color is constructed from several scalar fields:  N_L = large noise
The final Jupiter color is constructed from several scalar fields:  N_M = medium noise
The final Jupiter color is constructed from several scalar fields:  N_F = fine noise
The final Jupiter color is constructed from several scalar fields:  S = storm field
The final Jupiter color is constructed from several scalar fields:  P = polar field
Each field is normalized or scaled before influencing color.
**/
function jupiter_color(lat,lon) =
    let(
        dark=clamp01(dark_belts(lat,lon)*0.58),
        bright=clamp01(bright_belts(lat,lon)*0.52),
        dark_f=clamp01(dark_filaments(lat,lon)*0.52),
        bright_f=clamp01(bright_filaments(lat,lon)*0.38),
        large=noise_large(lat,lon),
        medium=noise_medium(lat,lon),
        fine=noise_fine(lat,lon),

        /**
        BASE COLOR INTERPOLATION
        C0 = (1-D)CREAM + D·BROWN
        **/
        c0=mix_color(CREAM,BROWN,dark),

        /**
        WARMING FIELD
        warm = clamp(0.65D - 0.12N_L,0,1)
        The negative large-scale noise term means darker large-scale regions can become warmer.
        **/
        warm=clamp01(dark*0.65+(-large)*0.12),
        c1=mix_color(c0,OCHRE,warm*0.35),

        /**
        DARK FILAMENT MODULATION
        C2 = mix(C1,DARK,0.42F_d)
        **/
        c2=mix_color(c1,DARK,dark_f*0.42),

        /**
        BRIGHT CLOUD MODULATION
        C3 = mix(C2,LIGHT,0.42B)
        **/
        c3=mix_color(c2,LIGHT,bright*0.42),

        /**
        BRIGHT FILAMENT MODULATION
        C4 = mix(C3,WHITE,0.52F_b)
        **/
        c4=mix_color(c3,WHITE,bright_f*0.52),

        /**
        MEDIUM-SCALE MOTTLE
        The weighting is:  w = clamp((-N_M+0.5)×0.11,0,1)
        **/
        c5=mix_color(c4,TAN,clamp01((-medium+0.5)*0.11)),

        /**
        FINE-SCALE SMOOTH THRESHOLD
        w = 0.13S((N_F-0.40)/0.60)
        **/
        c6=mix_color(c5,WHITE,smooth01((fine-0.40)/0.60)*0.13),

        /**
        STORM MODULATION
        w = 0.18 clamp(S,0,1)
        **/
        storms=storm_field(lat,lon),
        c7=mix_color(c6,[0.53,0.34,0.22],clamp01(storms)*0.18),

        /**
        POLAR BLENDING
        pb = polar_blend(lat)
        C8 = (1-pb)C7 + pb·C_polar
        This provides a smooth transition between the ordinary Jovian atmosphere and the polar model.
        **/
        pc=polar_color(lat,lon),
        pb=polar_blend(lat),
        c8=mix_color(c7,pc,pb)
    )
    apply_red_spot(lat,lon,c8);

//**************************
// SPHERICAL POSITION
//**************************

/**
SPHERICAL COORDINATES
A point on a sphere of radius r is parameterized by latitude φ and longitude λ:
x = r cos(φ) cos(λ)
y = r cos(φ) sin(λ)
z = r sin(φ)
The resulting point satisfies the sphere equation:  x² + y² + z² = r²
Because:  x²+y² = r²cos²φ(cos²λ+sin²λ) = r²cos²φ
And:  z² = r²sin²φ
Therefore:  x²+y²+z² = r²(cos²φ+sin²φ)
using the trigonometric identity:  sin²θ + cos²θ = 1
**/
function sphere_point(r,lat,lon) =
[
    r*cos(lat)*cos(lon),
    r*cos(lat)*sin(lon),
    r*sin(lat)
];

//**************************
// SURFACE PATCH
//**************************

/**
BILINEAR PARAMETER REGION
Each surface patch is bounded by two latitude values and two longitude values:  lat1 ≤ lat ≤ lat2
Each surface patch is bounded by two latitude values and two longitude values:  lon1 ≤ lon ≤ lon2
The color is sampled at the midpoint:  lat_c = (lat1+lat2)/2
The color is sampled at the midpoint:  lon_c = (lon1+lon2)/2
These are arithmetic means:  mean(a,b) = (a+b)/2
The four vertices are mapped from spherical coordinates into Cartesian coordinates using:  (x,y,z) = (R cos(lat)cos(lon), R cos(lat)sin(lon), R sin(lat))
**/
module patch(lat1,lat2,lon1,lon2)
{
    lat=(lat1+lat2)/2;
    lon=(lon1+lon2)/2;

    /**
    PIECEWISE SURFACE APPROXIMATION
    The curved sphere is approximated by many small planar quadrilateral faces.
    As LAT and LON increase:  Δlat = 180/LAT
    As LAT and LON increase:  Δlon = 360/LON
    decrease, so the piecewise planar approximation becomes finer.
    **/
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

//**************************
// COMPLETE JUPITER
//**************************

/**
UNIFORM PARAMETER DISCRETIZATION
For latitude index i:  lat1 = -90 + 180i/LAT
For latitude index i:  lat2 = -90 + 180(i+1)/LAT
Therefore:  Δlat = lat2-lat1 = 180/LAT
For longitude index j:  lon1 = -180 + 360j/LON
For longitude index j:  lon2 = -180 + 360(j+1)/LON
Therefore:  Δlon = lon2-lon1 = 360/LON
The complete surface consists of:  N_faces = LAT × LON quadrilateral patches.
For preview:  N_faces = 70 × 140 = 9,800
For final rendering:  N_faces = 170 × 340 = 57,800
Thus increasing LAT and LON increases spatial resolution while also increasing geometric complexity.
**/
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

//**************************
// FINAL MODEL
//**************************

/**
The model combines:
1. Bounded functions:  clamp(x,0,1) = max(0,min(1,x))
2. Smoothstep interpolation:  S(x) = 3x² - 2x³
3. Linear interpolation:  C(t) = (1-t)A + tB
4. Periodic angular wrapping:  lon ≡ lon + 360k
5. Trigonometric Fourier-like superposition:  F = Σ A_k sin(α_k lon + β_k lat + φ_k) + Σ B_k cos(γ_k lon + δ_k lat + ψ_k)
6. Gaussian-like radial falloff:  G(d) = exp(-(d/w)²)
7. Euclidean distance:  d = √(x²+y²)
8. Elliptical distance:  d = √[(x/a)²+(y/b)²]
9. Absolute-value polar distance:  p = 90 - |lat|
10. Spherical coordinate transformation:  x = R cos(lat)cos(lon), y = R cos(lat)sin(lon), z = R sin(lat)
11. Sphere equation:  x²+y²+z²=R²
12. Weighted field superposition:  F_total = Σ w_iF_i
13. Multiplicative amplitude modulation:  F_modulated = F × M
14. Multi-scale spatial synthesis:  large-scale + medium-scale + fine-scale fields
15. Piecewise geometric approximation:  sphere ≈ Σ small planar surface patches
**/
jupiter();