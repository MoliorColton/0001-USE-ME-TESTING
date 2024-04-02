void ItemQuantityChanged(object oItem, int nNewQuantity)
{
    int nCurrentStackSize = GetRemainingStackSize(oITEM);
    nCurrentStackSize -= nQTY;
    SetRemainingStackSize(oITEM, nCurrentStackSize);
    // only do something if the new quantity is less than the previous one
    if (nNewQuantity < GetLocalInt(oItem, "OLD_QUANTITY"))
    {
        // get the difference in quantity
        int nDifference = GetLocalInt(oItem, "OLD_QUANTITY") - nNewQuantity;
        // get the tag of the item
        string sTag = GetTag(oItem);
        // get the item's possessor
        object oPossessor = GetItemPossessor(oItem);
        // destroy the old item
        DestroyObject(oItem);
        // create a new item with the new quantity
        CreateItemOnObject(sTag, oPossessor, nNewQuantity);
    }
    // store the current quantity as the old quantity
    SetLocalInt(oItem, "OLD_QUANTITY", nNewQuantity);
}

void main()
{
    // register the event
    RegisterEvent(EVENT_TYPE_LATER_ITEM_QUANTITY_CHANGED, "ItemQuantityChanged");
}