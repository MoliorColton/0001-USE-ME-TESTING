#include "profession_include"


void DestroyFire(object oFIRE)
{
    object oPC = GetLastUsedBy(); 

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));

    AssignCommand(oFIRE, SetIsDestroyable(TRUE));
    DestroyObject(oFIRE);

    // Spawn ashes
    object oAshes = CreateObject(OBJECT_TYPE_ITEM, "ashes", GetLocation(oFIRE));
}




void main()
{
    object oFIRE = OBJECT_SELF;

    if (GetHasSpellEffect(-10, oFIRE) == TRUE) return;
    if (GetLocalInt(oFIRE, "EXTINCT") == TRUE) return;
    
    SetLocalInt(oFIRE, "EXTINCT", TRUE);
    SetLocked(oFIRE, FALSE);

    object oPC = GetLastUsedBy();
    SendMessageToPC(oPC, "The fire has gone out.");

    DelayCommand(0.1, DestroyFire(oFIRE));
    
    if (GetLocalInt(oPC, "PROF_SKILL") == SKILL_COOKING) ExecuteScript("gui_prof_loop", oPC);
}
