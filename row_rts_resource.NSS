// =============================================================
//
//    File: row_rts_resource
//    Desc: Rowell's TradeSkill System - Gather Resources 
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 09, 2007
// Updated: Jan 09, 2007
// Version: 1.0.0
//
// =============================================================
//
// NECESSARY LOCAL VARIABLES THAT MUST EXIST ON THE PLACEABLE:
//
//   RTS_SKILL    : The Number of the RTS Skill that is needed to gather Resources from this object.
//   RTS_LEVEL    : The Level that the Player must be in the Skill in order to gather Resources from this object.
//   RTS_TOOL     : The Tool (Tag) necessary to gather Resources from this object.
//                  Leave Blank if no Tool is needed.
//   RTS_RESOURCE : The Resource (Tag) that is created when the player is done gathering.
//
// YOU MUST ALSO MAKE THE PLACEABLE OBJECT USEABLE, HAVE HIT POINTS, AND BE SET AS PLOT.
// THE OBJECT DOES NOT NEED AN INVENTORY.
//
// =============================================================

#include "row_inc_tradeskill"


void main() {
  object oSelf  = OBJECT_SELF;
  object oPC    = GetLastUsedBy();
  string sID    = GetPCPlayerName(oPC) + GetName(oPC) + "oRRG";
  int    iSkill = GetLocalInt(oSelf, "RTS_SKILL");

  // ALLOW GATHERING ONCE PER OBJECT PER SERVER RESET
  SetPlotFlag(oSelf, TRUE);
  if (GetLocalInt(oSelf, sID) != 0) {
	FloatingTextStringOnCreature("You've already gathered resources from this object.", oPC, FALSE);
  	return;
  }
  
  RTS_Gather(oSelf, oPC);  
  
}


