# Monde und Ringe des Jupiter, modelliert/simuliert mit OpenSCAD (Moons and Rings of Jupiter modelled/simulated in OpenSCAD)

## Overview
**Moons & Rings of Jupiter** is a static, parameterised 3-D model of the Jovian system constructed entirely in OpenSCAD.

---

## 1. Introduction & File Structure

The project is divided into five hierarchical files:

| File | Description |
| :--- | :--- |
| **`JovianSystem.scad`** | A compact overview scene placing all principal bodies in one coordinate space with simplified geometry. |
| **`ModelOfJupiter.scad`** | A high-fidelity, procedurally coloured model of Jupiter’s surface based on multi-scale trigonometric field synthesis. |
| **`DetailedModelOfJupiter.scad`** | The most feature-complete file. Adds axial tilt, rotation axis, magnetic-field geometry, magnetosphere, plasma torus, radiation belts, aurorae, Roche limit, ring system, animated Galilean moon orbits (Laplace resonance), and tidal interaction lines. |
| **`MajorMoonsOfJupiter.scad`** | Jupiter plus the four classes of named moons (inner, Galilean, and two irregular satellites) with parameterised orbit paths, labels, and orbital periods. |
| **`SmallerMoonsOfJupiter.scad`** | Jupiter plus a large catalogue of smaller and provisional moons, each with an individually constructed and inclined orbit path. |

---

## 2. Components of the Jovian System

### 2.1 Jupiter
Jupiter is rendered as a sphere of model radius $R = 40$ (arbitrary model units). The base model uses a **colour-per-face tessellation strategy**: the spherical surface is divided into $N_\phi \times N_\lambda$ latitude–longitude patches, each assigned a procedurally computed RGB colour.

**Key physical features modelled:**
*   Equatorial belt–zone system (dark belts alternating with bright zones).
*   Dark and bright filaments (narrow sub-belt cloud streams).
*   Multi-scale atmospheric noise (large, medium, fine scale).
*   Polar regions (concentric broken ring structures, filaments, crossflow, vortices, central polar cyclone).
*   **Great Red Spot (GRS)**: An anticyclonic superstorm centred near $22^\circ$ S, $20^\circ$ W.
*   Auroral ovals & North–south brightness asymmetry.

### 2.2 Ring System
Jupiter possesses four concentric ring families, modelled as thin, semi-transparent annular discs.

| Ring | Source Body | Model Inner $r$ | Model Outer $r$ |
| :--- | :--- | :--- | :--- |
| **Halo ring** | — | $\approx 1.05R$ | $\approx 1.18R$ |
| **Main ring** | Metis, Adrastea | $\approx 1.15R$ | $\approx 1.26R$ |
| **Amalthea gossamer** | Amalthea | $\approx 1.30R$ | $\approx 1.52R$ |
| **Thebe gossamer** | Thebe | $\approx 1.52R$ | $\approx 1.82R$ |

### 2.3 Galilean Moons
Individually coloured to reflect their real surface chemistry:

| Moon | Colour (Hex) | Surface Character | Period (Real) | Resonance |
| :--- | :--- | :--- | :--- | :--- |
| **Io** | `#FFD96D` (Sulphurous yellow) | Volcanic sulphur plains | 1.769 d | 4 |
| **Europa** | `#E2E3E3` (Icy white) | Water-ice crust with lineae | 3.551 d | 2 |
| **Ganymede** | `#8F8071` (Grey-brown) | Mixed icy/rocky terrain | 7.155 d | 1 |
| **Callisto** | `#B4A285` (Dark brown) | Heavily cratered ice | 16.69 d | 0.427 |

### 2.4 Inner & Irregular Moons
*   **Inner (Shepherd) Moons:** Metis, Adrastea, Amalthea, and Thebe. Represented as small spheres with orbital inclinations encoded via `rotate()`.
*   **Irregular Outer Moons:** Includes Himalia, Elara (prograde), Pasiphae, Ananke (retrograde), and dozens of smaller/provisional moons (e.g., S/2003 J 18, S/2021 J 3). Retrograde orbits are indicated by positioning moons on the negative-x side or via specific inclination angles.

### 2.5 Physical Phenomena (Detailed Model)
*   **Rotation Axis:** Red rod/arrowhead showing $3.13^\circ$ axial tilt.
*   **Magnetic Field Lines:** Dipole field-line curves parameterised by L-shell value.
*   **Magnetosphere:** Sunward-compressed, tail-elongated oblate sphere.
*   **Io Plasma Torus:** Toroidal purple-red glow centred on Io’s orbit.
*   **Radiation Belts:** Three concentric toroidal intensity zones.
*   **3-D Aurorae:** Conical glowing rings at both poles, pulsed by the `$t` animation parameter.
*   **Roche Limit:** Dotted spherical surface at $r = 1.75R$.
*   **Tidal Interaction Lines:** Dashed radial lines co-rotating with Galilean moons.

---

## 3. Mathematical Framework

### 3.1 Utility Functions
*   **Clamping:** $\text{clamp}(x, 0, 1) = \max(0, \min(1, x))$
*   **Cubic Smoothstep:** $S(x) = q^2(3 - 2q)$, where $q = \text{clamp}(x, 0, 1)$
*   **Linear Interpolation:** $\text{mix}(a, b, t) = a + q(b - a)$
*   **Longitude Wrapping:** Maps any value to $[-180, 180]$.

### 3.2 Spherical Coordinate System
Every surface point is parameterised by geodetic latitude $\phi \in [-90, 90]$ and longitude $\lambda \in [-180, 180)$.
$$ P(\phi, \lambda) = \begin{pmatrix} R \cos \phi \cos \lambda \\ R \cos \phi \sin \lambda \\ R \sin \phi \end{pmatrix} $$

### 3.3 Fourier-like Trigonometric Noise
Real atmospheric textures are approximated by finite trigonometric series:
$$ N(\phi, \lambda) = \sum_k A_k f_k(\alpha_k\lambda + \beta_k\phi + \phi_k), \quad f_k \in \{\sin, \cos\} $$
Evaluated at three scale levels: **Large-Scale ($N_L$)**, **Medium-Scale ($N_M$)**, and **Fine-Scale ($N_F$)**.

### 3.4 Atmospheric Ribbon (Gaussian Band)
Each atmospheric belt/zone is a Gaussian-shaped intensity profile:
1.  **Shifted centre:** $C'(\lambda) = C_0 + A \sin(f\lambda + \phi) + 0.35 W(\lambda, \phi)$
2.  **Latitudinal displacement:** $\delta(\phi, \lambda) = \phi - C'(\lambda)$
3.  **Gaussian intensity:** $R(\phi, \lambda) = \exp\left[-\left(\frac{\delta}{w}\right)^2\right]$

The complete dark-belt field is a weighted superposition: $D(\phi, \lambda) = \sum_{i=1}^{14} w_i R_i(\phi, \lambda)$.

### 3.5 Polar Geometry & Storms
*   **Polar Distance:** $p(\phi) = 90 - |\phi|$
*   **Polar Blend:** Controls transition between equatorial and polar colour models using Smoothstep.
*   **Polar Vortices:** Localised using an approximately Euclidean distance metric in polar coordinates: $V(\phi, \lambda) = s \exp\left[-\left(\frac{d_v}{\sigma}\right)^2\right]$
*   **Storms (incl. GRS):** Use normalised elliptical distance metrics. E.g., for the Great Red Spot:
    $$ d_{GRS} = \sqrt{\left(\frac{\text{wrap}(\lambda + 20)}{18}\right)^2 + \left(\frac{\phi + 22}{7.8}\right)^2} $$

### 3.6 Jupiter Surface Colour Synthesis Pipeline
The complete colour at any point $(\phi, \lambda)$ is computed by an 11-stage sequential linear-interpolation chain:
1. Base cream-brown blend driven by dark-belt coverage.
2. Warm tones in darker-belt regions.
3. Dark/Bright filament overlays.
4. Bright belt highlights.
5. Medium-scale mottling & Fine-scale brightening.
6. Storm darkening.
7. Polar region blend.
8. Great Red Spot overlay.
*(DetailedModel adds a 12th step for latitudinal temperature-zone gradients and aurorae).*

---

## 4. Physics Concepts

### 4.1 Orbital Mechanics & Laplace Resonance
Orbital periods follow Kepler’s Third Law: $T^2 = \frac{4\pi^2}{GM_J}a^3$.
The three innermost Galilean moons satisfy the **Laplace resonance**:
$$ n_{Io} : n_{Eu} : n_{Ga} = 4 : 2 : 1 \implies \frac{1}{T_{Io}} - \frac{3}{T_{Eu}} + \frac{2}{T_{Ga}} = 0 $$
In OpenSCAD, animated angles encode this exactly: $\alpha_{Io} = 4 \cdot 360 \cdot \$t$.

### 4.2 Magnetic Dipole Field & Plasma Torus
External field lines satisfy $r = L R_J \sin^2\theta$. 
The **Io Plasma Torus** is rendered as a flattened torus:
$$ P(\theta, \phi) = \left((r_0 + a \cos\phi)\cos\theta, \; (r_0 + a \cos\phi)\sin\theta, \; c a \sin\phi\right) $$

### 4.3 Roche Limit & Radiation Belts
*   **Roche Limit:** $d_R = 2.44 R_J \left(\frac{\rho_J}{\rho_m}\right)^{1/3}$. Modelled at $r_R = 1.75 R$.
*   **Radiation Belts:** Three nested elliptically compressed tori at $r_{inner} = 1.40 R$, $r_{middle} = 1.85 R$, $r_{outer} = 2.35 R$.

---

## 5. Model Architecture & OpenSCAD Snippets

### 5.1 Magnetic Field Line Construction
Generates Cartesian points along a single dipole field line:
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

### 5.2 Ring System Construction
Rings are annular discs produced by differencing two coaxial cylinders:
```openscad
module ring_torus(ir, or, h){
    difference(){
        cylinder(h=h, r=or, center=true, $fn=64);
        cylinder(h=h+1, r=ir, center=true, $fn=64);
    }
}
```

### 5.3 Plasma Torus
The circular cross-section is compressed vertically to produce the characteristic flat torus shape:
```openscad
module plasma_torus_mod(){
    color([0.75,0.25,0.55,0.14])
    rotate_extrude($fn=64)
    translate([ORBIT_IO,0,0])
    scale([1,0.35])
    circle(r=9,$fn=16);
}
```

### 5.4 3-D Aurorae
The north auroral glow is a cone, with a red outer edge produced by differencing concentric cylinders:
```openscad
// north red edge
difference(){
    cylinder(h=R*0.14, r1=R*0.46, r2=R*0.34, $fn=FN);
    cylinder(h=R*0.14+0.1, r1=R*0.38, r2=R*0.26, $fn=FN);
}
```

---

## 6. Geometric Construction Summary

| Feature | Primitive / Operation | Notes |
| :--- | :--- | :--- |
| **Jupiter surface** | `polyhedron` ($\times N_\phi N_\lambda$) | Quadrilateral patches; colour per face |
| **Moon spheres** | `sphere(r=radius)` | Colour via `color()` |
| **Orbit paths** | Segmented square chains | $N=180\text{–}500$ segments; circumference formula |
| **Ring discs** | `difference(cylinder, cylinder)` | Annular cross-section |
| **Plasma torus** | `rotate_extrude(circle)` | Scaled cross-section |
| **Radiation belts** | `rotate_extrude(circle)` | Elliptical scaling |
| **Rotation arrow** | `rotate_extrude` arc + cone | Partial angle extrusion |
| **Rotation axis** | `cylinder` + cones | Arrowheads at both poles |
| **Magnetic field lines**| `hull(sphere, sphere)` chain | `polyline` helper |
| **Magnetosphere** | `scale(sphere)` | $[2.8, 1, 1]$ — prolate in x |
| **3-D aurorae** | `cylinder` + `difference` | Cone + annular ring |
| **Roche limit** | `rotate_extrude(circle)` | Dotted six great-circle traces |
| **Tidal lines** | Radial `hull(sphere)` dashes | Co-rotating with moons |
| **Labels** | `linear_extrude(text)` | 3-D extruded glyphs |

---

## 7. Equation Reference Table

| Concept | Equation |
| :--- | :--- |
| **Clamp** | $\text{clamp}(x, 0, 1) = \max(0, \min(1, x))$ |
| **Smoothstep** | $S(x) = q^2(3 - 2q), \quad q = \text{clamp}(x, 0, 1)$ |
| **Linear interp.** | $\text{mix}(a, b, t) = a + q(b - a)$ |
| **Spherical coords** | $(x, y, z) = (R \cos\phi \cos\lambda, \; R \cos\phi \sin\lambda, \; R \sin\phi)$ |
| **Fourier noise** | $N = \sum_k A_k f_k(\alpha_k\lambda + \beta_k\phi + \phi_k)$ |
| **Wind wave** | $W(\lambda, \phi) = \sum_{k=1}^4 A_k \sin(\alpha_k\lambda + \beta_k\phi)$ |
| **Ribbon Gaussian** | $R = \exp[-(\delta/w)^2], \quad \delta = \phi - C'$ |
| **Polar distance** | $p = 90 - |\phi|$ |
| **Polar blend** | $B_p = S(\text{clamp}((52 - p)/16, 0, 1))$ |
| **Ring break** | $B_r = R_p \cdot Q(\lambda, \phi), \quad Q \in [0.20, 1.00]$ |
| **Polar vortex** | $V = s \exp[-(d_v/\sigma)^2], \quad d_v = \sqrt{x_v^2 + y_v^2}$ |
| **Storm distance** | $d_s = \sqrt{((\phi - \phi_c)/a)^2 + ((\text{wrap}(\lambda - \lambda_c))/b)^2}$ |
| **GRS ellipse** | $d_{GRS} = \sqrt{(\Delta\lambda/18)^2 + (\Delta\phi/7.8)^2}$ |
| **Kepler III** | $T^2 = \frac{4\pi^2}{GM_J}a^3$ |
| **Laplace res.** | $n_{Io} : n_{Eu} : n_{Ga} = 4 : 2 : 1$ |
| **Dipole L-shell** | $r = L R_J \sin^2\theta$ |
| **Roche limit** | $d_R = 2.44 R_J (\rho_J/\rho_m)^{1/3}$ |
| **Axial tilt** | $\epsilon = 3.13^\circ$ |

---
), radiation belt geometry, and auroral emission patterns — all represented as static geometric approximations faithful to the real Jovian system at the level of visual plausibility.

The five-file hierarchy allows the project to scale gracefully from a quick visual overview to a richly annotated, physically accurate full system view, demonstrating that OpenSCAD’s functional programming paradigm and parametric geometry primitives are exceptionally well-suited to scientific visualisation tasks of this complexity.
