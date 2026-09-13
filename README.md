# Monde und Ringe des Jupiter, modelliert/simuliert mit OpenSCAD (Moons and Rings of Jupiter modelled/simulated in OpenSCAD)

This document describes the mathematical framework, physical concepts, geometric construction techniques, and overall architecture of the OpenSCAD codebase that models the Jovian system — Jupiter itself, its four ring families, its Galilean satellites, its inner shepherd moons, and its large population of irregular outer moons — together with associated physical phenomena such as the magnetosphere, plasma torus, radiation belts, aurorae, and tidal interaction lines.

---

## 1. Introduction

**Moons & Rings of Jupiter** is a static, parameterised 3-D model of the Jovian system constructed entirely in OpenSCAD — a script-based, CSG (Constructive Solid Geometry) solid-modelling application. The project spans five source files of increasing complexity and visual richness:

*   **`JovianSystem.scad`** — a compact overview scene that places all principal bodies in one coordinate space with simplified geometry.
*   **`ModelOfJupiter.scad`** — a high-fidelity, procedurally coloured model of Jupiter’s surface based on multi-scale trigonometric field synthesis.
*   **`DetailedModelOfJupiter.scad`** — the most feature-complete file, adding axial tilt, rotation axis, magnetic-field geometry, magnetosphere, plasma torus, radiation belts, aurorae, Roche limit, ring system, animated Galilean moon orbits under the Laplace resonance, and tidal interaction lines.
*   **`MajorMoonsOfJupiter.scad`** — Jupiter plus the four classes of named moons (inner, Galilean, and two irregular satellites) with parameterised orbit paths, labels, and orbital periods.
*   **`SmallerMoonsOfJupiter.scad`** — Jupiter plus a large catalogue of smaller and provisional moons, each with an individually constructed and inclined orbit path.

---

## 2. Components of the Jovian System

### 2.1 Jupiter
Jupiter is the largest planet in the Solar System, a gas giant with an equatorial radius of approximately $71,492\text{ km}$. In every file it is rendered as a sphere of model radius $R=40$ (arbitrary model units). The base model uses a colour-per-face tessellation strategy: the spherical surface is divided into $N_\phi\times N_\lambda$ latitude–longitude patches, each assigned a procedurally computed RGB colour that encodes the complex banded structure of the Jovian atmosphere.

**Key physical features modelled on the surface include:**
*   Equatorial belt–zone system (dark belts alternating with bright zones, spanning $\approx-35$ to $+35$ latitude).
*   Dark and bright filaments (narrow sub-belt cloud streams).
*   Multi-scale atmospheric noise (large, medium, fine scale).
*   Polar regions (concentric broken ring structures, filaments, crossflow, vortices, and a central polar cyclone).
*   Great Red Spot (GRS), an anticyclonic superstorm centred near $22^\circ\text{ S}$, $20^\circ\text{ W}$.
*   Small atmospheric storms scattered across mid-latitudes.
*   Auroral ovals (in `DetailedModelOfJupiter.scad`).
*   North–south brightness asymmetry (southern hemisphere rendered slightly darker).

### 2.2 Ring System
Jupiter possesses four concentric ring families, all modelled as thin, semi-transparent annular discs constructed via cylinder-difference operations or inclined orbit-ring cylinders.

**Table 1: Jupiter’s ring system as modelled.**
| Ring | Source body | Model inner $r$ | Model outer $r$ |
| :--- | :--- | :--- | :--- |
| Halo ring | — | $\approx1.05R$ | $\approx1.18R$ |
| Main ring | Metis, Adrastea | $\approx1.15R$ | $\approx1.26R$ |
| Amalthea gossamer | Amalthea | $\approx1.30R$ | $\approx1.52R$ |
| Thebe gossamer | Thebe | $\approx1.52R$ | $\approx1.82R$ |

In `JovianSystem.scad` the rings are modelled as flat cylinders with slight rotational tilts (to simulate finite ring-plane inclination), whereas in `DetailedModelOfJupiter.scad` and `MajorMoonsOfJupiter.scad` a `difference()` of two coaxial cylinders produces a proper annular disc.

### 2.3 Galilean Moons
The four Galilean satellites — Io, Europa, Ganymede, and Callisto — discovered by Galileo Galilei in 1610, are the largest of Jupiter’s moons. They are individually coloured to reflect their real surface chemistry.

**Table 2: Galilean moon properties as represented in the models.**
| Moon | Colour (hex approx.) | Surface character | Period (real) | Resonance |
| :--- | :--- | :--- | :--- | :--- |
| Io | `#FFD96D` (sulphurous yellow) | Volcanic sulphur plains | $1.769\text{ d}$ | $4$ |
| Europa | `#E2E3E3` (icy white) | Water-ice crust with lineae | $3.551\text{ d}$ | $2$ |
| Ganymede | `#8F8071` (grey-brown) | Mixed icy/rocky terrain | $7.155\text{ d}$ | $1$ |
| Callisto | `#B4A285` (dark brown) | Heavily cratered ice | $16.69\text{ d}$ | $0.427$ |

### 2.4 Inner (Shepherd) Moons
Four small inner moons orbit within or at the edge of the ring system: Metis, Adrastea (main-ring shepherd moons), Amalthea, and Thebe. They are represented as small spheres with their orbital inclinations encoded via the `rotate()` transform applied to each orbit path.

### 2.5 Irregular Outer Moons
`MajorMoonsOfJupiter.scad` models four irregular moons: Himalia, Elara (prograde Himalia group), and Pasiphae and Ananke (retrograde groups). Their retrograde orbits are indicated by positioning the moons on the negative-x side of Jupiter.

`SmallerMoonsOfJupiter.scad` extends this to include dozens of smaller and provisional moons, including Euporie, Eupheme, Mneme, Euanthe, Harpalyke, Orthosie, Helike, and several provisional designations (e.g. `S/2003 J 18`, `S/2010 J 2`, `S/2016 J 1`, `S/2021 J 3`). Each receives an individually inclined orbit ring constructed from the same segmented-polygon technique.

### 2.6 Physical Phenomena (`DetailedModelOfJupiter.scad`)
The detailed model renders several additional physical structures:
*   **Rotation axis:** A red rod and arrowhead showing Jupiter’s $3.13^\circ$ axial tilt, labelled with the rotation period $P=9\text{ h }56\text{ min}$.
*   **Equatorial and ecliptic planes:** Translucent horizontal discs defining the tilt geometry.
*   **Rotation arrow:** A partial rotate extrude arc indicating the prograde (westward) spin direction.
*   **Magnetic field lines:** Dipole field-line curves parameterised by L-shell value and azimuthal angle.
*   **Magnetosphere:** A sunward-compressed, tail-elongated oblate sphere.
*   **Io plasma torus:** A toroidal purple-red glow centred on Io’s orbit, produced by volcanic sulphur and oxygen ions.
*   **Radiation belts:** Three concentric toroidal intensity zones (inner, middle, outer) analogous to Jupiter’s Van Allen belts.
*   **3-D aurorae:** Conical glowing rings at both poles with a red outer edge, pulsed by the OpenSCAD animation parameter `$t`.
*   **Roche limit:** A dotted spherical surface at $r=1.75R$ (the approximate tidal disruption radius).
*   **Tidal interaction lines:** Dashed radial lines co-rotating with each Galilean moon.

---

## 3. Mathematical Framework

### 3.1 Utility Functions

#### 3.1.1 Clamping
All colour-weight computations are bounded to the interval $[0,1]$ using the clamp function:
$$clamp(x,0,1)=\max(0,\min(1,x))$$

#### 3.1.2 Cubic Smoothstep Interpolation
The smoothstep function produces a smooth transition between $0$ and $1$ with zero first derivatives at both endpoints, eliminating the sharp boundaries introduced by linear clamping:
$$S(x)=q^2(3-2q),q=clamp(x,0,1)$$
Expanding:
$$S(x)=3q^2-2q^3$$
Key properties:
$$S(0)=0,S(1)=1$$
$$S'(q)=6q(1-q),S'(0)=S'(1)=0$$

#### 3.1.3 Linear (Vector) Interpolation
Colour blending between two RGB vectors $a$ and $b$ by weight $t$:
$$mix(a,b,t)=a+q(b-a)=(1-q)a+qb,q=clamp(t,0,1)$$
Component-wise:
$$C_i(t)=a_i+q(b_i-a_i)$$

#### 3.1.4 Periodic Longitude Wrapping
Longitude $\lambda$ is periodic with period $360$. The wrap function maps any value back to $[-180,180]$:
$$wrap(\lambda)=\lambda-360(\lambda>180),\lambda+360(\lambda<-180),\lambda(\text{otherwise})$$

### 3.2 Spherical Coordinate System
Every surface point on Jupiter is parameterised by geodetic latitude $\phi\in[-90,90]$ and longitude $\lambda\in[-180,180)$. The Cartesian position of a point on a sphere of radius $R$ is:
$$P(\phi,\lambda)=(R\cos\phi\cos\lambda,R\cos\phi\sin\lambda,R\sin\phi)$$
This satisfies the sphere equation $x^2+y^2+z^2=R^2$ as can be verified:
$$x^2+y^2=R^2\cos^2\phi(\cos^2\lambda+\sin^2\lambda)=R^2\cos^2\phi$$
$$z^2=R^2\sin^2\phi$$
$$x^2+y^2+z^2=R^2(\cos^2\phi+\sin^2\phi)=R^2$$

### 3.3 Fourier-like Trigonometric Noise
Real atmospheric textures are approximated by finite trigonometric series (analogous to truncated Fourier expansions) evaluated at each surface point $(\phi,\lambda)$. Three scale levels are defined.

#### 3.3.1 Large-Scale Noise
$$N_L(\phi,\lambda)=0.42\sin(1.25\lambda+0.80\phi)+0.27\cos(2.70\lambda-1.10\phi)+0.16\sin(5.20\lambda+2.20\phi)+0.10\cos(8.70\lambda-3.10\phi)$$

#### 3.3.2 Medium-Scale Noise
$$N_M(\phi,\lambda)=0.42\sin(4.10\lambda+2.00\phi)+0.27\cos(8.70\lambda-3.70\phi)+0.17\sin(15.0\lambda+5.20\phi)+0.09\cos(27.0\lambda-8.50\phi)$$

#### 3.3.3 Fine-Scale Noise
$$N_F(\phi,\lambda)=0.38\sin(12.0\lambda+5.0\phi)+0.26\cos(23.0\lambda-8.0\phi)+0.18\sin(39.0\lambda+13.0\phi)+0.10\cos(67.0\lambda-21.0\phi)$$

All three fields have the general form of a finite Fourier-like series:
$$N(\phi,\lambda)=\sum_kA_kf_k(\alpha_k\lambda+\beta_k\phi+\phi_k),f_k\in\{\sin,\cos\}$$
Higher spatial frequencies $\alpha_k$ correspond to shorter wavelengths $\lambda_k\propto2\pi/\alpha_k$, generating progressively finer atmospheric texture.

### 3.4 Wind-Wave Displacement
Jupiter’s jet streams produce latitudinal oscillations of atmospheric bands. These are modelled by the wind-wave function, a four-term Fourier sum in longitude with a phase parameter $\phi$:
$$W(\lambda,\phi)=3.2\sin(1.35\lambda+\phi)+2.0\sin(2.70\lambda-0.70\phi)+1.15\sin(5.20\lambda+1.40\phi)+0.55\sin(9.70\lambda-1.90\phi)$$
Different frequencies interfere through superposition, producing an aperiodic-looking but fully deterministic longitudinal modulation.

### 3.5 Atmospheric Ribbon (Gaussian Band)
Each atmospheric belt or zone is a ribbon: a Gaussian-shaped intensity profile centred on a latitude that oscillates with longitude.

**Step 1 — Shifted centre:**
$$C'(\lambda)=C_0+A\sin(f\lambda+\phi)+0.35W(\lambda,\phi)$$
**Step 2 — Latitudinal displacement:**
$$\delta(\phi,\lambda)=\phi-C'(\lambda)$$
**Step 3 — Gaussian intensity:**
$$R(\phi,\lambda)=\exp[-(\delta/w)^2]$$
At $\delta=0$ the ribbon has its maximum intensity $R=1$; as $|\delta|\to\infty$, $R\to0$. The parameter $w$ controls the effective width of the atmospheric band.

The complete dark-belt field is a weighted superposition of $14$ individual ribbons:
$$D(\phi,\lambda)=\sum_{i=1}^{14}w_iR_i(\phi,\lambda)$$
Similarly for bright belts ($9$ ribbons), dark filaments ($12$ ribbons, narrow $w\approx0.3\text{–}0.42$), and bright filaments ($8$ ribbons).

### 3.6 Polar Geometry

#### 3.6.1 Polar Distance
The angular distance from the nearest pole is:
$$p(\phi)=90-|\phi|$$
Therefore $p=0$ at the poles ($\phi=\pm90$) and $p=90$ at the equator ($\phi=0$).

#### 3.6.2 Polar Blend
The transition between the equatorial colour model and the polar colour model is controlled by:
$$B_p(\phi)=S\left(clamp\left(\frac{52-p}{16},0,1\right)\right)$$
The blend begins near $p=52$ ($|\phi|\approx38$) and is complete at $p=36$ ($|\phi|\approx54$).

#### 3.6.3 Polar Warp
A multi-frequency perturbation field creates irregular polar ring geometry:
$$W_p(\lambda,p,\phi)=3.2\sin(\lambda+\phi)+1.9\sin(2\lambda-1.7\phi)+1.15\sin(3\lambda+0.7p+\phi)+0.75\sin(5\lambda-1.2p)+0.40\sin(9\lambda+...)$$

#### 3.6.4 Polar Microstructure
High-frequency oscillations add fine-grained texture inside the polar cap:
$$M_p(\lambda,p)=0.75\sin(11\lambda+3p)+0.48\sin(19\lambda-4.5p)+0.32\sin(31\lambda+7p)+0.19\sin(47\lambda-10p)+0.10\sin(71\lambda+...)$$

#### 3.6.5 Polar Ring
A Gaussian-shaped concentric ring in the polar cap, with a varying width:
$$C_r(\lambda,p,\phi,s)=r_0+sW_p(\lambda,p,\phi)+0.35M_p(\lambda,p)$$
$$w_v(\lambda,\phi)=w[0.72+0.28(0.5+0.5\sin(3\lambda+\phi))]$$
$$R_p(\phi,\lambda)=\exp\left[-\left(\frac{p-C_r}{w_v}\right)^2\right]$$

#### 3.6.6 Polar Ring Breaking
An oscillatory modulation field fragments the polar rings:
$$n(\lambda,\phi)=0.45\sin(\lambda+\phi)+0.30\sin(2\lambda-1.3\phi)+0.20\sin(4\lambda+2.2\phi)+0.12\sin(7\lambda-\phi)$$
$$Q(\lambda,\phi)=0.20+0.80S\left(clamp\left(\frac{n+0.08}{0.35},0,1\right)\right)$$
The broken ring field is then the pointwise product:
$$B_r(\phi,\lambda)=R_p(\phi,\lambda)\cdot Q(\lambda,\phi)$$
Since $Q\ge0.20$, the ring never vanishes completely. Nine concentric broken rings ($r_0=8,13,17.5,22.5,27.5,33,38,43,47.5$) build up the polar band field.

#### 3.6.7 Polar Vortices
Individual polar cyclones are localised using an approximately Euclidean distance in polar coordinates. For a vortex centred at polar radius $r_0$ and longitude $\lambda_0$:
$$\Delta\lambda=wrap(\lambda-\lambda_0)$$
$$x_v=\Delta\lambda\cos r_0$$
$$y_v=p-r_0$$
$$d_v=\sqrt{x_v^2+y_v^2}$$
$$V(\phi,\lambda)=s\exp\left[-\left(\frac{d_v}{\sigma}\right)^2\right]$$
The cosine factor approximately accounts for the convergence of meridians near the pole. A total of $22$ vortices are superimposed for the polar vortex field.

#### 3.6.8 Polar Crossflow
Nested non-linear oscillations simulate the transverse atmospheric flow across the polar cap:
$$a=\sin(3\lambda+7p+2\sin(2\lambda))$$
$$b=\sin(6\lambda-4p+\sin(5\lambda))$$
$$c=\sin(13\lambda+9p),d=\sin(23\lambda-15p)$$
$$C_f(\phi,\lambda)=0.45a+0.28b+0.17c+0.10d$$
The inner sine terms in $a$ and $b$ introduce phase modulation, producing more complex structure than a plain Fourier sum.

### 3.7 Storm Modelling
Small atmospheric storms use a normalised elliptical distance metric:
$$d_s=\sqrt{\left(\frac{\phi-\phi_c}{a}\right)^2+\left(\frac{wrap(\lambda-\lambda_c)}{b}\right)^2}$$
$$S_s(\phi,\lambda)=smooth(1-d_s)$$
The storm field is maximum at its centre ($d_s=0$) and decays to zero for $d_s\ge1$. Eight storms are superimposed. Storms are wider in longitude than latitude ($b>a$), reflecting the real elongation of Jovian convective storms.

### 3.8 Great Red Spot
The Great Red Spot (GRS) is a long-lived anticyclonic storm centred at approximately $22^\circ\text{ S}$, $20^\circ\text{ W}$. It is modelled as an ellipse wider in longitude than latitude:
$$d_{GRS}=\sqrt{\left(\frac{wrap(\lambda+20)}{18}\right)^2+\left(\frac{\phi+22}{7.8}\right)^2}$$
$$M_{GRS}(\phi,\lambda)=smooth(1-d_{GRS})$$
Internal texture is provided by a multi-frequency field:
$$T_{GRS}=0.42+0.23\sin(8\lambda+12\phi)+0.17\cos(17\lambda-9\phi)+0.10\sin(29\lambda+21\phi)+0.08\cos(47\lambda-32\phi)$$
The GRS colour interpolates from a dark reddish-brown to a lighter red using $T_{GRS}$ as the interpolation weight, then blends over the base atmosphere with weight $0.88M_{GRS}$.

### 3.9 Jupiter Surface Colour Synthesis Pipeline
The complete colour at any point $(\phi,\lambda)$ is computed by a sequential linear-interpolation chain, building up from a cream base through eleven stages:
1. $D=clamp(0.58D),B=clamp(0.52B),D_f=clamp(0.52D_f),B_f=clamp(0.38B_f)$
2. $C_0=mix(\text{CREAM},\text{BROWN},D)$
3. $w_{warm}=clamp(0.65D-0.12N_L),C_1=mix(C_0,\text{OCHRE},0.35w_{warm})$
4. $C_2=mix(C_1,\text{DARK},0.42D_f)$
5. $C_3=mix(C_2,\text{LIGHT},0.42B)$
6. $C_4=mix(C_3,\text{WHITE},0.52B_f)$
7. $C_5=mix(C_4,\text{TAN},clamp((-N_M+0.5)\cdot0.11))$
8. $C_6=mix(C_5,\text{WHITE},0.13S((N_F-0.40)/0.60))$
9. $C_7=mix(C_6,[0.53,0.34,0.22],0.18clamp(S_{storms}))$
10. $C_8=mix(C_7,C_{polar},B_p)$
11. $C_{final}=\text{applyGRS}(C_8)$

`DetailedModelOfJupiter.scad` adds a twelfth step for a latitudinal temperature-zone gradient and additional polar features (aurorae, cyclones, turbulence, spiral arms).

### 3.10 Orbit Construction Geometry
Orbit paths for moons are approximated as regular polygons. For a circular orbit of model radius $r$ approximated by $N$ line segments:
$$\text{Circumference: }C=2\pi r$$
$$\text{Segment length: }\ell=\frac{C}{N}=\frac{2\pi r}{N}$$
$$\text{Angular step: }\Delta\alpha=\frac{360}{N}$$
Each segment is a small rectangle of width $\ell$ and thickness $t$, rotated by $i\Delta\alpha$ and translated to radius $r$. At $N=180\text{–}500$ segments the visual result is indistinguishable from a smooth circle.

---

## 4. Physics Concepts

### 4.1 Jovian Atmospheric Banding
Jupiter’s visible surface consists of alternating dark belts and bright zones caused by large-scale convective circulation cells coupled with the planet’s rapid rotation ($P\approx9.9\text{ h}$). The Coriolis force produces east–west zonal jets, confining convective upwelling into the bright zones and downwelling into the dark belts. The model encodes this as $14$ dark and $9$ bright ribbon fields.

### 4.2 Axial Tilt
Jupiter’s rotational axis is tilted by:
$$\epsilon=3.13^\circ$$
relative to its orbital (ecliptic) plane. This is among the smallest axial tilts in the Solar System. In `DetailedModelOfJupiter.scad` all co-rotating components (surface, rings, moons, magnetic field) are wrapped in a `rotate([AXIAL_TILT,0,0])` transform, while the magnetosphere boundary and Roche limit are rendered in the ecliptic frame (untilted).

### 4.3 Orbital Mechanics and Kepler’s Laws
The orbital radius, angular velocity, and period of each moon follow Kepler’s third law:
$$T^2=\frac{4\pi^2}{GM_J}a^3$$
where $G$ is the gravitational constant, $M_J$ the mass of Jupiter, $a$ the semi-major axis, and $T$ the orbital period. The model stores real orbital periods as text labels (e.g. $T_{Io}=1.77\text{ d}$, $T_{Eu}=3.55\text{ d}$, etc.) and animated orbital angles are derived from the OpenSCAD parameter `$t`.

### 4.4 Laplace Mean-Motion Resonance
The three innermost Galilean moons satisfy the Laplace resonance, a near-exact commensurability of mean orbital angular velocities:
$$n_{Io}:n_{Eu}:n_{Ga}=4:2:1$$
or equivalently:
$$\frac{1}{T_{Io}}-\frac{3}{T_{Eu}}+\frac{2}{T_{Ga}}=0$$
In `DetailedModelOfJupiter.scad` the animated orbital angles encode this exactly:
$$\alpha_{Io}=4\cdot360\cdot\$t,\alpha_{Eu}=2\cdot360\cdot\$t,\alpha_{Ga}=1\cdot360\cdot\$t$$
The resonance maintains eccentricity in Io’s and Europa’s orbits via repeated gravitational pumping, which drives the intense tidal heating responsible for Io’s volcanism.

### 4.5 Magnetic Dipole Field
Jupiter has the strongest planetary magnetic field in the Solar System. To first approximation, the external field is that of a magnetic dipole whose field lines satisfy:
$$r=LR_J\sin^2\theta$$
where $r$ is the radial distance from Jupiter’s centre, $\theta$ is the colatitude (polar angle), $L$ is the L-shell (McIlwain) parameter (dimensionless, equal to the equatorial crossing distance in units of $R_J$), and $R_J$ is Jupiter’s radius.

Converting to Cartesian coordinates for a field line of L-shell $L$ at azimuthal angle $\phi$:
$$x=LR_J\sin^2\theta\sin\theta\cos\phi$$
$$y=LR_J\sin^2\theta\sin\theta\sin\phi$$
$$z=LR_J\sin^2\theta\cos\theta$$
In the model, field lines are drawn at $L\in\{2.0,3.2,4.8\}$ and $\phi\in\{0,60,...,300\}$, with $\theta$ varying from $8$ to $172$. A magnetotail is separately rendered as a series of curved polylines swept in the anti-sunward ($-x$) direction.

### 4.6 Roche Limit
Inside the Roche limit, tidal forces from Jupiter overcome the self-gravity of any satellite, preventing accretion or tearing apart existing bodies. The Roche limit for a fluid satellite is:
$$d_R=2.44R_J\left(\frac{\rho_J}{\rho_m}\right)^{1/3}$$
where $\rho_J$ and $\rho_m$ are the densities of Jupiter and the satellite, respectively. For an approximate rigid-body Roche radius the factor $2.44$ is replaced by $\sim1.26$. The model places the Roche limit at:
$$r_R=1.75R\text{ (model units)}$$
which corresponds to $\approx70,000\text{ km}$ at real scale, consistent with Jupiter’s observed ring system lying mostly inside this boundary.

### 4.7 Io Plasma Torus
Io’s intense tidal heating drives volcanic plumes that inject approximately $10^3\text{ kg/s}$ of sulphur dioxide and sulphur into space. These molecules are ionised by solar UV and Jupiter’s magnetosphere, forming a dense donut-shaped plasma torus co-orbiting with Io at $r\approx5.9R_J$.

In the model, the torus is rendered as a rotate extrude of an elliptically scaled circle:
$$\text{Torus surface: }P(\theta,\phi)=((r_0+a\cos\phi)\cos\theta,(r_0+a\cos\phi)\sin\theta,ca\sin\phi)$$
where $r_0$ is the torus major radius (set to `ORBIT_IO=80` model units), $a$ is the tube radius ($=9$), and $c\approx0.35$ is a flattening factor reflecting the torus’s thinness relative to its diameter.

### 4.8 Radiation Belts
Jupiter’s magnetosphere traps energetic charged particles (electrons and protons) in donut-shaped belts analogous to Earth’s Van Allen belts but far more intense. Three nested belt zones are rendered at scaled radii:
$$r_{inner}=1.40R$$
$$r_{middle}=1.85R$$
$$r_{outer}=2.35R$$
Each is an elliptically compressed torus (flattening $c\approx0.30\text{–}0.40$), reflecting the belt’s confinement to the magnetic equatorial plane.

### 4.9 Auroral Phenomena
Jovian aurorae are powered primarily by the co-rotation breakdown mechanism: as the magnetosphere extends beyond its co-rotation radius, field-aligned currents accelerate electrons into the polar atmosphere, producing ultraviolet and infrared emission at high latitudes. Secondary contributions come from Io’s flux tube footprint.

The auroral oval is centred $\approx15\text{–}20^\circ$ from the pole (polar distance $p\approx17$) and rendered as a Gaussian ribbon:
$$A_{oval}(\phi,\lambda)=\exp\left[-\left(\frac{p-C_a(\lambda)}{w_a}\right)^2\right]$$
where $C_a(\lambda)=17+2.5\sin(3\lambda+1.2)+1.5\sin(5\lambda-0.8)+0.8\sin(8\lambda+2.5)$.

In the 3-D version (`DetailedModelOfJupiter.scad`), aurorae are rendered as conical frustums above each pole with a teal main glow overlaid by a thin red outer ring produced by `difference()` of two coaxial cylinders.

### 4.10 Tidal Interaction
Tidal interaction between Jupiter and its moons results in:
*   Tidal heating of Io (maintaining its volcanism), Europa (maintaining its subsurface ocean), and to a lesser degree Ganymede.
*   Tidal locking of all Galilean moons (same face always pointing toward Jupiter).
*   Gradual orbital evolution of the system.

In the model, tidal interaction is visualised as dashed radial lines (tidal dash) connecting Jupiter to each Galilean moon, co-rotating with each satellite’s animated orbital angle.

### 4.11 Orbital Inclination of Irregular Moons
Irregular moons are thought to be captured small bodies. Prograde irregular moons (Himalia group) have inclinations $27\text{–}29^\circ$; retrograde groups (Pasiphae, Ananke, Carme, Ananke) have inclinations $145\text{–}165^\circ$ to the ecliptic. In the models, the orbit rings for each irregular moon are rotated by their respective inclination angles using the `rotate(inclination)` transform.

---

## 5. Model Structure and Architecture

### 5.1 `JovianSystem.scad`
The simplest file. It provides a top-level overview with:
*   One global scale factor `SCALE=0.02`.
*   Pre-defined orbital radii for 8 moons and 4 rings as named constants.
*   Named colour constants for all bodies (RGB triples, normalised to $[0,1]$).
*   Five primitive modules: `orbit_ring_visible`, `orbit_ring`, `moon`, `label`, and `jupiter`.
*   A top-level `jovian_system()` module that assembles all parts.

Moons are placed by `rotate([0,\theta,0])` followed by `translate([r,0,0])`, scattering each moon in a distinct viewing direction ($\theta=30,45,60,...$).

### 5.2 `ModelOfJupiter.scad`
Dedicated to the surface model of Jupiter alone. Architecture:
1.  Global parameters: `R=40`, `LAT`, `LON` (adaptive to preview/render mode).
2.  Colour constants: 16 named RGB vectors covering the palette from `DARK` to `WHITE`, `RED_DARK` to `RED_LIGHT`.
3.  Utility functions: `clamp01`, `smooth01`, `mix_color`, `wrap_lon`.
4.  Noise functions: `noise_large`, `noise_medium`, `noise_fine`.
5.  Belt/filament functions: `wind_wave`, `ribbon`, `dark_belts`, `bright_belts`, `dark_filaments`, `bright_filaments`.
6.  Polar functions: `polar_distance`, `polar_blend`, `polar_warp`, `polar_micro`, `polar_ring`, `polar_break`, `broken_polar_ring`, `polar_band_1–9`, `polar_filament`, `polar_filament_field`, `polar_crossflow`, `polar_vortex`, `polar_vortices`, `polar_color`.
7.  Storm functions: `storm`, `storm_field`.
8.  GRS functions: `spot_distance`, `spot_mask`, `spot_texture`, `apply_red_spot`.
9.  Integration: `jupiter_color(lat,lon)` — the master colour function.
10. Geometry: `sphere_point`, `patch`, `jupiter` (the tessellated sphere module).

#### 5.2.1 Piecewise Spherical Surface Approximation
The sphere is tessellated as $N_\phi\times N_\lambda$ quadrilateral patches:
$$\phi_1(i)=-90+\frac{180i}{N_\phi},\phi_2(i)=-90+\frac{180(i+1)}{N_\phi}$$
$$\lambda_1(j)=-180+\frac{360j}{N_\lambda},\lambda_2(j)=-180+\frac{360(j+1)}{N_\lambda}$$
Each patch is a polyhedron with four vertices and one quadrilateral face, coloured by evaluating `jupiter_color` at the patch centroid $(\bar{\phi},\bar{\lambda})$:
$$\bar{\phi}=\frac{\phi_1+\phi_2}{2},\bar{\lambda}=\frac{\lambda_1+\lambda_2}{2}$$
Resolution is set adaptively:

**Table 3: Tessellation resolution.**
| Mode | $N_\phi$ | $N_\lambda$ | Total faces |
| :--- | :--- | :--- | :--- |
| Preview | $70$ | $140$ | $9,800$ |
| Render | $170$ | $340$ | $57,800$ |

### 5.3 `DetailedModelOfJupiter.scad`
This file inherits all functions from `ModelOfJupiter.scad` and adds:
1.  Feature flags (boolean variables): `show_rotation_axis`, `show_magnetic_field`, `show_plasma_torus`, etc.
2.  Axial tilt: `AXIAL_TILT=3.13`.
3.  Orbital radii: `ORBIT_IO=80`, `ORBIT_EUROPA=110`, `ORBIT_GANYMEDE=150`, `ORBIT_CALLISTO=200`.
4.  Additional polar functions (augmenting the base polar model): `auroral_oval`, `auroral_edge`, `auroral_bands`, `central_cyclone`, `spiral_arms`, `polar_turbulence`, `ns_cyclones`.
5.  Geometry modules: `rotation_axis_mod`, `equatorial_plane_mod`, `ecliptic_plane_mod`, `rotation_arrow_mod`, `magnetic_field_mod`, `magnetosphere_mod`, `plasma_torus_mod`, `radiation_belts_mod`, `aurorae_3d_mod`, `roche_limit_mod`, `rings_mod`, `galilean_moons_mod`, `tidal_lines_mod`.
6.  Assembly: `jupiter_system()`.

#### 5.3.1 Magnetic Field Line Construction
The function `dipole_pts(L, \phi, n)` generates a list of Cartesian points along a single dipole field line:
```openscad
function dipole_pts(Lsh, phi, n=36) = [
  for(i=[0:n])
    let(
      theta = 8 + i*164/n,
      rr = Lsh * R * pow(sin(theta), 2),
      x = rr * sin(theta) * cos(phi),
      y = rr * sin(theta) * sin(phi),
      z = rr * cos(theta)
    ) [x, y, z]
];
```
The points are connected by `polyline()`, which creates a chain of `hull()` pairs between consecutive small spheres.

#### 5.3.2 Ring System Construction
Rings are annular discs produced by differencing two coaxial cylinders:
```openscad
module ring_torus(ir, or, h) {
  difference() {
    cylinder(h=h, r=or, center=true, $fn=64);
    cylinder(h=h+1, r=ir, center=true, $fn=64);
  }
}
```

#### 5.3.3 Plasma Torus
```openscad
module plasma_torus_mod() {
  color([0.75,0.25,0.55,0.14])
  rotate_extrude($fn=64)
  translate([ORBIT_IO,0,0])
  scale([1,0.35])
  circle(r=9,$fn=16);
}
```
The `scale([1,0.35])` compresses the circular cross-section vertically, producing the characteristically flat torus shape.

#### 5.3.4 3-D Aurorae
The north auroral glow is a cone rendered as a cylinder (with non-zero base radius), while the red outer edge is a thin annular cone produced by differencing two concentric cylinders:
```openscad
// north red edge
difference() {
  cylinder(h=R*0.14, r1=R*0.46, r2=R*0.34, $fn=FN);
  cylinder(h=R*0.14+0.1, r1=R*0.38, r2=R*0.26, $fn=FN);
}
```

### 5.4 `MajorMoonsOfJupiter.scad`
This file contains a complete Jupiter surface model plus a generic `moon()` module that encapsulates:
*   An orbit ring (via the `orbit()` module in 2-D, subsequently extruded or rendered as a flat polygon chain).
*   A coloured sphere at the specified position.
*   A dual-line label (moon name + orbital period).

The orbit construction algorithm is encapsulated in a module that iterates $i$ from $0$ to $N-1$, rotating and translating a small rectangle at each step.

**Moons included:** Metis ($0.30\text{ d}$), Adrastea ($0.30\text{ d}$), Amalthea ($0.50\text{ d}$), Thebe ($0.67\text{ d}$), Io ($1.77\text{ d}$), Europa ($3.55\text{ d}$), Ganymede ($7.15\text{ d}$), Callisto ($16.69\text{ d}$), Himalia ($250.6\text{ d}$), Elara ($259.6\text{ d}$), Pasiphae ($743.6\text{ d}$), Ananke ($629.8\text{ d}$).

### 5.5 `SmallerMoonsOfJupiter.scad`
The most expansive catalogue. Structure:
*   Full Jupiter surface model (same functions, compacted style).
*   Each moon is rendered as a standalone `sphere()`, positioned by `translate([r,offset_y,offset_z])`, giving each moon a slightly distinct radial and out-of-plane position for visual clarity.
*   Each moon’s orbit is defined by its own named module (`orbitOfMoon()`), using the same circumference/segment formula with moon-specific inclination applied via `rotate([inclination,0,0])`.
*   Distinct colours are assigned to each moon’s sphere, distinguishing bodies that share similar orbital radii.

**Moons included (partial list):** Euporie, `S/2003 J 18`, Eupheme, `S/2021 J 3`, `S/2010 J 2`, `S/2016 J 1`, Mneme, Euanthe, `S/2003 J 16`, Harpalyke, Orthosie, Helike, and many more.

---

## 6. Geometric Construction Techniques Summary

**Table 4: OpenSCAD geometric primitives and constructions used.**
| Feature | Primitive / operation | Notes |
| :--- | :--- | :--- |
| Jupiter surface | `polyhedron` ($\times N_\phi N_\lambda$) | Quadrilateral patches; colour per face |
| Moon spheres | `sphere(r=radius)` | Colour via `color()` |
| Orbit paths | Segmented square chains | $N=180\text{–}500$ segments; circumference formula |
| Ring discs | `difference(cylinder, cylinder)` | Annular cross-section |
| Halo/main ring (simple) | `cylinder(rotated)` | Tilted slightly for viewing |
| Plasma torus | `rotate_extrude(circle scaled)` | Cross-section |
| Radiation belts | `rotate_extrude(circle Elliptical)` | scaling |
| Rotation arrow | `rotate_extrude` arc + cone | Partial angle extrusion |
| Rotation axis | `cylinder` + cones | Arrowheads at both poles |
| Magnetic field lines | `hull(sphere, sphere)` chain | `polyline` helper |
| Magnetosphere | `scale` sphere `[2.8, 1, 1]` | prolate in x |
| 3-D aurorae | `cylinder` + `difference(cylinder)` | Cone + annular ring |
| Roche limit | `rotate_extrude(circle)` (dotted) | Six great-circle traces |
| Tidal lines | Radial `hull(sphere)` dashes | Co-rotating with moons |
| Labels | `linear_extrude(text)` | 3-D extruded glyphs |

---

## 7. Equation Reference Table

**Table 5: Summary of all mathematical equations used in the project.**

| Concept | Equation |
| :--- | :--- |
| Clamp | $$clamp(x,0,1)=\max(0,\min(1,x))$$ |
| Smoothstep | $$S(x)=q^2(3-2q),q=clamp(x,0,1)$$ |
| Linear interp. | $$mix(a,b,t)=a+q(b-a)$$ |
| Angle wrap | $$wrap(\lambda): \lambda\pm360$$ |
| Spherical coords | $$(x,y,z)=(R\cos\phi\cos\lambda,R\cos\phi\sin\lambda,R\sin\phi)$$ |
| Sphere eqn | $$x^2+y^2+z^2=R^2$$ |
| Fourier noise | $$N=\sum_kA_kf_k(\alpha_k\lambda+\beta_k\phi+\phi_k)$$ |
| Wind wave | $$W(\lambda,\phi)=\sum_{k=1}^4A_k\sin(\alpha_k\lambda+\beta_k\phi)$$ |
| Ribbon centre | $$C'(\lambda)=C_0+A\sin(f\lambda+\phi)+0.35W(\lambda,\phi)$$ |
| Ribbon Gaussian | $$R=\exp[-(\delta/w)^2],\delta=\phi-C'$$ |
| Polar distance | $$p=90-|\phi|$$ |
| Polar blend | $$B_p=S(clamp((52-p)/16,0,1))$$ |
| Polar ring | $$R_p=\exp[-(p-C_r)^2/w_v^2]$$ |
| Ring break | $$B_r=R_p\cdot Q(\lambda,\phi),Q\in[0.20,1.00]$$ |
| Polar vortex | $$V=s\exp[-(d_v/\sigma)^2],d_v=\sqrt{x_v^2+y_v^2}$$ |
| Storm distance | $$d_s=\sqrt{((\phi-\phi_c)/a)^2+((\lambda-\lambda_c)/b)^2}$$ |
| GRS ellipse | $$d_{GRS}=\sqrt{(\Delta\lambda/18)^2+(\Delta\phi/7.8)^2}$$ |
| Orbit circ. | $$C=2\pi r$$ |
| Segment length | $$\ell=2\pi r/N$$ |
| Angular step | $$\Delta\alpha=360/N$$ |
| Kepler III | $$T^2=\frac{4\pi^2}{GM_J}a^3$$ |
| Laplace res. | $$n_{Io}:n_{Eu}:n_{Ga}=4:2:1$$ |
| Dipole L-shell | $$r=LR_J\sin^2\theta$$ |
| Roche limit | $$d_R=2.44R_J(\rho_J/\rho_m)^{1/3}$$ |
| Torus surface | $$(x,y,z)=((r_0+a\cos\phi)\cos\theta,(r_0+a\cos\phi)\sin\theta,ca\sin\phi)$$ |
| Axial tilt | $$\epsilon=3.13^\circ$$ |

---

## 8. Conclusion

The **Moons & Rings of Jupiter** OpenSCAD project demonstrates that a substantial body of planetary science can be encoded in pure procedural geometry without any simulation engine or texture-mapping infrastructure. The key mathematical tools are:

*   **Trigonometric Fourier-like series** for multi-scale atmospheric texture synthesis (belts, zones, filaments, polar structures).
*   **Gaussian functions** as spatial basis functions for atmospheric ribbons, polar rings, storms, and vortices.
*   **Cubic smoothstep** for artefact-free transitions between atmospheric zones.
*   **Linear colour interpolation** as the assembly mechanism for a multi-stage colour synthesis pipeline.
*   **Spherical coordinate parameterisation** enabling all surface features to be expressed as functions of latitude and longitude.
*   **Elliptical distance metrics** for correctly shaped storm ellipses and the Great Red Spot.

The physics modelled spans orbital mechanics, mean-motion resonances, planetary magnetic dipole fields, tidal interactions, plasma physics (Io torus), radiation belt geometry, and auroral emission patterns — all represented as static geometric approximations faithful to the real Jovian system at the level of visual plausibility.

The five-file hierarchy allows the project to scale gracefully from a quick visual overview (`JovianSystem.scad`) to a richly annotated and physically annotated full system view (`DetailedModelOfJupiter.scad`), demonstrating that OpenSCAD’s functional programming paradigm and parametric geometry primitives are well-suited to scientific visualisation tasks of this complexity.
