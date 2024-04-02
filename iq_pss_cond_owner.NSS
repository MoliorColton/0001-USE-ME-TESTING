// Icequeen's Persistent Stores (10/28/08)
//:: Is the speaking PC the store's owner?

#include "iq_pss_db_inc"

int StartingConditional()
{
 // ----- Get Player's Database ID -----
 object oPC = GetPCSpeaker();
 string sKey=SSGetCharacterKey(oPC);
 // ------------------------------------
 // ----- Get the house's current owner -----
 string sOwner=PSGetOwner(OBJECT_SELF);
 if (sOwner=="") sOwner="Bank"; 
 // ------------------------------------
 // ----- Set Tokens -----
 int nMarkup=PSGetMarkup(OBJECT_SELF);
 int nMarkdown=PSGetMarkdown(OBJECT_SELF);
 SetCustomToken(6001, IntToString(nMarkup));
 SetCustomToken(6002, IntToString(nMarkdown));
 SetCustomToken(6003, IntToString(PSGetGold(OBJECT_SELF)));
 //-------------------------------------
 if (sOwner==sKey) return TRUE;
 return FALSE;
}