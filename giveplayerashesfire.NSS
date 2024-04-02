#include "nw_i0_spells"

void main()
{
    // Get a reference to the player object
    object oPC = OBJECT_SELF;
    // Get the area where the script starts
    object oArea = GetArea(OBJECT_SELF);

    // Check if the player object is valid
    if (GetIsObjectValid(oPC)) {
        // Check if the player is in the same area as the script starts
        if (GetArea(oPC) == oArea) {
            // Check if player is within 2 units of the fire
            if (GetDistanceToObject(oPC) <= 5.0) {
                SendMessageToPC(oPC, "The fire has gone out.");
                SendMessageToPC(oPC, "You scoop up the ashes into your backpack. TEST");
                object oAshes = CreateItemOnObject("ashes", oPC, 1);
            }
            else {
                object oAshes = CreateItemOnObject("ashes", OBJECT_SELF, 1);
            }
        }
        else {
            SendMessageToPC(oPC, "You must be in the same area as the fire to pick up the ashes.");
        }
    }
}