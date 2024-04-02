const int SKILL_RUNECRAFTING = 36;

void TeleportToLocation(object oPC, object oAREA)
{
    AssignCommand(oPC, ActionJumpToObject(oAREA));
    DelayCommand(0.0f, DeleteLocalInt(oPC, "TELEPORT_INTERRUPT"));
}

void main(string sINPUT)
{
    object oPC = OBJECT_SELF;
    if (GetLocalInt(oPC, "TELEPORT_INTERRUPT") == 1) return;
    int nINPUT = StringToInt(sINPUT);
    int nLVL = 1;
    int nLAW;
    int nAIR;
    int nEAR;
    int nFIR;
    int nWAT;
    string sAREA;
    string sCOST;
    switch (nINPUT)
    {
        case 2:
            nLVL = 25;
            nLAW = 2;
            nAIR = 30;
            nFIR = 10;
            sAREA = "varrockloderc";
        break;
        case 3:
            nLVL = 31;
            nLAW = 2;
            nAIR = 30;
            nEAR = 10;
            sAREA = "lumbridgeloderc";
        break;
        case 4:
            nLVL = 37;
            nLAW = 2;
            nAIR = 30;
            nWAT = 10;
            sAREA = "faladorloderc";
        break;
    }
    object oAREA = GetObjectByTag(sAREA);
    if (oAREA == OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("Error: waypoint not found.", oPC, FALSE);
        return;
    }
    if (GetSkillRank(SKILL_RUNECRAFTING, oPC) < nLVL)
    {
        FloatingTextStringOnCreature("Your runecrafting skill is not high enough to teleport to that location.", oPC, FALSE);
        return;
    }
    int nSTACK;
    int nLOOP;
    int nCOST;
    string sITEM;
    object oITEM;
    while (nLOOP < 5)
    {
        switch (nLOOP)
        {
            case 0: nCOST = nLAW; sITEM = "lawrune"; break;
            case 1: nCOST = nAIR; sITEM = "airrune"; break;
            case 2: nCOST = nEAR; sITEM = "earthrune"; break;
            case 3: nCOST = nFIR; sITEM = "firerune"; break;
            case 4: nCOST = nWAT; sITEM = "waterrune"; break;
        }
        oITEM = GetItemPossessedBy(oPC, sITEM);
        nSTACK = GetItemStackSize(oITEM);
        if (nSTACK < nCOST)
        {
            FloatingTextStringOnCreature("You do not possess the required runes.", oPC, FALSE);
            return;
        }
        nLOOP = nLOOP + 1;
    }
    nLOOP = 0;
    while (nLOOP < 5)
    {
        switch (nLOOP)
        {
            case 0: nCOST = nLAW; sITEM = "lawrune"; break;
            case 1: nCOST = nAIR; sITEM = "airrune"; break;
            case 2: nCOST = nEAR; sITEM = "earthrune"; break;
            case 3: nCOST = nFIR; sITEM = "firerune"; break;
            case 4: nCOST = nWAT; sITEM = "waterrune"; break;
        }
        oITEM = GetItemPossessedBy(oPC, sITEM);
        nSTACK = GetItemStackSize(oITEM);
        if (nSTACK > nCOST) SetItemStackSize(oITEM, nSTACK - nCOST);
        else DestroyObject(oITEM);
        nLOOP = nLOOP + 1;
    }
    SetLocalInt(oPC, "TELEPORT_INTERRUPT", 1);
    DelayCommand(0.5, TeleportToLocation(oPC, oAREA));
}