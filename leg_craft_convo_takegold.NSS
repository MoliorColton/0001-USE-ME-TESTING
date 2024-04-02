/*

    Script:			Originally based on the built in "ga" script for taking gold, modified this
					script will also see if the NPC has a gold value set as a variable rather than
					just passed as a hard code in the conversation itself.  This allows many different
					NPC trainers to charge different amounts of money using the same conversation file.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		08/26/2011 - 1.00 MV - Initial Release
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int nGold, int bAllPartyMembers)
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

	if (nGold == 0)
		nGold = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainingPrice");
	
    if ( bAllPartyMembers == 0 )
    {
        TakeGoldFromCreature( nGold,oPC );
    }
    else    
    {// For multiple players
        oTarg = GetFirstFactionMember(oPC);
        while ( GetIsObjectValid(oTarg) )
        {
            TakeGoldFromCreature( nGold,oTarg );
            oTarg = GetNextFactionMember(oPC);
        }
    }

}