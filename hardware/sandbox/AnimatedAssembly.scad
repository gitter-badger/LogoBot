include <../config/config.scad>

DebugCoordinateFrames = false;
DebugConnectors = false;


// To view this example, turn on View -> Animate in OpenSCADm
// then set the FPS to around 5 and Steps to 110 at the bottom of the screen


$AnimateExplode = true;
$ShowStep = floor(map($t, [0,1], [1,13]));
$AnimateExplodeT = map($t, [0,1], [1,13]) - $ShowStep;

function lerp(u, v1, v2) = v1 + (v2-v1) * u;

r1 = [0,0,0];
r2 = [2,-10, -90];

// Basic rotation linear tweening
r = [lerp($t, r1[0], r2[0]), lerp($t, r1[1], r2[1]), lerp($t, r1[2], r2[2])];

rotate(r)
    LogoBotAssembly();

	
/*

Automated animations... 

Thoughts:
* Use the parsed assembly steps to create an animation for each assembly
* Tween between views
* Parse an animation block for each assembly that controls animation generation and key parameters
* use PIL ImageDraw module

Animation block:
* Assembly frames - how many frames to use to animate the assembly
* Framerate (for final movie file)
* Transition frames - how many frames to move between views
* Pause frames - how many frames to pause before moving to next step

How the final animation will be structured:
For each step:
* Show the part exploded, as per normal
* Overlay the step number and description - leave enough time for an average reader to read the desc
* Animate the assembly step
* Pause 
* Animate the view change to the next step

*/
