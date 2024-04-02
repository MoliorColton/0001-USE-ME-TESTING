// Simple Script to teleport players from a conversation
//
void LEG_TELE_Critters(object oPC, object oChildWP)
{
	// Transport any critters that's along for the ride with the PC.
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC)))
    {
        DelayCommand(0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC), JumpToObject(oChildWP, FALSE)));
    }
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC)))
    {
        DelayCommand(0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC), JumpToObject(oChildWP, FALSE)));
    }
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC)))
    {
        DelayCommand(0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC), JumpToObject(oChildWP, FALSE)));
    }
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC)))
    {
        DelayCommand(0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC), JumpToObject(oChildWP, FALSE)));
    }
    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC)))
    {
        DelayCommand(0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC), JumpToObject(oChildWP, FALSE)));
    }
}

void main(string sWPName, int bAllPartyMembers)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oChildWP = GetObjectByTag(sWPName);
	
	if (GetIsObjectValid(oChildWP))
	{	
		if ( bAllPartyMembers == 0 )
		{
			DelayCommand(0.2, AssignCommand(oPC, ActionJumpToObject(oChildWP, FALSE)));
			LEG_TELE_Critters(oPC, oChildWP);
		}
		else
		{
			object oTarg = GetFirstFactionMember(oPC);
			while(GetIsObjectValid(oTarg))
			{
				DelayCommand(0.2, AssignCommand(oTarg, ActionJumpToObject(oChildWP, FALSE)));
				LEG_TELE_Critters(oTarg, oChildWP);
			}
		}	
	}
}
