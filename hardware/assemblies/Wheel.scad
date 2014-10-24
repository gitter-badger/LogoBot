/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly
	
	Local Frame: 
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/


// Connectors
// ----------

Wheel_Con_Default				= [ [0,0,0], [0,0,1], 0, 0, 0];



module WheelAssembly( Explode=false ) {

    Assembly("Wheel");

	if (DebugCoordinateFrames) frame();
	
	// debug connectors?
	if (DebugConnectors) {
		
	}
	
	// Vitamins
	logo_motor();
	
	// STL
	step(1, 
            "Push the wheel onto the motor shaft", 
            "400 300 -0.4 0.2 0.7 349 125 180 415")
	    Wheel_STL();
	
		
	End("Wheel");
}


module Wheel_STL() {

	STL("Wheel");
	
	color(Level2PlasticColor)
	    cylinder(r=WheelDiameter/2, h=WheelThickness, $fn=64);
}