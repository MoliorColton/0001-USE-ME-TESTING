//:: Icequeen's Persistent Housing (10/28/08)
//:: Initialization script

#include "iq_phs_db_inc"
int StartingConditional()
{
if (PHGetMortgageHolder(OBJECT_SELF)=="")
	{
	PHInitialize(OBJECT_SELF);
	return TRUE;
	}
return FALSE;
}