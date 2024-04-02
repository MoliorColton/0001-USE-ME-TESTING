#include "profession_include"

void DestroyFire(object oFIRE)
{
	object oPC = GetLastUsedBy();  
	CloseGUIScreen(oPC, "OVENMENU");

	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));
  // Get the first item in the inventory of the fire object
  object oITEM = GetFirstItemInInventory(oFIRE);

  // Loop through the items in the inventory and destroy them
  while (GetIsObjectValid(oITEM))
  {
    DestroyObject(oITEM);
    oITEM = GetNextItemInInventory(oFIRE);
  }

  // Set the fire object to be destroyable and then destroy it
  AssignCommand(oFIRE, SetIsDestroyable(TRUE));
  DestroyObject(oFIRE);
}