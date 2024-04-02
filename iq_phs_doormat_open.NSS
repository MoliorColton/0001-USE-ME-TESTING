//:: Icequeen's Persistent Housing (10/28/08)
//:: On Opened Handler for "Doormat" (contains mortgage tool / key)

#include "iq_phs_db_inc"

void main()
{
object oPC = GetLastOpenedBy();
string sPlayerKey = SSGetCharacterKey(oPC);
string sOwner = PHGetOwner(OBJECT_SELF);

// Initialize the property
if (PHGetMortgageHolder(OBJECT_SELF)=="")
	{
	// Make a mortgage tool
	CreateItemOnObject("iqphs_mrtg_tool",OBJECT_SELF,1);	
	return;
	}

// Make a "key" for the owner
if (sOwner == sPlayerKey)
	{
	CreateItemOnObject("iqphs_key",OBJECT_SELF,1);
	SetLocalString(oPC, "Mortgage", "Selling");
	// Make a mortgage tool
	CreateItemOnObject("iqphs_mrtg_tool",OBJECT_SELF,1);
	return;	
	}
if (!PHGetIsForSale(OBJECT_SELF)) return;
SetLocalString(oPC, "Mortgage", "Buying");
// Make a mortgage tool
CreateItemOnObject("iqphs_mrtg_tool",OBJECT_SELF,1);	
object oItem;
oItem = GetFirstItemInInventory(OBJECT_SELF);
while (GetIsObjectValid(oItem))
    {
    SetItemStackSize(oItem, 1);
    oItem = GetNextItemInInventory(OBJECT_SELF);
    }
// Search for and destroy any hidden 'body bags' from prior incarnations of this placeable
object oSearchForBag = GetNearestObjectByTag("Body Bag",OBJECT_SELF,1);
if (oSearchForBag == OBJECT_INVALID)return;
object oBagItem = OBJECT_INVALID;
if (GetDistanceToObject(oSearchForBag)<= 0.2)
    {
    Debug(oPC, "Body bag found.. destroying contents..");
    oBagItem = GetFirstItemInInventory(oSearchForBag);
    while (GetIsObjectValid(oBagItem))
        {
        Debug(oPC, "Destroying : "+GetName(oBagItem));
        DestroyObject(oBagItem);
        oBagItem = GetNextItemInInventory(oSearchForBag);
        }
    DestroyObject(oSearchForBag,1.0);
    }
}