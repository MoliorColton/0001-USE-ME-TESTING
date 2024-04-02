//-----------------------------------------------------------------------
// <copyright file="gui_tb_invitemdoubleclick.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
//used in contextmenu.xml under node-item-equip. leftclick1 calls it
//used in inventoryscreen.xml. leftclick gets item, leftdoubleclick0 under InvPrototypeButton and dropreceived on all equipment slots calls this
//set commandable 0 to block the hardcoded UI event leftdoubleclick1=UIButton_Input_InventoryButtonActivate() 
#include "tb_effects"
#include "g_tb_guiinclude"
void main(int  iTarget)
{
	// GUI SENDS OBJECT AS AN INT
	//object oTarget = IntToObject(iTarget);
	//SendMessageToPC(oPC, "it "+GetName(oTarget));
    object oPC   = OBJECT_SELF;
	object oItem =  IntToObject(iTarget);
	//if (levelreq > 0)
	//{//equip item event
	AddScriptParameterInt(iTarget);
	ExecuteScriptEnhanced("gui_tb_playerequipitem",oPC);
	//SendMessageToPC(oPC, "going to playerequipitem");
	//}
	int foodhealth = GetLocalInt(oItem, "tbeat");
	//Triston's level check on equip
	int levelreq = GetLocalInt(oItem, "level");
	string prayer = GetLocalString(oItem, "prayer");
	if (foodhealth > 0)
	{
		BreakGUI();
		if (GetLocalInt(oPC, "TBusecooldown") == 0)
		{
			SetLocalInt(oPC, "TBusecooldown", 1);
			DelayCommand(10.0, DeleteLocalInt(oPC, "TBusecooldown"));
			TBEffect(oPC, "heal", IntToString(foodhealth));
			DestroyObject(oItem);
			//if (GetLocalInt(oPC, "testdestroy") == 0){SetLocalInt(oPC, "testdestroy",1);DestroyObject(oItem);SendMessageToPC(oPC,"Testing item destroy against effects");}
			//SendMessageToPC(oPC, "healing player");
		}//else{SendMessageToPC(oPC, "d-click cooldown");}
	}
	if (prayer != "")
	{
		BreakGUI();
		if (GetLocalInt(oPC, "TBusecooldown") == 0)
		{
			SetLocalInt(oPC, "TBusecooldown", 1);
			DelayCommand(10.0, DeleteLocalInt(oPC, "TBusecooldown"));
			//SendMessageToPC(oPC, "prayer book activated!");
			DestroyObject(oItem);
			//if (GetLocalInt(oPC, "testdestroy") == 0){SetLocalInt(oPC, "testdestroy",1);DestroyObject(oItem);SendMessageToPC(oPC,"Testing item destroy against effects");}
			string sMessage;
			if (prayer == "burstofstrength")	{TBEffect(oPC, "AbilityIncrease", "0,2", "T,300.0f", 0);sMessage = "As you read the book, you feel like you could deliver the heaviest swings.";}
			if (prayer == "eagleeye")			{TBEffect(oPC, "AbilityIncrease", "1,6", "T,300.0f", 0);sMessage = "As you read the book, you spot your prey with ease.";}
			if (prayer == "hawkeye")			{TBEffect(oPC, "AbilityIncrease", "1,4", "T,300.0f", 0);sMessage = "As you read the book, your senses become quicker.";}
			if (prayer == "mysticlore")			{TBEffect(oPC, "AbilityIncrease", "3,4", "T,300.0f", 0);sMessage = "As you read the book, you feel more powerful with energy.";}
			if (prayer == "mysticmight")		{TBEffect(oPC, "AbilityIncrease", "3,6", "T,300.0f", 0);sMessage = "As you read the book, you feel energy flowing through your veins.";}
			if (prayer == "mysticwill")			{TBEffect(oPC, "AbilityIncrease", "3,2", "T,300.0f", 0);sMessage = "As you read the book, elements bend at your will.";}
			if (prayer == "rockskin")			{TBEffect(oPC, "AbilityIncrease", "2,4", "T,300.0f", 0);sMessage = "As you read the book, your body becomes tougher.";}
			if (prayer == "sharpeye")			{TBEffect(oPC, "AbilityIncrease", "1,2", "T,300.0f", 0);sMessage = "As you read the book, your vision becomes sharper.";}
			if (prayer == "steelskin")			{TBEffect(oPC, "AbilityIncrease", "2,6", "T,300.0f", 0);sMessage = "As you read the book, you feel as if you're wearing an extra set of armour.";}
			if (prayer == "superhumanstrength")	{TBEffect(oPC, "AbilityIncrease", "0,4", "T,300.0f", 0);sMessage = "As you read the book, objects begin to feel a lot lighter.";}
			if (prayer == "thickskin")			{TBEffect(oPC, "AbilityIncrease", "2,2", "T,300.0f", 0);sMessage = "As you read the book, you feel like you could endure the strongest blows.";}
			if (prayer == "ultimatestrength")	{TBEffect(oPC, "AbilityIncrease", "0,6", "T,300.0f", 0);sMessage = "As you read the book, the ground begins to tremble as you walk.";}
			SendMessageToPC(oPC, sMessage);
		}//else{SendMessageToPC(oPC, "d-click cooldown");}
	}
	//SendMessageToPC(oPC, "gui invitemdoubleclick equip:" + IntToString(iTarget) + " name:" + GetName(oItem));
}