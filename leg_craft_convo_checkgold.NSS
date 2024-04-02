/*

    Script:			Originally based on the built in "gc" script for checking gold, modified this
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
int StartingConditional(int nGold, int nMP)
{
    object oPC = GetPCSpeaker();

	if (nGold == 0)
		nGold = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_TrainingPrice");
		
    if ( nMP == 0 )
    {
        if ( GetGold(oPC) >= nGold ) return TRUE;
    }
    else
    {
        oPC = GetFirstPC();
        while( GetIsObjectValid(oPC) )
        {
            if( GetGold(oPC) < nGold ) return FALSE;
            oPC = GetNextPC();
        }
        return TRUE;
    }

    return FALSE;

}