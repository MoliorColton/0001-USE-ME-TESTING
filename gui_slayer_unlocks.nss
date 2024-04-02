#include "profession_include"
#include "nw_i0_spells"
#include "_dc_strings"
	
void CloseInterface(object oPC)
{

	DeleteLocalString(oPC, "OUTPUT_TAG");
	DeleteLocalString(oPC, "INPUT_TAG_A");
	DeleteLocalInt(oPC, "INPUT_QTY_A");
	DeleteLocalInt(oPC, "OUTPUT_QTY");
	DeleteLocalInt(oPC, "OUTPUT_MULT");
	DeleteLocalInt(oPC, "OUTPUT_REQ");
	DeleteLocalInt(oPC, "OUTPUT_STOP");

	
	DeleteLocalString(oPC, "INPUT_TAG_B");
	DeleteLocalInt(oPC, "INPUT_QTY_B");
	
	DeleteLocalString(oPC, "INPUT_TAG_C");
	DeleteLocalInt(oPC, "INPUT_QTY_C");

	DeleteLocalFloat(oPC, "PROF_TIME");
	DeleteLocalFloat(oPC, "PROF_LOOP");
	RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oPC);
	CloseGUIScreen(oPC, "SCREEN_SHOP_LOOP");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE));
}

void main (string sUNLOCK, string sCOSTa, string sCURRENCYa, string sCOSTb, string sCURRENCYb, string sCOSTc, string sCURRENCYc, string sPRODUCT, string sQUANTITY)
{
	int nCOSTa = StringToInt(sCOSTa);
	int nCOSTb = StringToInt(sCOSTb);
	int nCOSTc = StringToInt(sCOSTc);
	object oPC = OBJECT_SELF;
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
int nCurrencyAQuantity = GetItemQuantity(oPC, sCURRENCYa);
int nCurrencyBQuantity = GetItemQuantity(oPC, sCURRENCYb);
int nCurrencyCQuantity = GetItemQuantity(oPC, sCURRENCYc);
string sText = "Your remaining Slayer Points: " + IntToString(nCurrencyAQuantity); // Create the message string
SendMessageToPC(oPC, sText); // Send the message to the PC

	if (GetItemQuantity(oPC, sCURRENCYc) < nCOSTc){
		SendMessageToPC(oPC, "You need a Might Slayer Helmet to unlock this cosmetic."); //changed "currency" to "Slayer Points"'. 
		CloseInterface(oPC);
		return;
	}
	
	if (GetItemQuantity(oPC, sCURRENCYb) < nCOSTb){
		SendMessageToPC(oPC, "You do not have the required item for this."); //changed "currency" to "Slayer Points"'. 
		CloseInterface(oPC);
		return;
	}



	if (GetItemQuantity(oPC, sCURRENCYa) < nCOSTa){
		SendMessageToPC(oPC, "You do not have enough Slayer Points for this."); //changed "currency" to "Slayer Points"'. 
		CloseInterface(oPC);
		return;
	}
	switch (StringToInt(sUNLOCK)){
		case 0: break;
		case 1: sUNLOCK = "BROADER_FLETCHING"; break;
		case 2: sUNLOCK = "RING_BLING"; break;
		case 3: sUNLOCK = "MALEVOLENT_MASQUERADE0"; break;
		case 4: sUNLOCK = "MALEVOLENT_MASQUERADE1"; break;
		case 5: sUNLOCK = "MALEVOLENT_MASQUERADE2"; break;
		case 6: sUNLOCK = "MALEVOLENT_MASQUERADE3"; break;
		case 7: sUNLOCK = "KING_BLACK_BONNET"; break;
		case 8: sUNLOCK = "UNHOLY_HELMET"; break;
		case 9: sUNLOCK = "KALPHITE_KHAT"; break;
		case 10: sUNLOCK = "TZKAL_CAP"; break;
		case 11: if (GetLocalInt(oESSENCE, "SLAYER_ROW") != 0) {DeleteLocalInt(oESSENCE, "SLAYER_ROW"); DeleteLocalInt(oESSENCE, "SLAYER_KILLS"); DeleteLocalInt(oESSENCE, "SLAYER_TOTAL"); RemoveItems(oPC, sCURRENCYa, nCOSTa); SendMessageToPC(oPC, "Slayer Task Abandoned."); CloseInterface(oPC); break;}
		default: SendMessageToPC(oPC, "Tell the devs that Art's gui_slayer_unlocks is bugged");
	}
	if (GetLocalInt(oPC, sUNLOCK) == 0){
		if (GetLocalInt(oPC, sUNLOCK) == 0) {
			SetLocalInt(oPC, sUNLOCK, 1); 
			RemoveItems(oPC, sCURRENCYa, nCOSTa);
			RemoveItems(oPC, sCURRENCYb, nCOSTb);
			RemoveItems(oPC, sCURRENCYc, nCOSTc);
			CreateItemOnObject(sPRODUCT, oPC, StringToInt(sQUANTITY)); // added this line because the first time you buy something it would take your points and give you nothing in return.
			//SendMessageToPC(oPC, "You've learned something new."); // hid this because learning something new =/= buying a slayer ring.
		} 
		else {
			SendMessageToPC(oPC, "You've already bought this."); //changed the output to be more specific.
		} 
		CloseInterface(oPC);
		return;
	}
	if (GetInventoryNum(oPC) >= 128)
	{
		SendMessageToPC(oPC, "Your inventory is full.");
		CloseInterface(oPC);
		return;
	}
	RemoveItems(oPC, sCURRENCYb, nCOSTb);
	RemoveItems(oPC, sCURRENCYa, nCOSTa);
	RemoveItems(oPC, sCURRENCYc, nCOSTc);
	CreateItemOnObject(sPRODUCT, oPC, StringToInt(sQUANTITY));
}