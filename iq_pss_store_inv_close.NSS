// Icequeen's Persistent Stores (10/28/08)
// Called by conversation with salesman
// Inventory management; on close storebox

#include "ginc_item"
#include "iq_pss_db_inc"

void main()
{
object oPC=GetLastClosedBy();
location lHere=GetLocation(OBJECT_SELF);
string sDB=PSGetStoreID(OBJECT_SELF);
SetLocked(OBJECT_SELF, TRUE);
int nLoop=2;
object oItem1=GetFirstItemInInventory(OBJECT_SELF);
object oItem=GetNextItemInInventory(OBJECT_SELF);
StoreCampaignObject(sDB, "Item #1", oItem1);
while (GetIsObjectValid(oItem) && oItem!=oItem1)
	{
	StoreCampaignObject(sDB, "Item #"+IntToString(nLoop), oItem);
	DestroyObject(oItem, 0.1);
	nLoop++;
	oItem=GetNextItemInInventory(OBJECT_SELF);
	}
if (!GetIsObjectValid(oItem) || oItem==oItem1) DestroyObject(oItem1, 0.2);
DelayCommand(0.9, PackCampaignDatabase(sDB));
DestroyObject(OBJECT_SELF, 1.0);
}