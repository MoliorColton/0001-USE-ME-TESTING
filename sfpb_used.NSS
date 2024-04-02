//::///////////////////////////////////////////////
//:: Persistent Banking
//:: sfpb_used
//:://////////////////////////////////////////////
/*
    Written By by Clangeddin
*/
//////////////////////////////////////////////////

#include "nw_i0_spells"

void FinalizeBank(object oPC, object oSTORAGE)
{
	object oNEW = SetOwnersControlledCompanion(oPC, oSTORAGE);
	DelayCommand(0.0f, DisplayGuiScreen(oPC, "SCREEN_INVENTORY", FALSE, "inventoryscreen.xml"));
}

void InitializeBank(object oPC, object oSTORAGE, string sID)
{	
	AddRosterMemberByCharacter(sID, oSTORAGE);
	AddRosterMemberToParty(sID, oPC);
	SetIsRosterMemberSelectable(sID, FALSE);
	effect eFX = EffectCutsceneImmobilize();
	eFX = SupernaturalEffect(eFX);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
	DelayCommand(0.0f, FinalizeBank(oPC, oSTORAGE));
}

void main()
{
    object oPC = GetLastUsedBy();

	// End script if any of these conditions are met

	if (GetIsOwnedByPlayer(oPC) == FALSE) return;
    if (GetIsPC(oPC) == FALSE) return;
	if (GetIsDM(oPC) == TRUE) return;
	if (GetIsDMPossessed(oPC) == TRUE) return;
	if (GetIsPossessedFamiliar(oPC) == TRUE) return;


    string sID = GetPCPlayerName(oPC);
	object oSTORAGE = GetObjectFromRosterName(sID);
	if (oSTORAGE != OBJECT_INVALID) return;
	object oPARTY = GetFirstFactionMember(oPC);
	while (oPARTY != OBJECT_INVALID)
	{
		if (oPARTY != oPC)
		{
			SendMessageToPC(oPC, "You cannot use the persistent chest while you are in a party.");
			return;
		}
		oPARTY = GetNextFactionMember(oPC);
	}
	
	CloseGUIScreen(oPC, "SCREEN_INVENTORY");
	RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oPC);
	location lPC = GetLocation(oPC);
	oSTORAGE = RetrieveCampaignObject("bank_items", sID, lPC, OBJECT_INVALID, oPC);
    if (oSTORAGE == OBJECT_INVALID)
	{
		oSTORAGE = CreateObject(OBJECT_TYPE_CREATURE, "sfpb_storage", lPC, FALSE, sID);
		SetFirstName(oSTORAGE, GetFirstName(oPC) + "'s Storage");
	}
		
	DelayCommand(0.5f, InitializeBank(oPC, oSTORAGE, sID));
}