// Icequeen's Persistent Stores (10/28/08)
// Called by conversation with salesman
// Inventory management - On-open storebox

#include "ginc_item"
#include "iq_pss_db_inc"

void main()
{
object oPC=GetPCSpeaker();
location lHere=GetLocation(oPC);
string sDB=PSGetStoreID(OBJECT_SELF);
object oBox=CreateObject
	(OBJECT_TYPE_PLACEABLE, "iqpssbox", lHere, FALSE, sDB+"_box");
string sLoop="1";
int nLoop=1;
object oItem=RetrieveCampaignObject(sDB, "Item #1", lHere, oBox);
while (GetIsObjectValid(oItem))
	{
	DeleteCampaignVariable(sDB, "Item #"+sLoop);
	nLoop++;
	sLoop=IntToString(nLoop);
	oItem=RetrieveCampaignObject(sDB, "Item #"+sLoop, lHere, oBox);
	}
SetLocked(oBox, FALSE);
AssignCommand(oPC, ClearAllActions(TRUE));
AssignCommand(oPC, ActionInteractObject(oBox));
}