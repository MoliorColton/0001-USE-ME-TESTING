// Icequeen's Persistent Stores (10/28/08)
// Called by conversation with salesman
// Open Store

#include "ginc_item"
#include "iq_pss_db_inc"

void main()
{
object oPC=GetPCSpeaker();
location lHere=GetLocation(OBJECT_SELF);
string sDB=PSGetStoreID(OBJECT_SELF);
string sLoop="1";
int nLoop=1;
object oStore=GetNearestObjectByTag(sDB+"_store");
object oItem=RetrieveCampaignObject(sDB, "Item #1", lHere, oStore);
while (GetIsObjectValid(oItem))
	{
	DeleteCampaignVariable(sDB, "Item #"+sLoop);
	nLoop++;
	sLoop=IntToString(nLoop);
	oItem=RetrieveCampaignObject(sDB, "Item #"+sLoop, lHere, oStore);
	}
int nMarkup=PSGetMarkup(OBJECT_SELF);
int nMarkdown=PSGetMarkdown(OBJECT_SELF);
int nBuy=PSGetBuy(OBJECT_SELF);
SetStoreGold(oStore, PSGetGold(OBJECT_SELF));
SetStoreMaxBuyPrice(oStore, nBuy);
DelayCommand(0.5, N2_AppraiseOpenStore(oStore, oPC, nMarkup, nMarkdown));
}