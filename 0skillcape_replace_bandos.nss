void main()
{
    object oPC = GetItemPossessor(OBJECT_SELF); // Get the player character

    object oItem1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC); // Get the first item (adjust slot as needed)
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);  // Get the second item (adjust slot as needed)

    if (GetTag(oItem1) == "bcp" && GetTag(oItem2) == "skillcapetest")
    {
        // Set a local variable on the PC to keep track of the state
        SetLocalInt(oPC, "cape_replaced", FALSE);

        // Assign event handler to oItem1
        SetEventHandler(oItem1, EventUnEquipItem, "cape_check_script");
    }
}
