/*
  Vitamin: ArduinoPro
  Model of an Arduino Pro Mini/Micro

  Derived from: https://github.com/sparkfun/Pro_Micro/
           and: https://github.com/sparkfun/Arduino_Pro_Mini_328/

  Authors:
    Jamie Osborne (@jmeosbn)

  Local Frame:
    Point of origin is the centre of the bottom left pin (9)

  Parameters:
    type: can be "mini", or "micro";
          otherwise returns a blank board with header pin holes

  Returns:
    Model of an Arduino Pro Mini/Micro with header holes
*/


// ArduinoPro Model Variants
ArduinoPro_Mini       = 1;
ArduinoPro_Micro      = 2;

// ArduinoPro Without Programming Port
ArduinoPro_No_Port    = 0;

// Show Header Pins
ArduinoPro_Pins_Normal    =  1;
ArduinoPro_Pins_Opposite  =  2;

// ArduinoPro PCB Variables
ArduinoPro_PCB_Pitch    = 2.54;                       // spacing of the holes
ArduinoPro_PCB_Inset    = ArduinoPro_PCB_Pitch/2;     // inset from board edge
ArduinoPro_PCB_Width    = 0.7 * 25.4;                 // width of the PCB     (along x)
ArduinoPro_PCB_Length   = 1.3 * 25.4;                 // length of the PCB    (along y)
ArduinoPro_PCB_Height   = .063 * 25.4;                // thickness of the PCB (along z)
ArduinoPro_PCB_Colour   = [26/255, 90/255, 160/255];  // colour of solder mask
ArduinoPro_Pins_Height  = 11;                         // length of PCB pins
ArduinoPro_Pins_Offset  =  3;                         // offset of PCB pins
ArduinoPro_Pins_Gauge   = 1.25;                       // gauge/diameter of PCB pins
ArduinoPro_Pins_Spacer  = 2.25;                       // height of breakaway pin frame

// Show board clearance area for components
ArduinoPro_PCB_Clearance = 3;
ArduinoPro_PCB_Clearance_Show  = true;


module ArduinoPro_MicroUSB() {
  include <MicroUSB.scad>
  // Subtracting `ArduinoPro_PCB_Inset` compansates for board origin
  //-: Not sure if board origin would be better set after creation
  move_x  = ArduinoPro_PCB_Width / 2 - ArduinoPro_PCB_Inset;
  move_y  = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset;
  move_z  = ArduinoPro_PCB_Height;

  // Add USB header and move to top of board (along x)
  translate([move_x, move_y, move_z])
    MicroUSB_Receptacle();
}

module ArduinoPro_PCB() {
  // Bare PCB, origin through location for bottom left hole
  translate([-ArduinoPro_PCB_Inset, -ArduinoPro_PCB_Inset, 0])
    square(size = [ArduinoPro_PCB_Width, ArduinoPro_PCB_Length]);
}

// TODO: Add throughhole/padding
// TODO: Option to show header pins?
// FIXME: export to external vitamin?
module ArduinoPro_Header_Hole(d = 1.25) {
  // Standard PCB hole
  circle(d = d);
}

module ArduinoPro_Header_Pin() {
    $fn=6;
    color("black")
        cylinder(r=pow(ArduinoPro_Pins_Spacer,2)/4, h=ArduinoPro_Pins_Spacer);
     translate([0, 0, -ArduinoPro_Pins_Offset])
        color("white")
        cylinder(r=ArduinoPro_Pins_Gauge/2, h=ArduinoPro_Pins_Height);
}

module ArduinoPro_Headers_Layout() {
  // distance between the two header rows
  // FIXME: improve this to be a multiple of 0.1 inch
  rowpitch  = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;
  // length for holes, leaving room for end header and insets
  rowlength = ArduinoPro_PCB_Length - ArduinoPro_PCB_Pitch - ArduinoPro_PCB_Inset*2;

  // Add headers to either side (along y)
  for (x = [0, rowpitch], y = [0 : ArduinoPro_PCB_Pitch : rowlength]) {
    translate([x, y, 0]) children();
  }
}

module ArduinoPro_Serial_Header(gauge = ArduinoPro_Pins_Gauge) {
  // y position for header
  header_y = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset*2;
  // width for holes, leaving room for insets
  rowwidth = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;

  // Add serial header along top of board (along x)
  for (x = [ArduinoPro_PCB_Inset : ArduinoPro_PCB_Pitch : rowwidth]) {
    translate([x, header_y, 0])
      ArduinoPro_Header_Hole(gauge);
  }
}

module ArduinoPro(type = ArduinoPro_Mini, headerpins = 0, serialpins = 0) {
  color(ArduinoPro_PCB_Colour)
  linear_extrude(height=ArduinoPro_PCB_Height)
  difference() {
    // Base PCB
    ArduinoPro_PCB();

    // Common Headers for Pro Mini/Micro
    ArduinoPro_Headers_Layout() 
        ArduinoPro_Header_Hole(ArduinoPro_Pins_Gauge);

    // Pro Mini Serial Header
    if (type == ArduinoPro_Mini) ArduinoPro_Serial_Header();
  }


  //
  // FIXME: Improve following two blocks and refactor into one module
  //

  // Pro Mini Serial Header Pins
  serialontop = (serialpins != ArduinoPro_Pins_Opposite);
  // Offset for board height if located on top
  translate([0, 0, serialontop ? ArduinoPro_PCB_Height : 0])
  mirror([0, 0, serialontop ? 0 : 1 ])
  if (serialpins > 0 && type == ArduinoPro_Mini) {
    // Header Pins
    translate([0, 0, -ArduinoPro_Pins_Offset])
    color("white")
    linear_extrude(ArduinoPro_Pins_Height)
      ArduinoPro_Serial_Header();
    // Pin Spacers
    color("black")
    linear_extrude(ArduinoPro_Pins_Spacer)
      ArduinoPro_Serial_Header(pow(ArduinoPro_Pins_Spacer,2)/2);
  }

  // Common Header Pins 
  headerontop = (headerpins == ArduinoPro_Pins_Opposite);
  if (headerpins > 0) {
      // Offset for board height located on top
      translate([0, 0, headerontop ? ArduinoPro_PCB_Height : 0])
          mirror([0, 0, headerontop ? 0 : 1 ])
          ArduinoPro_Headers_Layout()
              ArduinoPro_Header_Pin();
  }

  // Pro Micro USB port
  if (type == ArduinoPro_Micro) ArduinoPro_MicroUSB();

  // Indicate area for minimum board clearance
  if (ArduinoPro_PCB_Clearance_Show) {
    color(ArduinoPro_PCB_Colour, 0.1)
    translate([-ArduinoPro_PCB_Inset, -ArduinoPro_PCB_Inset, 0.5])
    linear_extrude(height=ArduinoPro_PCB_Clearance)
    square(size = [ArduinoPro_PCB_Width, ArduinoPro_PCB_Length]);
  }
}



// Example Usage
// ArduinoPro(ArduinoPro_Mini, ArduinoPro_Serial_Pins);
// ArduinoPro(ArduinoPro_Micro, ArduinoPro_Header_Pins);
