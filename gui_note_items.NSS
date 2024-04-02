#include "profession_include"

void CreateOutput(object oPC, int nINPUT_TOTAL, int nOUTPUT_MAXSTACK, int nICON, string sNAME, string sOUTPUT_REF, string sOUTPUT_TAG)
{
    string sINPUT_REF = GetLocalString(oPC, "INPUT_REF");
    object oOUTPUT;
	int nOUTPUT_TOTAL = nINPUT_TOTAL;
	int nOUTPUT_STACK = nOUTPUT_MAXSTACK;
	while (nOUTPUT_TOTAL > 0)
	{
		if (nOUTPUT_TOTAL < nOUTPUT_MAXSTACK) nOUTPUT_STACK = nOUTPUT_TOTAL;
		oOUTPUT = CreateItemOnObject(sOUTPUT_REF, oPC, nOUTPUT_STACK, sOUTPUT_TAG, FALSE);
		SetIdentified(oOUTPUT, TRUE);
		if (sOUTPUT_REF == "noted_item")
		{
			
			SetLocalString(oOUTPUT, "NOTE_REF", sINPUT_REF);	
			SetItemIcon(oOUTPUT, nICON);
			SetFirstName(oOUTPUT, "<c=orange>" + sNAME + "*</c>");
		}	
		nOUTPUT_TOTAL = nOUTPUT_TOTAL - nOUTPUT_MAXSTACK;
	}
}

void DestroyInput(object oPC, object oINPUT, int nINV, int nALL)
{
    int nCACHE = GetNum2DARows("baseitems");
    string sINPUT_REF = GetLocalString(oPC, "INPUT_REF");
    int nINPUT_TYPE = GetBaseItemType(oINPUT);
    string sINPUT_MAXSTACK = Get2DAString("baseitems", "Stacking", nINPUT_TYPE);
    int nINPUT_MAXSTACK = StringToInt(sINPUT_MAXSTACK);
	int nOUTPUT_MAXSTACK = 10000;
	string sOUTPUT_REF = "noted_item";	
	
	if (sINPUT_REF == "noted_item")
	{
		if (nALL == TRUE)
		{
			SendMessageToPC(oPC, "The convert all functionality is not available for noted items. You can only convert them one stack at a time.");
			return;
		}
		sOUTPUT_REF = GetLocalString(oINPUT, "NOTE_REF");
		nOUTPUT_MAXSTACK = GetLocalInt(oINPUT, "NOTE_MAXSTACK");
		if (nOUTPUT_MAXSTACK < 1) nOUTPUT_MAXSTACK = 1;
	}
	else if (nINPUT_MAXSTACK >= 9999)
	{
		SendMessageToPC(oPC, "This function can be used only for items that have a maximum stack size lower than 9999.");
		return;
	}
	
	int nINPUT_STACK = GetItemStackSize(oINPUT);
	int nINPUT_TOTAL = nINPUT_STACK;
	int nITEMS = (nINPUT_TOTAL / nOUTPUT_MAXSTACK);
	if (nINV + nITEMS > 128)
	{
		SendMessageToPC(oPC, "You are attempting to convert too many items. Please use a smaller stack.");
		return;
	}
	
	int nICON = GetItemIcon(oINPUT);
	string sNAME = GetName(oINPUT);
	string sINPUT_TAG = GetTag(oINPUT);	
	if (nALL == TRUE)
	{
		object oINVALID = OBJECT_INVALID;
		object oITEM = GetFirstItemInInventory(oPC);
		while (oITEM != oINVALID)
		{
			if (GetTag(oITEM) == sINPUT_TAG)
			{
				if (GetResRef(oITEM) == sINPUT_REF)
				{
					if (oITEM != oINPUT)
					{
						nINPUT_TOTAL = nINPUT_TOTAL + GetItemStackSize(oITEM);
						DestroyObject(oITEM, 0.0f, FALSE);
					}
				}
			}
			oITEM = GetNextItemInInventory(oPC);
		}
	}
	DestroyObject(oINPUT, 0.0f, FALSE);
DelayCommand(0.0f, CreateOutput(oPC, nINPUT_TOTAL, nOUTPUT_MAXSTACK, nICON, sNAME, sOUTPUT_REF, sINPUT_TAG));
}

void main(string sCOMMAND)
{
    if (sCOMMAND != "NOTEITEM") {
        return;
    }
    object oPC = GetPCSpeaker();
    object oINPUT = GetPlayerCurrentTarget(oPC);
    string sINPUT_REF = GetResRef(oINPUT);
    if (GetItemPossessor(oINPUT) != oPC)
    {
        SendMessageToPC(oPC, "Please target one of the items in your possession.");
        return;
    }
    if (GetPlotFlag(oINPUT) == TRUE)
    {
        SendMessageToPC(oPC, "Plot items are not eligible for this service.");
        return;
    }
    if (GetItemCursedFlag(oINPUT) == TRUE)
    {
        SendMessageToPC(oPC, "Cursed items are not eligible for this service.");
        return;
    }
    if (GetIdentified(oINPUT) == FALSE)
    {
        SendMessageToPC(oPC, "You must identify an item before noting it.");
        return;
    }
    int nINV = GetInventoryNum(oPC);
    if (nINV > 127)
    {
        SendMessageToPC(oPC, "You must have at least one free slot in your inventory to use this service (this is necessary to avoid potential item losses).");
        return;
    }
    SetLocalString(oPC, "INPUT_REF", sINPUT_REF);
    int nINPUT_TYPE = GetBaseItemType(oINPUT);
    string sINPUT_MAXSTACK = Get2DAString("baseitems", "Stacking", nINPUT_TYPE);
    int nINPUT_MAXSTACK = StringToInt(sINPUT_MAXSTACK);
    int nINPUT_STACK = GetItemStackSize(oINPUT);
    int nINPUT_TOTAL = nINPUT_STACK;
    int nOUTPUT_MAXSTACK = 10000;
    string sOUTPUT_REF = "noted_item";
    if (sINPUT_REF == "noted_item")
    {
        sOUTPUT_REF = GetLocalString(oINPUT, "NOTE_REF");
        nOUTPUT_MAXSTACK = GetLocalInt(oINPUT, "NOTE_MAXSTACK");
        if (nOUTPUT_MAXSTACK < 1) nOUTPUT_MAXSTACK = 1;
    }
    else if (nINPUT_MAXSTACK >= 9999)
    {
        SendMessageToPC(oPC, "This function can be used only for items that have a maximum stack size lower than 9999.");
        return;
    }
    int nICON = GetItemIcon(oINPUT);
    string sNAME = GetName(oINPUT);
    string sINPUT_TAG = GetTag(oINPUT);
    if (nINV + (nINPUT_TOTAL / nOUTPUT_MAXSTACK) > 128)
    {
        SendMessageToPC(oPC, "You are attempting to convert too many items. Please use a smaller stack.");
        return;
    }
    DestroyObject(oINPUT);
    DelayCommand(0.0f, CreateOutput(oPC, oINPUT, nOUTPUT_MAXSTACK, nICON, sNAME, sOUTPUT_REF, sINPUT_TAG));
}