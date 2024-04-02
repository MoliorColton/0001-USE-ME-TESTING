// =============================================================
//
//    File: row_area_enter_lights
//    Desc: Rowell's Player Enters Area Script - Turn On/Off Lights
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
//	Based On the work of Puget (puk_lights; Jan 13, 2007)
//
// Created: Feb 06, 2007
// Updated: Feb 06, 2007
// Version: 1.0.0
//
//   Usage: Place this script is called from the row_area_enter script
//			You will need to add and set up the following:
//			 o 1 Placeable Object that is the Source of the light (ie a Torch, Lampost, Candle, etc)
//			 o 1 Light Placeable Object just above where the flame/light would be coming from that object.
//
//			1) Move the Light Placeable Object just over the Placeable, where the flame/light would be.
//			2) Change the Tag of this Light Object to:  "row_light"
//			3) Add a new Local Variable onto the Light Placeable Object called "FX_SEF".
//			4) Make the FX_SEF variable a String type, and put in ONE of the following:
//				fx_torchglow, fx_lampglow, fx_candle
//
//			That should do it.  Lights should turn on/off depending on the time of day whenever a player enters the area.
//
// =============================================================


	

void TurnLightOn(object oLight) {
  string sFX     = GetLocalString(oLight, "FX_SEF");		//the fx file  (fx_lampglow, fx_torchglow, fx_candle)
  effect eLight  = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_20);
  effect eFX     = EffectNWN2SpecialEffectFile(sFX);
  
  DelayCommand(0.4, SetPlaceableIllumination(oLight, TRUE));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oLight);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oLight);

}


void TurnLightOff(object oLight) {
  string sFX     = GetLocalString(oLight, "FX_SEF");		//the fx file  (fx_lampglow, fx_torchglow, fx_candle)
  
  DelayCommand(0.4, SetPlaceableIllumination(oLight, FALSE));
  RemoveSEFFromObject(oLight, sFX);
  effect eEffect = GetFirstEffect(oLight);
  while (GetIsEffectValid(eEffect) == TRUE) {
    if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT) 
	  RemoveEffect(oLight, eEffect);
    eEffect = GetNextEffect(oLight);
  }

}


void main() {
	object oArea = OBJECT_SELF;
	object oLight;
	int    iIsNightTime;
			
	// MAKE SURE THE oArea OBJECT IS INDEED AN AREA
	if (GetObjectType(oArea) == OBJECT_TYPE_PLACEABLE) {
	  // THIS SECTION IS MAINLY FOR DEBUGGING PURPOSES
	  // WHEN THIS SCRIPT IS CALLED FROM THE OnUsed EVENT OF A PLACEABLE,
	  // IT WILL TOGGLE ALL THE row_light LIGHTS IN THE AREA ON/OFF
	  oArea = GetArea(oArea);
	  iIsNightTime = (!GetLocalInt(oArea, "ROW_LIGHT_ON"));
	} else {
      // FIND OUT THE TIME OF DAY IT IS
	  if ( GetIsNight() || GetIsDusk() || !GetIsAreaAboveGround(oArea) || GetIsAreaInterior(oArea) )
	  	iIsNightTime = TRUE;
	  else
	    iIsNightTime = FALSE;
	}
		
	// CHECK THE OBJECTS IN THE AREA FOR LIGHTS
	if (iIsNightTime != GetLocalInt(oArea, "ROW_LIGHT_ON")) {
	  oLight = GetFirstObjectInArea(oArea);
  	  while (oLight != OBJECT_INVALID) {
	
	    // ONLY PROCESS THE LIGHT WAYPOINT OBJECTS
	    if (GetObjectType(oLight) == OBJECT_TYPE_PLACEABLE && GetTag(oLight) == "row_light") {
	  
	      // ONLY PROCESS THE LIGHTS WHEN THEY NEED TO BE TURNED ON / OFF
	      if (iIsNightTime != GetLocalInt(oLight, "ROW_LIGHT_ON")) {
		
		    // TURN THE LIGHTS ON/OFF
		    if (iIsNightTime)
		      TurnLightOn(oLight);
		    else
		  	  TurnLightOff(oLight);
			
		    // STORE THE LIGHT'S SETTING IN A LOCAL VARIABLE
		    SetLocalInt(oLight, "ROW_LIGHT_ON", iIsNightTime);
		  }
	    }
	  
	    // GET THE NEXT OBJECT IN THE AREA
	    oLight = GetNextObjectInArea(oArea);	
	
	  }
	  
	  SetLocalInt(oArea, "ROW_LIGHT_ON", iIsNightTime);
	  
	}
	
	// RECOMPUTE THE LIGHTING FOR THE AREA
	DelayCommand(1.0, RecomputeStaticLighting(oArea));

	
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================

		
}