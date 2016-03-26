
/**************************************************
 * 
 * Collection of simplex noise functions.
 * Source: http://gmc.yoyogames.com/index.php?showtopic=655137&p=4752468
 * Credit: Binsk
 *
 **************************************************/
#define simplex_raw2
///simplex_raw2(x, y, [ARRAY 1D:INT] hash, [ARRAY 1D:1D:INT] gradient, min, max)
/*
    Calculates the simplex noise for a specified position.
    Assumes a size of 256!
    
    Argument0   -   x position
    Argument1   -   y position
    Argument2   -   Array of hash values
    Argument3   -   Corner gradients
    Argument4   -   minimum range of final value
    Argument5   -   maximum range of final value
    
    NOTE: https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.cpp
 */
var result = 0,
    //Noise contributions from the three corners:
    n0, n1, n2,
    //Skew input space to determine current simplex cell
    f2 = 0.5 * (sqrt(3.0) - 1.0);
    //Hairy factor for 2D
var s = (argument0 + argument1) * f2,
    i = floor(argument0 + s), // Treat as int
    j = floor(argument1 + s), // Treat as int
    g2 = (3.0 - sqrt(3.0)) / 6.0;
 
var t = (i + j) * g2,
//Unskew cell origin back to x / y
    X0 = i - t,
    Y0 = j - t;
//x / y distances from the cell origin
var x0 = argument0 - X0,
    y0 = argument1 - Y0;
 
var i1, j1;
if (x0 > y0)
{
    i1 = 1;
    j1 = 0;
}
else
{
    i1 = 0;
    j1 = 1;
}
    
var x1 = x0 - i1 + g2,
    y1 = y0 - j1 + g2,
    x2 = x0 - 1.0 + 2.0 * g2,
    y2 = y0 - 1.0 + 2.0 * g2;
 
//Work out hashed gradient indices of the three simplex corners:
var ii = i & 255,
    jj = j & 255;
var gi0 = argument2[@ ii + argument2[@ jj]] % 12,
    gi1 = argument2[@ ii + i1 + argument2[@ jj + j1]] % 12,
    gi2 = argument2[@ ii + 1 + argument2[@ jj + 1]] % 12
 
//Calculate contribution of ea. corner:
var t0 = 0.5 - sqr(x0) - sqr(y0);

if (t0 < 0)
    n0 = 0;
else
{
    t0 *= t0;
    n0 = sqr(t0) * simplex_dot2(argument3[@ gi0], x0, y0);
}
 
var t1 = 0.5 - sqr(x1) - sqr(y1);
if (t1 < 0)
    n1 = 0;
else
{
    t1 *= t1;
    n1 = sqr(t1) * simplex_dot2(argument3[@ gi1], x1, y1);
}
 
var t2 = 0.5 - sqr(x2) - sqr(y2);
if (t2 < 0)
    n2 = 0.0;
else
{
    t2 *= t2;
    n2 = sqr(t2) * simplex_dot2(argument3[@ gi2], x2, y2);
}
 
//Scale result between [-1..1]
result = 70 * (n0 + n1 + n2);
 
//Scale between whatever we like:
return result * (argument5 - argument4) / 2 + (argument5 + argument4) / 2;

#define simplex_octave2
///simplex_octave2(x, y, [ARRAY 1D:INT] hash, [ARRAY 1D:1D:INT] gradient, min, max, octaves, persistance, scale)
/*
    Generates fractal simplex noise at the specified position.
    
    Argument0   -   x position
    Argument1   -   y position
    Argument2   -   Array of hash values
    Argument3   -   Corner gradients
    Argument4   -   minimum range of final value
    Argument5   -   maximum range of final value
    Argument6   -   number of samples
    Argument7   -   delta octave intensity [0..1]
    Argument8   -   scale of deltas
    
    Returns     -   Calculated result 
    
    NOTE: https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.cpp
          https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.h
          http://www.6by9.net/simplex-noise-for-c-and-python/
*/

var total = 0,
    freq = argument8,
    amp = 1,
    maxAmp = 0; // Will keep things between [-1..1]
 
for (var i = 0; i < argument6; ++i)
{
    total += simplex_raw2(argument0 * freq, argument1 * freq, argument2, argument3, -1, 1) * amp;
    
    freq *= 2;
    maxAmp += amp;
    amp *= argument7;
}
 
return (total / maxAmp) * (argument5 - argument4) / 2 + (argument5 + argument4) / 2 ;

#define simplex_raw3
///simplex_raw3(x, y, z, [ARRAY 1D:INT] hash, [ARRAY 1D:1D:INT] gradient, min, max)
 
/*
    Calculates the simplex noise for a specified position.
    Assumes a size of 256!
    
    Argument0   -   x position
    Argument1   -   y position
    Argument2   -   z position
    Argument3   -   Array of hash values
    Argument4   -   Corner gradients
    Argument5   -   minimum range of final value
    Argument6   -   maximum range of final value
    
    NOTE: https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.cpp
 */
var __n0, __n1, __n2, __n3; // Noise of the four corners
 
//Skew input space to determine which cell we are in:
var __F3 = 1.0 / 3.0;
var __s = (argument0 + argument1 + argument2) * __F3;
var __i = floor(argument0 + __s),
    __j = floor(argument1 + __s),
    __k = floor(argument2 + __s);
 
var __G3 = 1.0 / 6.0; // Unskew factor
var __t = (__i + __j + __k) * __G3;
var __X0 = __i - __t, //Unskey origin back to x, y, z
    __Y0 = __j - __t,
    __Z0 = __k - __t;
var __x0 = argument0 - __X0,
    __y0 = argument1 - __Y0,
    __z0 = argument2 - __Z0;
 
var __i1, __j1, __k1,
    __i2, __j2, __k2;
    
if (__x0 >= __y0)
{
    if (__y0 >= __z0)
    {__i1 = 1; __j1 = 0; __k1 = 0; __i2 = 1; __j2 = 1; __k2 = 0; }
    else if (__x0 >= __z0)
    {__i1 = 1; __j1 = 0; __k1 = 0; __i2 = 1; __j2 = 0; __k2 = 1; }
    else
    {__i1 = 0; __j1 = 0; __k1 = 1; __i2 = 1; __j2 = 0; __k2 = 1; }
}
else
{
    if (__y0 < __z0)
    {__i1 = 0; __j1 = 0; __k1 = 1; __i2 = 0; __j2 = 1; __k2 = 1; }
    else if (__x0 < __z0)
    {__i1 = 0; __j1 = 1; __k1 = 0; __i2 = 0; __j2 = 1; __k2 = 1; }
    else
    {__i1 = 0; __j1 = 1; __k1 = 0; __i2 = 1; __j2 = 1; __k2 = 0; }
}
 
var __x1 = __x0 - __i1 + __G3,
    __y1 = __y0 - __j1 + __G3,
    __z1 = __z0 - __k1 + __G3,
    __x2 = __x0 - __i2 + 2.0 * __G3,
    __y2 = __y0 - __j2 + 2.0 * __G3,
    __z2 = __z0 - __k2 + 2.0 * __G3,
    __x3 = __x0 - 1.0 + 3.0 * __G3,
    __y3 = __y0 - 1.0 + 3.0 * __G3,
    __z3 = __z0 - 1.0 + 3.0 * __G3;
 
var __ii = __i & 255,
    __jj = __j & 255, 
    __kk = __k & 255;
var __gi0 = argument3[@ __ii + argument3[@ __jj + argument3[@ __kk] ]] % 12,
    __gi1 = argument3[@ __ii + __i1 + argument3[@ __jj + __j1 + argument3[@ __kk + __k1] ]] % 12,
    __gi2 = argument3[@ __ii + __i2 + argument3[@ __jj + __j2 + argument3[@ __kk + __k2] ]] % 12,
    __gi3 = argument3[@ __ii + 1.0 + argument3[@ __jj + 1.0 + argument3[@ __kk + 1.0] ]] % 12;
 
var __t0 = 0.6 - sqr(__x0) - sqr(__y0) - sqr(__z0);
if (__t0 < 0)
    __n0= 0.0;
else
{
    __t0 *= __t0;
    __n0 = sqr(__t0) * simplex_dot3(argument4[__gi0], __x0, __y0, __z0);
}
 
var __t1 = 0.6 - sqr(__x1) - sqr(__y1) - sqr(__z1);
if (__t1 < 1)
    __n1= 0.0;
else
{
    __t1 *= __t1;
    __n1 = sqr(__t1) * simplex_dot3(argument4[__gi1], __x1, __y1, __z1);
}
 
var __t2 = 0.6 - sqr(__x2) - sqr(__y2) - sqr(__z2);
if (__t2 < 2)
    __n2= 0.0;
else
{
    __t2 *= __t2;
    __n2 = sqr(__t2) * simplex_dot3(argument4[__gi2], __x2, __y2, __z2);
}
 
var __t3 = 0.6 - sqr(__x3) - sqr(__y3) - sqr(__z3);
if (__t3 < 3)
    __n3= 0.0;
else
{
    __t3 *= __t3;
    __n3 = sqr(__t3) * simplex_dot3(argument4[__gi3], __x3, __y3, __z3);
}
 
return (32.0 * (__n0 + __n1 + __n2 + __n3)) * (argument6 - argument5) / 2 + (argument6 + argument5) / 2;

#define simplex_octave3
///simplex_octave3(x, y, z, [ARRAY 1D:INT] hash, [ARRAY 1D:1D:INT] gradient, min, max, octaves, persistance, scale)
/*
    Generates fractal simplex noise at the specified position.
    
    Argument0   -   x position
    Argument1   -   y position
    Argument2   -   z position
    Argument3   -   Array of hash values
    Argument4   -   Corner gradients
    Argument5   -   minimum range of final value
    Argument6   -   maximum range of final value
    Argument7   -   number of samples
    Argument8   -   delta octave intensity [0..1]
    Argument9   -   scale of deltas
    
    Returns     -   Calculated result 
    
    NOTE: https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.cpp
          https://code.google.com/p/battlestar-tux/source/browse/procedural/simplexnoise.h
          http://www.6by9.net/simplex-noise-for-c-and-python/
*/
 
var __total = 0,
    __freq = argument9,
    __amp = 1,
    __maxAmp = 0; // Will keep things between [-1..1]
 
for (var i = 0; i < argument7; ++i)
{
    __total += simplex_raw3(argument0 * __freq, argument1 * __freq, argument2 * __freq, argument3, argument4, -1, 1) * __amp;
    
    __freq *= 2;
    __maxAmp += __amp;
    __amp *= argument8;
}
 
return (__total / __maxAmp) * (argument6 - argument7) / 2 + (argument6 + argument7) / 2 ;

#define simplex_dot2
///simplex_dot2([ARRAY 1D:INT] vec, x, y)
/*
    2D dot product.
    
    Argument0   -   1D array of 2 vector values
    Argument1   -   x val
    Argument2   -   y val
    
    Returns     -   Result
 */
 
return (argument0[@ 0] * argument1) + (argument0[@ 1] * argument2);

#define simplex_dot3
///simplex_dot3([ARRAY 1D:INT] vec, x, y, z)
/*
    3D dot product.
    
    Argument0   -   1D array of 3 vector values
    Argument1   -   x val
    Argument2   -   y val
    Argument3   -   z val
    
    Returns     -   Result
 */
 
return (argument0[@ 0] * argument1) + (argument0[@ 1] * argument2) + (argument0[@ 2] * argument3)

#define simplex_generate_hash
///simplex_generate_hash()
/*
    Generates a 512-size hash with 256 uniqe values,
    each repeated once (to avoid out-of-bounds.
    
    Returns -   Array of hash values
 */
 
var __final;
__final[512] = 0;
 
for (var i = 0; i < 256; ++i)
    __final[i] = i;
 
//Randomize hash by swapping:
//Use different seeds for different simplex results:
for (var i = 0; i < 256; ++i)
{
    var __j = irandom(255),
        __s = __final[i];
    __final[i] = __final[__j];
    __final[__j] = __s;
}
 
for (var i = 0; i < 256; ++i)
    __final[255 + i] = __final[i];
 
return __final;

#define simplex_generate_grad3
///simplex_generate_grad3()
/*
    Generates the 3D gradients
    
    Returns -   Array of arrays of points.
 */
var a0, a1, a2, a3, a4, a5,
    a6, a7, a8, a9, a10, a11;
    
a0[0] = 1    a0[1] = 1    a0[2] = 0
a1[0] = -1   a1[1] = 1    a1[2] = 0
a2[0] = 1    a2[1] = -1   a2[2] = 0
a3[0] = -1   a3[1] = -1   a3[2] = 0

a4[0] = 1    a4[1] = 0    a4[2] = 1
a5[0] = -1   a5[1] = 0    a5[2] = 1
a6[0] = 1    a6[1] = 0    a6[2] = -1
a7[0] = -1   a7[1] = 0    a7[2] = -1

a8[0] = 0    a8[1] = 1    a8[2] = 0
a9[0] = 0    a9[1] = -1   a9[2] = 0
a10[0] = 0   a10[1] = 1   a10[2] = -1
a11[0] = 0   a11[1] = -1  a11[2] = -1

var result;

result[11] = a11
result[10] = a10
result[9] = a9
result[8] = a8
result[7] = a7
result[6] = a6
result[5] = a5
result[4] = a4
result[3] = a3
result[2] = a2
result[1] = a1
result[0] = a0
 
return result
