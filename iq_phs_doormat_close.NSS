//:: Icequeen's Persistent Housing (10/28/08)
//:: On Closed Handler for "Doormat" (destroy any contents)

#include "iq_func_lib"

void main()
{
  object oItem = GetFirstItemInInventory(OBJECT_SELF);
  object oPC = GetLastClosedBy();
  while (GetIsObjectValid(oItem))
   {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(OBJECT_SELF);
   }
   Debug(oPC,"DONE WITH CLOSE SCRIPT");
}