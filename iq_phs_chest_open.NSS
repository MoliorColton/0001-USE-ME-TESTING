//:: Icequeen's Persistent Housing (10/28/08)
//:: Persistent storage
//:: On-open event

#include "ginc_item"

void main()
{
object oMe=OBJECT_SELF;
object oHandyMan;
location lHere=GetLocation(oMe);
string sTag=GetTag(oMe);
string sDB=GetStringLeft(sTag,9);
string sVar="Container#"+GetStringRight(sTag,1);
oHandyMan=RetrieveCampaignObject(sDB,sVar,lHere);
AssignCommand(oHandyMan, SetIsDestroyable(TRUE, FALSE, FALSE));
if (GetIsObjectValid(oHandyMan))
	{
	GiveAllInventory(oHandyMan,oMe,FALSE);
	DelayCommand(0.1,DestroyObject(oHandyMan));
	}
}