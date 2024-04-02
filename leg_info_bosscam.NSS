/*

    Script:			This script is used on a trigger to activate a conversation with an NPC.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		07/15/2010 - 1.00 MV - Initial Release
*/



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oPC = GetEnteringObject();
	string sSpeaker = GetLocalString(OBJECT_SELF, "LEG_INFO_Speaker");
	object oSpeaker = GetObjectByTag(sSpeaker);
	if (GetIsObjectValid(oSpeaker) && !GetIsInCombat(oSpeaker))
	{
		object oPartyMember = GetFirstFactionMember(oPC, TRUE);
		while (GetIsObjectValid(oPartyMember))
		{
			if (!GetIsInCombat(oPartyMember) && !GetLocalInt(oPartyMember, "GetHasSeenBossCam_" + sSpeaker))
			{
				AssignCommand(oPartyMember, ActionStartConversation(oSpeaker, "", TRUE, TRUE, TRUE, FALSE));
				SetLocalInt(oPartyMember, "GetHasSeenBossCam_" + sSpeaker, 1);
			}
			oPartyMember = GetNextFactionMember(oPC);
		}
	}
}