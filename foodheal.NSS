void main()
{
	object oPC = GetItemActivator();
	int healAmt = FloatToInt(GetLocalFloat(OBJECT_SELF, "healAmt"));
	
	SendMessageToPC(oPC, "healAmt:" + IntToString(healAmt));
	
	if(healAmt > 0)
	{
		ApplyEffectToObject(0, EffectHeal(healAmt), oPC, 0.0);
	}

}