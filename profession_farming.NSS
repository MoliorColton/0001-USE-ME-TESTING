#include "table_farming"


void CheckPlant(object oPLANT, object oPC)
{
    int nSKILL = GetSkillRank(SKILL_FARMING, oPC);
    int nChanceToEnterStage4;

    if (nSKILL < 10) nChanceToEnterStage4 = 50;
    else if (nSKILL < 30) nChanceToEnterStage4 = 25;
    else if (nSKILL < 50) nChanceToEnterStage4 = 10;
    else if (nSKILL < 70) nChanceToEnterStage4 = 5;
    else if (nSKILL < 92) nChanceToEnterStage4 = 3;
    else nChanceToEnterStage4 = 1;

    if (Random(100) < nChanceToEnterStage4)
    {
        HarvestPlant(oPC, oPLANT);
    }
    else
    {
        FloatingTextStringOnCreature("This plant is ill. You will need to use a Plant Cure to harvest it.", oPC, FALSE);
        SetLocalInt(oPLANT, "PLANT_STAGE", 4);

        // Add special effect when the plant is ill
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpecialEffectDeadPlant, oPLANT);
    }
}

void main()
{

    // Get a reference to the plant (placeable) triggering this script
    object oPLANT = OBJECT_SELF;
    
    // Get the last player character (PC) that used the plant
    object oPC = GetLastUsedBy();

    // Check if the object that used the plant is a player character (PC)
    if (GetIsPC(oPC) == FALSE)
        return;  // If not, exit the function

    // Get the current stage of the plant from its local integer variable "PLANT_STAGE"
    int nSTAGE = GetLocalInt(oPLANT, "PLANT_STAGE");


    // Use a switch statement to perform different actions based on the plant's stage
    switch (nSTAGE)
    {
        case 1: 
        {
           FloatingTextStringOnCreature("This plant has been recently planted. Compost is needed to make it grow.", oPC, FALSE);
           break;
        }

		case 2: 
		{
    		// Display a message indicating that the plant is growing
    		FloatingTextStringOnCreature("This plant is growing.", oPC, FALSE); 
    		break;
		}
        case 3: 
		{
			
            // If the plant is in stage 3, check its health using the CheckPlant function
            CheckPlant(oPLANT, oPC); 
            break;
		}

        case 4: 
        {
            // If the plant is in stage 4, display a message about it being ill and needing a Plant Cure
            FloatingTextStringOnCreature("This plant is ill. You will need to use a Plant Cure to harvest it.", oPC, FALSE); 
            break;
        }
    }
}