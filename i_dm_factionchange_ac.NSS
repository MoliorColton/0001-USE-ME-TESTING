//******************START AnnounceCheater()************************
void AnnounceCheater(object oCheater)
	{
	SendMessageToAllDMs("** CHEAT ALERT **" + GetName(oCheater) + ", CD Key: " + GetPCPublicCDKey(oCheater));
	SendMessageToAllDMs("has tried to use the a DM tool in " + GetName(GetArea(oCheater)) + " attempt logged.");
	WriteTimestampedLogEntry("** CHEAT ALERT **" + GetName(oCheater) + ", CD Key: " + GetPCPublicCDKey(oCheater) + " has tried to use a DM tool in " + GetName(GetArea(oCheater)));
	SendMessageToPC(oCheater, "You are attempting to use a DM tool.  This attempt has been logged and the server admins have been notified.");
	SendMessageToPC(oCheater, "Big Brother is watching you.");	
	}
//********************END AnnounceCheater()************************

//****************************************************************
//******************START MAIN SCRIPT******************************
void main()
{
    object oDM = GetItemActivator();
 	
	//Safety here.
	if (!GetIsDM(oDM))
		{
		AnnounceCheater(oDM);
		//return;
		}   
	AssignCommand(oDM, ActionStartConversation(oDM, "hm_dynamic_faction", TRUE, FALSE, TRUE, TRUE));
}