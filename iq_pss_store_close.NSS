// Icequeen's Persistent Stores (10/28/08)
// Store On-close event

#include "ginc_item"
#include "iq_pss_db_inc"

void main()
{
string sDB=PSGetStoreID(OBJECT_SELF);
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
PSSetGold(OBJECT_SELF, GetStoreGold(OBJECT_SELF));
DelayCommand(1.0,PackCampaignDatabase(sDB));
}