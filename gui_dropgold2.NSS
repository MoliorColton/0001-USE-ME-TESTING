

//gold_drop_1
void main(string sAmount)
{
	object oPC = OBJECT_SELF;
	
	if(sAmount == "")
	{
		SendMessageToPC(oPC, "You cannot drop nothing.");
		return;
	}
	
	object oGroundGold;
	int nAmount = StringToInt(sAmount);
	location lLoc = GetLocalLocation(oPC, "Last_Gold_Drop_Loc");
	string sTemplate = "gold_drop_1";
	//merely randomizing the appearance between a stack of coins and a pile with with a pouch
	if(Random(2))
	{
		sTemplate = "gold_drop_2";
	}
	
	if(GetGold(oPC) >= nAmount && nAmount > 0)
	{
		if(GetDistanceBetweenLocations(GetLocation(oPC), lLoc) <= 4.0)
		{
			PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0);
			TakeGoldFromCreature(nAmount, oPC, TRUE);
			oGroundGold = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLoc);
			SetLocalInt(oGroundGold, "nGoldAmount", nAmount);
		}
		else
		{
			SendMessageToPC(oPC, "Target location too far away.");
		}
	}
	else
	{
		SendMessageToPC(oPC, "Not enough gold.");
	}
}