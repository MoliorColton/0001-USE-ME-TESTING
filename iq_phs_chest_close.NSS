//:: Icequeen's Persistent Housing (10/28/08)
//:: Persistent storage
//:: On-closed event

#include "ginc_item"
#include "iq_func_lib"

void main()
{
object oPC=GetLastClosedBy();
object oMe=OBJECT_SELF;
object oItem=GetFirstItemInInventory(oMe);
object oContent;
object oHandyMan;
location lHere=GetLocation(oMe);
string sTag=GetTag(oMe);
string sDB=GetStringLeft(sTag,9);
string sVar="Container#"+GetStringRight(sTag,1);
int nMaxItems=50;  // set maximum storage per container (50 default)
int nBagMax=50; // set maximum number of items inside bags here (50 default)
string sBagMax=IntToString(nBagMax);
int nLoop=1;
int nContents=0;
SetLocked(oMe,TRUE);
while (GetIsObjectValid(oItem))
	{
	// Check for bags that have items in them
	if (GetHasInventory(oItem))
		{
		oContent=GetFirstItemInInventory(oItem);
		while (GetIsObjectValid(oItem))
			{
			nContents++;
			oContent=GetNextItemInInventory(oItem);
			}
		if (nContents > nBagMax)
			{
			SendMessageToPC(oPC,"This container can only store bags with a maximum of "+sBagMax+" items inside of them.");
			SendMessageToPC(oPC,"Please remove bag(s) and remove bag contents in excess of this amount.");
			SetLocked(oMe,FALSE);
			return;
			}
		}
	if (nLoop>nMaxItems)
		{
		SendMessageToPC(oPC,"This container can only store "+IntToString(nMaxItems)+" items.");
		SendMessageToPC(oPC,"Please remove items in excess of this amount.");
		SetLocked(oMe,FALSE);
		return;
		}
	nLoop++;
	oItem = GetNextItemInInventory(oMe);
	}
oHandyMan=CreateObject(OBJECT_TYPE_CREATURE,"bb_handyman",lHere,FALSE);
if (!GetIsObjectValid(oHandyMan)) Debug(oPC,"Error! oHandyMan didn't get created for item storage!");

GiveAllInventory(oMe,oHandyMan,FALSE);
DelayCommand(0.1,DoStoreCampaignObject(sDB,sVar,oHandyMan));
AssignCommand(oHandyMan, SetIsDestroyable(TRUE, FALSE, FALSE));
DestroyObject(oHandyMan,0.5,FALSE);
DelayCommand(1.0,PackCampaignDatabase(sDB));
DelayCommand(1.0,SetLocked(oMe,FALSE));
}