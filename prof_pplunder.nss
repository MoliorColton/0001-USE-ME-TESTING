#include "profession_include"

string Reward(int nRANDOM){
    switch (nRANDOM){
            case 0: return "ppicomb";
            case 1: return "pppscarab";
            case 2: return "pppstatuette";
            case 3: return "ppsseal";
            case 4: return "ppsscarab";
            case 5: return "ppsstatuette";
            case 6: return "ppgseal";
            case 7: return "ppgscarab";
            case 8: return "ppgstatuette";
    }    
    return "ERROR";
}

void RespawnUrn(location lPOOL){
    CreateObject(OBJECT_TYPE_PLACEABLE, "ppurn", lPOOL);
}

void main(){
    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;
    object oPOOL = OBJECT_SELF;
    int nFLOOR = GetLocalInt(oPC, "PYRAMIDFLOOR");
    int nTHIEF = GetSkillRank(SKILL_THIEVING, oPC);
    int nXP;
    int nREQ;
    int nCOMB = FALSE;
    int nDROPS = 5;
    int nSCEPTRE;
    switch (nFLOOR){
        case 0: return;
        case 1: nXP = 180; nREQ = 0; nCOMB = TRUE; nSCEPTRE = 4200; break;
        case 2: nXP = 270; nREQ = 31; nCOMB = TRUE; nSCEPTRE = 2800; break;
        case 3: nXP = 450; nREQ = 41; nDROPS = 6; nSCEPTRE = 1600; break;
        case 4: nXP = 630; nREQ = 51; nDROPS = 7; nSCEPTRE = 950; break;
        case 5: nXP = 900; nREQ = 61; nDROPS = 7; nSCEPTRE = 800; break;
        case 6: nXP = 1350; nREQ = 71; nDROPS = 7; nSCEPTRE = 750; break;
        case 7: nXP = 2025; nREQ = 81; nDROPS = 8; nSCEPTRE = 650; break;
        case 8: nXP = 2475; nREQ = 91; nDROPS = 8; nSCEPTRE = 650; break;
        default: DeleteLocalInt(oPC, "PYRAMIDFLOOR"); SendMessageToPC(oPC, "Something has gone wrong, report this to the devs"); return;
    }
    if (nREQ > nTHIEF){
        SendMessageToPC(oPC, "You need at least " + IntToString(nREQ) + " thieving to steal from this.");
        return;
    }
    int nRANDOM = Random(nDROPS);
    if (nCOMB == FALSE){
        nRANDOM = nRANDOM + 1;
    }
    string sREWARD = Reward(nRANDOM);
    if (sREWARD == "ERROR"){
        SendMessageToPC(oPC, "Something went wrong, report this to the devs.");
    }
    if (GetTag(oPOOL) == "ppurn"){
        int nLOOTED = GetLocalInt(oPC, "PPURNS");
        if (nLOOTED > 16){
            SendMessageToPC(oPC, "You can only loot 16 Urns per floor.");
            return;
        }
        SetLocalInt(oPC, "PPURNS", nLOOTED + 1);
        int nSUCCESS = 50 + (2 * (nTHIEF - nREQ));
        if (Random(100) < nSUCCESS){
            SendMessageToPC(oPC, "You found something!");
            GiveCraftXP(oPC, SKILL_THIEVING, nXP);
            CreateItemOnObject(sREWARD, oPC);
            location lPOOL = GetLocation(oPOOL);
            DelayCommand(12.0f, RespawnUrn(lPOOL));
            DestroyObject(oPOOL);
        }
        else {
            effect eDRAIN = EffectAbilityDecrease(0, Random(6)+1);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDRAIN, oPC);
            SendMessageToPC(oPC, "A snake was hiding in the urn and bit you!");
        }
    }
    else if (GetTag(oPOOL) == "ppchest"){
        if (GetLocalInt(oPC, "PYRAMIDCHEST") > nFLOOR){
            SendMessageToPC(oPC, "You can only loot the chest in each room once per run.");
            return;
        }
        if (Random(nSCEPTRE)<1){
            sREWARD = "pharaohsceptre";
            SendMessageToPC(oPC, "You found the Pharaoh's Sceptre!");
        }
        else{
            SendMessageToPC(oPC, "You found something!");
        }
        CreateItemOnObject(sREWARD, oPC);
        GiveCraftXP(oPC, SKILL_THIEVING, (nXP/3)*2);
    }
}