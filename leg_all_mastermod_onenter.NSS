
// Function prototypes
void CloseInventoryScreen(object oPlayer);
void CloseCookSinkMenu(object oPlayer);
void CloseBonesMenu(object oPlayer);
void CloseBoneGrinder(object oPlayer);
void CloseOvenOrFire(object oPlayer);
void CloseNeedleMenu(object oPlayer);
void CloseTannerMenu(object oPlayer);
void CloseChiselMenu(object oPlayer);
void CloseFletchingMenu(object oPlayer);
void CloseCanoeSystem(object oPlayer);
void CloseFletchingMenuDuplicate(object oPlayer);
void CloseSmithingMenu(object oPlayer);
void CloseAnvilMenu(object oPlayer);
void CloseSmeltMenu(object oPlayer);
void CloseRefinerMenu(object oPlayer);
void CloseCharacterScreen(object oPlayer);
void CloseSpiritTreeMenu(object oPlayer);
void CloseGnomeGliderMenu(object oPlayer);
void CloseLoomMenu(object oPlayer);
void CloseBoltTippingMenu(object oPlayer);
void CloseStringingMenu(object oPlayer);
void CloseToolBeltMenu(object oPlayer);
void CloseArrowsMenu(object oPlayer);
void CloseCrateMakingMenu(object oPlayer);
void CloseGlassBlowing(object oPlayer);
void CloseWaterMenu(object oPlayer);
void CloseMillForFlour(object oPlayer);
void CloseStaffMaking(object oPlayer);
void CloseDoughMenu(object oPlayer);
void CloseArtisanQuenchingPool(object oPlayer);
void CloseArtisanFurnace(object oPlayer);
void ClosePestleMortarMenu(object oPlayer);
void CloseSlimeMenu(object oPlayer);



void main()
{
    // Grab the PC (Player Character)
    object oPC = GetEnteringObject();

    // Close individual GUIs
    CloseInventoryScreen(oPC);
    CloseCookSinkMenu(oPC);
    CloseBonesMenu(oPC);
    CloseBoneGrinder(oPC);
    CloseOvenOrFire(oPC);
    CloseNeedleMenu(oPC);
    CloseTannerMenu(oPC);
    CloseChiselMenu(oPC);
    CloseFletchingMenu(oPC);
    CloseCanoeSystem(oPC);
    CloseFletchingMenuDuplicate(oPC);
    CloseSmithingMenu(oPC);
    CloseAnvilMenu(oPC);
    CloseSmeltMenu(oPC);
    CloseRefinerMenu(oPC);
    CloseCharacterScreen(oPC);
    CloseSpiritTreeMenu(oPC);
    CloseGnomeGliderMenu(oPC);
    CloseLoomMenu(oPC);
    CloseBoltTippingMenu(oPC);
    CloseStringingMenu(oPC);
    CloseToolBeltMenu(oPC);
    CloseArrowsMenu(oPC);
    CloseCrateMakingMenu(oPC);
    CloseGlassBlowing(oPC);
    CloseWaterMenu(oPC);
    CloseMillForFlour(oPC);
    CloseStaffMaking(oPC);
    CloseDoughMenu(oPC);
    CloseArtisanQuenchingPool(oPC);
    CloseArtisanFurnace(oPC);
    ClosePestleMortarMenu(oPC);
    CloseSlimeMenu(oPC);

    // Check if the LEG_QUEST_ACTIVE local integer is set in the module
    if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
        // If the quest is active, execute the "leg_quest_loggedin" script with the player character as a parameter
        ExecuteScript("leg_quest_loggedin", oPC);
}

// Function to close the inventory screen
void CloseInventoryScreen(object oPlayer)
{
    CloseGUIScreen(oPlayer, "inventoryscreen.xml");
}

// Function to close the cook sink menu
void CloseCookSinkMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "cooksink.xml");
}

// Function to close the bones menu
void CloseBonesMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "bonesmenu.xml");
}

// Add more functions for other GUI screens as needed
// Repeat the pattern for each GUI screen

// Function for closing Mill For Flour
void CloseMillForFlour(object oPlayer)
{
    CloseGUIScreen(oPlayer, "millforflour.xml");
}

// Function for closing Fletching Menu (duplicate entry)
void CloseFletchingMenuDuplicate(object oPlayer)
{
    CloseGUIScreen(oPlayer, "fletchingmenu.xml");
}
// Function for closing Bone Grinder
void CloseBoneGrinder(object oPlayer)
{
    CloseGUIScreen(oPlayer, "bonegrinder.xml");
}

// Function for closing Oven or Fire
void CloseOvenOrFire(object oPlayer)
{
    CloseGUIScreen(oPlayer, "ovenorfire.xml");
}

// Function for closing Needle Menu
void CloseNeedleMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "needlemenu.xml");
}

// Function for closing Tanner Menu
void CloseTannerMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "tannermenu.xml");
}

// Function for closing Chisel Menu
void CloseChiselMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "chiselmenu.xml");
}

// Function for closing Fletching Menu
void CloseFletchingMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "fletchingmenu.xml");
}

// Function for closing Canoe System
void CloseCanoeSystem(object oPlayer)
{
    CloseGUIScreen(oPlayer, "canoesystem.xml");
}

// Function for closing Smithing Menu
void CloseSmithingMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "smithingmenu.xml");
}

// Function for closing Anvil Menu
void CloseAnvilMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "anvilmenu.xml");
}

// Function for closing Smelt Menu
void CloseSmeltMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "smeltmenu.xml");
}

// Function for closing Refiner Menu
void CloseRefinerMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "refinermenu.xml");
}

// Function for closing Character Screen
void CloseCharacterScreen(object oPlayer)
{
    CloseGUIScreen(oPlayer, "characterscreen.xml");
}

// Function for closing Spirit Tree Menu
void CloseSpiritTreeMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "spirittreemenu.xml");
}

// Function for closing Gnome Glider Menu
void CloseGnomeGliderMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "gnomeglidermenu.xml");
}

// Function for closing Loom Menu
void CloseLoomMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "loommenu.xml");
}

// Function for closing Bolt Tipping Menu
void CloseBoltTippingMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "bolttippingmenu.xml");
}

// Function for closing Stringing Menu
void CloseStringingMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "stringingmenu.xml");
}

// Function for closing Tool Belt Menu
void CloseToolBeltMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "toolbeltmenu.xml");
}

// Function for closing Arrows Menu
void CloseArrowsMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "arrowsmenu.xml");
}

// Function for closing Crate Making Menu
void CloseCrateMakingMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "cratemakingmenu.xml");
}

// Function for closing Glass Blowing
void CloseGlassBlowing(object oPlayer)
{
    CloseGUIScreen(oPlayer, "glassblowing.xml");
}

// Function for closing Water Menu
void CloseWaterMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "watermenu.xml");
}



// Function for closing Staff Making
void CloseStaffMaking(object oPlayer)
{
    CloseGUIScreen(oPlayer, "staffmaking.xml");
}

// Function for closing Dough Menu
void CloseDoughMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "doughmenu.xml");
}

// Function for closing Artisan Quenching Pool
void CloseArtisanQuenchingPool(object oPlayer)
{
    CloseGUIScreen(oPlayer, "artisanquenchingpool.xml");
}

// Function for closing Artisan Furnace
void CloseArtisanFurnace(object oPlayer)
{
    CloseGUIScreen(oPlayer, "artisanfurnace.xml");
}

// Function for closing Pestle Mortar Menu
void ClosePestleMortarMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "pestlemortarmenu.xml");
}

// Function for closing Slime Menu
void CloseSlimeMenu(object oPlayer)
{
    CloseGUIScreen(oPlayer, "slimemenu.xml");
}