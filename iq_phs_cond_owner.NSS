//:: Icequeen's Persistent Housing (10/28/08)
//:: Mortgage-tool Conversation starting conditional file
//:: Sets up the mortgage interaction variables
//:: Is this the house's owner?

#include "iq_phs_db_inc"

int StartingConditional()
{
 // ----- Get Player's Database ID -----
 object oPC = GetPCSpeaker();
 string sKey=SSGetCharacterKey(oPC);
 // ------------------------------------
 // ----- Get the house's current owner -----
 string sOwner=PHGetOwner(OBJECT_SELF);
 // ------------------------------------
 if (sOwner==sKey) return TRUE;
 return FALSE;
}