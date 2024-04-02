#include "nw_i0_spells"

void main()
{
	object oBOSS = OBJECT_SELF;
	if (GetCurrentHitPoints(oBOSS) > 1) return;
	RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oBOSS);
	object oPC = GetLocalObject(oBOSS, "PC");
	object oAREA = GetArea(oBOSS);
	object oTOKEN;
	object oNPC = GetObjectByTag("kolodion");
	int nPHASE = GetLocalInt(oBOSS, "PHASE");
	int nPOLY;
	string sTXT;
	switch (nPHASE)
	{
		case 0: nPOLY = POLYMORPH_TYPE_TROLL; sTXT = "This is only the beginning. You can't beat me!"; break;
		case 1: nPOLY = POLYMORPH_TYPE_SWORD_SPIDER; sTXT = "Foolish mortal. I am unstoppable."; break;
		case 2: nPOLY = POLYMORPH_TYPE_NIGHTWALKER; sTXT = "Now you feel it... The dark energy!"; break;
		case 3: nPOLY = POLYMORPH_TYPE_HORNED_DEVIL; sTXT = "Aaaarrrrgggghhhh! The power!"; break;
		default:
			AssignCommand(oPC, JumpToObject(oNPC));
			if (GetItemPossessedBy(oPC, "kolodiontoken") == OBJECT_INVALID)
			{
				oTOKEN = CreateItemOnObject("cft_gem_13", oPC, 1, "kolodiontoken");
				SetFirstName(oTOKEN, "Kolodion's Approval");
				SetDescription(oTOKEN, "This is proof that you have defeated Kolodion 1 on 1.");
				SetItemCursedFlag(oTOKEN, TRUE);
				SetPlotFlag(oTOKEN, TRUE);
				DisplayMessageBox(oPC, 0, "Congratulations, you have defeated Kolodion. You have received a proof of your deed.");
			}
			SetIsDestroyable(TRUE, FALSE);
			DestroyObject(oBOSS);
			return;
	}	
	ForceRest(oBOSS);
	ActionSpeakString(sTXT);
	if (GetLocalInt(oBOSS, "ANTIRANDOM") == FALSE) SetLocalInt(oBOSS, "PHASE", nPHASE + 1);
	SetLocalInt(oBOSS, "ANTIRANDOM", TRUE);
	effect ePOLY = EffectPolymorph(nPOLY, TRUE, TRUE);
	if (nPHASE == 2) ePOLY = EffectLinkEffects(ePOLY, EffectSetScale(0.5));
	ePOLY = ExtraordinaryEffect(ePOLY);
	DelayCommand(0.0f, SetLocalInt(oBOSS, "ANTIRANDOM", FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePOLY, oBOSS));
}