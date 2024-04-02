// =============================================================
//
//    File: row_discovery
//    Desc: Rowell's Discovery Reward Trigger
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Feb 04, 2007
// Updated: Feb 04, 2007
// Version: 1.0.0
//
//   Usage: Placed tihs script in the OnEnter Event of a Trigger
//	Needed in the Trigger Object:
//			A Unique TAG	(the Tag field)
//			A Name			(the Localized Name field)
//			A Variable called "DISCOVERY_LEVEL", set as an Integer, and containing a number
//				from 1 to 20. This acts as the Level of the discovery.
//			This script in the OnEnter event of the Trigger Object.
//
// =============================================================

#include "row_inc_functions"

void main() {
  object oPC      = GetEnteringObject();
  object oPlace   = OBJECT_SELF;

  Row_DiscoverLocation(oPC, oPlace);
  
  
  // INSERT YOUR OWN CODE BELOW
  // ===================================================================================
  
  
}


