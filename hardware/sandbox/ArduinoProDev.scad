/*

	Playground for developing the vitamins/ArduinoPro.scad library

*/

include <../config/config.scad>

// include the ArduinoPro.scad library
include <../vitamins/ArduinoPro.scad>

// Hide clearance box for board components
ArduinoPro_PCB_Clearance_Show = false;

// Set custom board properties
// ArduinoPro_PCB_Width  =  0.7 * 25.4;
// ArduinoPro_PCB_Length =  1.3 * 25.4;
// ArduinoPro_PCB_Colour = [26/255, 90/255, 160/255];


// Create an Arduino Pro Mini
translate([ArduinoPro_PCB_Inset - ArduinoPro_PCB_Width/2 - ArduinoPro_PCB_Width, 0, 0])
  ArduinoPro(ArduinoPro_Mini, ArduinoPro_Pins_Normal, ArduinoPro_Pins_Normal);

// Create an Arduino Pro Micro
translate([ArduinoPro_PCB_Inset - ArduinoPro_PCB_Width/2 + ArduinoPro_PCB_Width, 0, 0])
  ArduinoPro(ArduinoPro_Micro, ArduinoPro_Pins_Normal);

// Create an Arduino Pro (headerless)
translate([ArduinoPro_PCB_Inset - ArduinoPro_PCB_Width/2, +ArduinoPro_PCB_Length *1.5, 0])
  ArduinoPro(ArduinoPro_No_Port, ArduinoPro_Pins_Opposite);

