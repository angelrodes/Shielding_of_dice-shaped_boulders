# Cosmogenic shielding corrections at the sides of dice-shaped boulders

```get_cube_shielding.m``` is a script that:
1. generates 3D polygons in the shape of cubes of different sizes,
2. generates coordinates for samples at the center of each side of the cube,
3. uses Balco's code (```generate_cosmic_rays.m```) to calculate the shielding correction for each sample
4. and calculates the approximations that describe the shielding correction vs. the size of the cube.

All the scripts that simulate the cosmic radiation in the samples are extracted from the supplementary material of the following publication:

Greg Balco (2014) Simple computer code for estimating cosmic-ray shielding by oddly shaped objects. [Quaternary Geochronology, Volume 22, Pages 175-182.](https://doi.org/10.1016/j.quageo.2013.12.002)


## Results
![image](https://user-images.githubusercontent.com/53089531/171359272-fe61ee45-32af-4dac-9e88-4469d8870804.png)

### Apparent side-shielding formulas

Side shielding correction: 
```y=0.5+0.5*exp(-x*0.8)```

Bottom shielding correction: 
```y=exp(-x*1.1)```

where ```x``` is the side of the dice in metres

### Extrapolation and general formulas

After repeating this experiment for different densities (```d```) and particle attenuation lengths (```L```):

Side shielding correction: 
```y=0.5+0.5*exp(-z*d/(2*L*0.8))```

Bottom shielding correction: 
```y=exp(-z*d/(L*1.16))```

where ```z``` is the side of the dice in cm

<!---
More results

figures
y=0.5+0.5*exp(-x*0.79969)
y=0.5+0.5*exp(-z*2.65/(2*208*0.79658))
y=0+1*exp(-x*1.0828)
y=0+1*exp(-z*2.65/(208*1.1766))

less cubes

rho=2.65; L=208
y=0.5+0.5*exp(-x*0.80137)
y=0.5+0.5*exp(-z*2.65/(2*208*0.79491))
y=0+1*exp(-x*1.1032)
y=0+1*exp(-z*2.65/(208*1.1548))

y=0.5+0.5*exp(-x*0.80504)
y=0.5+0.5*exp(-z*2.65/(2*208*0.79129))
y=0+1*exp(-x*1.1035)
y=0+1*exp(-z*2.65/(208*1.1545))

y=0.5+0.5*exp(-x*0.80076)
y=0.5+0.5*exp(-z*2.65/(2*208*0.79551))
y=0+1*exp(-x*1.1064)
y=0+1*exp(-z*2.65/(208*1.1516))

y=0.5+0.5*exp(-x*0.80328)
y=0.5+0.5*exp(-z*2.65/(2*208*0.79302))
y=0+1*exp(-x*1.0997)
y=0+1*exp(-z*2.65/(208*1.1586))

rho=2.7; L=208
y=0.5+0.5*exp(-x*0.81331)
y=0.5+0.5*exp(-z*2.7/(2*208*0.79803))
y=0+1*exp(-x*1.1209)
y=0+1*exp(-z*2.7/(208*1.158))

y=0.5+0.5*exp(-x*0.82509)
y=0.5+0.5*exp(-z*2.7/(2*208*0.78662))
y=0+1*exp(-x*1.1216)
y=0+1*exp(-z*2.7/(208*1.1574))

rho=2.65; L=160
y=0.5+0.5*exp(-x*1.0395)
y=0.5+0.5*exp(-z*2.65/(2*160*0.79667))
y=0+1*exp(-x*1.4043)
y=0+1*exp(-z*2.65/(160*1.1794))

y=0.5+0.5*exp(-x*1.0329)
y=0.5+0.5*exp(-z*2.65/(2*160*0.80173))
y=0+1*exp(-x*1.4093)
y=0+1*exp(-z*2.65/(160*1.1752))
--->

---

??ngel Rod??s, 2022

[angelrodes.com](www.angelrodes.com)
