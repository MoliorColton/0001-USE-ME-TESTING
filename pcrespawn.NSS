/*******************************
Script: Respawn At Start Location
Created By: Jaden Wagener
Created On: 08/30/02
*******************************/
//Respawns a player back at the start location.
//Script should be placed in the module's OnRespawn slot.
//NOTE: due to the current bug issue with the GetStartLocation function,
//a waypoint must be created at the starting location and its tag inserted
//in place of NW_WAYPOINT001.
#include "nw_i0_plot"
//Uses some in game default scripts
void main()
{

   object oPC = GetLastRespawnButtonPresser();               
   int nHP = GetMaxHitPoints(oPC);                               
   location lStart = GetLocation(GetWaypointByTag("PCrespawn")); 
   effect eRez = EffectResurrection();                              
   effect eHeal = EffectHeal(nHP);                                  
   //Resurrect at start location
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
   RemoveEffects(oPC); //Removes Negative effects. Is defined in nw_i0_plot.
   AssignCommand(oPC, ActionJumpToLocation(lStart));
   DelayCommand(0.0f, ExportSingleCharacter(oPC));
}


// heal players to full
   int nHP = GetMaxHitPoints(oPC);     
   effect eHeal = EffectHeal(nHP);  
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);                             
// 