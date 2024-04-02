void main()
{
    object oPC = GetItemPossessor(OBJECT_SELF); // Get the player character

    object oItem1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC); // Get the first item (adjust slot as needed)
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);  // Get the second item (adjust slot as needed)

    if (GetTag(oItem1) == "bcp" && GetTag(oItem2) == "skillcapetest")
    {
        // Unequip item 2
        ActionUnequipItem(oItem2);

        // Destroy item 2
        DestroyObject(oItem2);

        // Create and equip the new item
        object oNewItem = CreateItemOnObject("skillcapetest1", oPC, 1);
        ActionEquipItem(oNewItem, INVENTORY_SLOT_CLOAK);
    }
}
