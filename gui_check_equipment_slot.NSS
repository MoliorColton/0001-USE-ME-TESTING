// Script name: gui_check_equipment_slot
void main()
{
    object oPC = GetItemPossessor(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF));

    if(oPC != OBJECT_INVALID)
    {
        string sScreenName = "SCREEN_INVENTORY"; // Replace with the actual screen name
        string sUIObjectName = "FILLED_SLOT_CHEST";
        int bHidden = (GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) == OBJECT_INVALID);
        SetGUIObjectHidden(oPC, sScreenName, sUIObjectName, bHidden);
    }
    else
    {
        // If the chest slot is filled, make the UIIcon visible
        string sScreenName = "SCREEN_INVENTORY"; // Replace with the actual screen name
        string sUIObjectName = "FILLED_SLOT_CHEST";
        int bHidden = FALSE; // Set to FALSE to show the UIIcon
        SetGUIObjectHidden(oPC, sScreenName, sUIObjectName, bHidden);
    }
}
