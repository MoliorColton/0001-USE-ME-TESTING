#include "nw_i0_generic"

void main(object oPC)
{
  // Get the current amount of gold the player character has
  int gold = GetGold(oPC);

  // Convert the gold amount to a string
  string sGOLDTEXT = IntToString(gold);

  // Update the UI element with the current gold amount
  SetGUIObjectText(oPC, "SCREEN_INVENTORY", "GOLD_DISPLAY", -1, sGOLDTEXT);
}
