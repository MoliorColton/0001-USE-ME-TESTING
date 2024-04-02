// open_store_nosfe
/*
	Opens store with tag sTag for the PC Speaker.  
	nMarkUp/nMarkDown are a percentage value that modifies the base price for an item.
	Function also adds or subtracts numbers to the markup and markdown values depending on the result of the appraise skill check.
*/
// ChazM 5/9/06 - changed to gplotAppraiseOpenStore
// ChazM 8/30/06 - new appraise open store function used.
// Nosfe 8/16/07 - Store from database

//#include "ginc_misc"
//#include "nw_i0_plot"
#include "ginc_param_const"
#include "ginc_item"
	
void StartShop(object oPC)
{
	
	string sTag = GetLocalString(OBJECT_SELF,"store_name"); //va chercher la variable du nom du magasin
	int nMarkUp = GetLocalInt(GetObjectByTag(sTag),"nMARKUP");
	int nMarkDown = GetLocalInt(GetObjectByTag(sTag),"nMARKDOWN"); ;
	
	//OpenStore(GetTarget(sTag), oPC, nMarkUp, nMarkDown);	
	N2_AppraiseOpenStore(GetTarget(sTag), oPC, nMarkUp, nMarkDown);
	
}

void main()
{
	object oPC;
	if (GetPCSpeaker()==OBJECT_INVALID) 
	{
	  oPC = OBJECT_SELF;
	}else {
	  oPC = GetPCSpeaker();
	}
	WriteTimestampedLogEntry("blablabla debug du writeTimestamped");
	if (GetIsObjectValid(oPC) == 1) 
	{
		StartShop(oPC); // on ouvre l'UI shop
	}
}