//:: Icequeen's Persistent Housing (10/28/08)
// Author: Icequeen6769

#include "iq_func_lib"

// Returns the Database name for oObject
string PHGetHouseID(object oObject)
{
	return IQGetIDLeft(oObject);
}

// Sets the "For Sale" status of oObject's house
void PHSetIsForSale(object oObject, int bForSale)
{
	string sHouse=PHGetHouseID(oObject);
	SetCampaignInt(sHouse, "For Sale", bForSale);
}

// Returns TRUE if oObject's house is for sale
int PHGetIsForSale(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	return GetCampaignInt(sHouse, "For Sale");
}

// Initializes Database for oObject
void PHInitialize(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	string sHolderName="Icequeen's Dwelling Consignments";
	string sMortAccount="";
	string sMortDB="";
	SetCampaignString(sHouse, "Mortgage Holder", sHolderName);
	SetCampaignString(sHouse, "Mortgage Account", sMortAccount);
	SetCampaignString(sHouse, "Mortgage Database", sMortDB);
	PHSetIsForSale(oObject, TRUE);
}

// Returns House's bottom cost: the minumum housing price for the "Camp" that House is located in.
int PHGetCampHousePrice(object oObject)
{
	int nCamp=StringToInt(GetStringLeft(GetTag(GetArea(oObject)),2));
	if (nCamp==2) return 70000; // area's Tagname begins with "02"
	return 10000; // All other areas
}

// Returns the Mortgage Holder's name for oObject's Area
string PHGetMortgageHolder(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	return GetCampaignString(sHouse, "Mortgage Holder");
}

// Returns the Mortgage Holder's Database for oObject
string PHGetMortgageDatabase(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	return GetCampaignString(sHouse, "Mortgage Database");
}

// Returns the Mortgage Holder's Account for oObject's Area
string PHGetMortgageAccount(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	return GetCampaignString(sHouse, "Mortgage Account");
}

// Sets oObject's house Owner
void PHSetOwner(object oObject, object oBuyer)
{
	string sHouse=PHGetHouseID(oObject);
	SetCampaignString(sHouse, "OwnedBy", SSGetCharacterKey(oBuyer));
}

// Returns owner of oObject's house
string PHGetOwner(object oObject)
{
	string sHouse=PHGetHouseID(oObject);
	return GetCampaignString(sHouse, "OwnedBy");
}

// ---------- Retirement Functions ----------

// Remove a character (and all variables pertaining to that character) from Player's database
// Used to "retire" characters
void PHRemoveDatabaseCharacter(object oPC)
{
	int nLoop;
	int nLocalPrice;
	int nCampPrice;
	int nGPPayment;
	int nTotal;
	object oHouse;
	string sLoop;
	string sHouseID;
	string sMHolder;
	string sMDB;
	string sMAcc;
	string sPDB=SSGetPlayerDatabase(oPC);
	string sKey=SSGetCharacterKey(oPC);
	for (nLoop=0; nLoop<999; nLoop++)
	{
		sLoop=IntToString(nLoop);
		if (nLoop<10) sLoop="0"+sLoop;
		if (nLoop<100) sLoop="0"+sLoop;
		sHouseID="iqphs_"+sLoop;
		oHouse=GetObjectByTag(sHouseID);
		if (PHGetOwner(oHouse)==sKey)
		{
			SetCampaignInt(sHouseID, "For Sale", TRUE);
			DeleteCampaignVariable(sHouseID, "OwnedBy");
			DelayCommand(1.0, PackCampaignDatabase(sHouseID));
			sMDB=PHGetMortgageDatabase(oHouse);
			if (sMDB!="")
			{
				sMAcc=PHGetMortgageAccount(oHouse);
				nCampPrice=PHGetCampHousePrice(oHouse);
				nLocalPrice=GetLocalInt(oHouse, "HousePrice");
				if (nCampPrice>nLocalPrice) nGPPayment=nCampPrice;
				else nGPPayment=nLocalPrice;
				nTotal=GetCampaignInt(sMDB, sMAcc)+nGPPayment;
				DelayCommand(0.5, SetCampaignInt(sMDB, sMAcc, nTotal));
				DelayCommand(1.0, PackCampaignDatabase(sMDB));
			}
		}
	}
}