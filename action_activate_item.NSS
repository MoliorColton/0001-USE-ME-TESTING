// action_activate_item.nss

void main()
{
    object oPC = GetItemActivator();
    object oModule = GetModule();
    object oItem = GetItemActivated();

    // Set the local variables on the module object
    SetLocalObject(oModule, "ACTIVATING_PLAYER", oPC);
    SetLocalObject(oModule, "ACTIVATED_ITEM", oItem);

    // Execute the delayed script to handle the activated item
    DelayCommand(0.1, ExecuteScript("handle_activated_item", OBJECT_SELF));
}
