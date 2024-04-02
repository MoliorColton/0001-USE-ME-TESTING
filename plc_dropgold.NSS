


void main()
{
	object oGold = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
	int nGoldAmount = GetLocalInt(oGold, "nGoldAmount");
	DestroyObject(oGold);
	GiveGoldToCreature(oPC, nGoldAmount);
}