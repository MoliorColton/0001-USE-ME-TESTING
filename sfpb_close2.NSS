
#include "nw_i0_spells"


void main()
{
    object oPC = GetLastUsedBy();
    string sID = GetPCPlayerName(oPC);
	object oSTORAGE = GetObjectFromRosterName(sID);
	
	CloseGUIScreen(oPC, "SCREEN_INVENTORY");
	RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oPC);
	location lPC = GetLocation(oPC);
	oSTORAGE = RetrieveCampaignObject("bank_items", sID, lPC, OBJECT_INVALID, oPC);
    if (oSTORAGE == OBJECT_INVALID)
	{
		oSTORAGE = CreateObject(OBJECT_TYPE_CREATURE, "sfpb_storage", lPC, FALSE, sID);
		SetFirstName(oSTORAGE, GetFirstName(oPC) + "'s Storage");
	}
		
}