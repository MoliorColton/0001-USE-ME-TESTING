// Icequeen's Persistent Stores (10/28/08)
// Author: Icequeen6769
// Database Functions

#include "iq_func_lib"

// Return the Database Name for oObject
string PSGetStoreID(object oObject)
{
	return IQGetIDLeft(oObject);
}

// Sets the "For Sale" status of oStore
void PSSetIsForSale(object oStore, int bForSale)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignInt(sDB, "For Sale", bForSale);
}

// Returns TRUE if oStore is for sale
int PSGetIsForSale(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, "For Sale");
}

// Set Owner of oStore to oBuyer
void PSSetOwner(object oStore, object oBuyer)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignString(sDB, "OwnedBy", SSGetCharacterKey(oBuyer));
}

// Return the owner of oStore
string PSGetOwner(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignString(sDB, "OwnedBy");
}

// Save Markup adjustment to database
void PSSetMarkup(object oStore, int nMarkup)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignInt(sDB, "Markup", nMarkup);
}

// Save Markdown adjustment to database
void PSSetMarkdown(object oStore, int nMarkdown)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignInt(sDB, "Markdown", nMarkdown);
}

// Retrieve the stored Markup adjustment from database
int PSGetMarkup(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, "Markup");
}

// Retrieve the stored Markdown adjustment from database
int PSGetMarkdown(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, "Markdown");
}

// Save Store Gold to Database
void PSSetGold(object oStore, int nAmount)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignInt(sDB, "StoreGold", nAmount);
}

// Retrieve Store Gold
int PSGetGold(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, "StoreGold");
}

// Set Store able to buy things
void PSSetBuy(object oStore, int nTrue=0)
{
	string sDB=PSGetStoreID(oStore);
	SetCampaignInt(sDB, "Buying", nTrue);
}

// Get is Store able to buy things
int PSGetBuy(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, "Buying");
}

// Set Salesman's name
void PSSetFirstName(object oStore, string sName)
{
	string sDB=PSGetStoreID(oStore);
	SetFirstName(oStore, sName);
	SetCampaignString(sDB, "OwnerName", sName);
}

// Return Salesman's name
string PSGetFirstName(object oStore)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignString(sDB, "OwnerName");
}

// SetLocalInt & store in database
void PSSetLocalInt(object oStore, string sVar, int nInt)
{
	string sDB=PSGetStoreID(oStore);
	SetLocalInt(oStore, sVar, nInt);
	SetCampaignInt(sDB, sVar, nInt);
}

// Retrieve LocalInt from database
int PSGetLocalInt(object oStore, string sVar)
{
	string sDB=PSGetStoreID(oStore);
	return GetCampaignInt(sDB, sVar);
}

// ---------- Retirement Functions ----------

// Remove a character (and all variables pertaining to that character) from Player's database
// Used to "retire" characters
void PSRemoveDatabaseCharacter(object oPC)
{
	int nLoop;
	object oStore;
	string sLoop;
	string sStoreID;
	string sKey=SSGetCharacterKey(oPC);
	for (nLoop=0; nLoop<1000; nLoop++)
	{
		sLoop=IntToString(nLoop);
		if (nLoop<10) sLoop="0"+sLoop;
		if (nLoop<100) sLoop="0"+sLoop;
		sStoreID="iqpss_"+sLoop;
		oStore=GetObjectByTag(sStoreID);
		if (PSGetOwner(oStore)==sKey)
		{
			SetCampaignString(sStoreID, "OwnedBy", "Bank");
			SetCampaignInt(sStoreID, "For Sale", TRUE);
			DelayCommand(1.0, PackCampaignDatabase(sStoreID));
		}
	}
}