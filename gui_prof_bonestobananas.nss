#include "nw_i0_spells"
#include "profession_include"

void BonestoBananasInitiate(object oPC)
{
    object oITEM = GetPlayerCurrentTarget(oPC);
    string sTXT;
    int nFAIL;
    effect eVFX;
    string sItem1 = "naturerune";
    string sItem2 = "waterrune";
    string sItem3 = "earthrune";
	int maxInvSize = 128;
	int currentInvSize = GetInventoryNum(oPC);

    //get the tag of the item
    string sITEM_TAG = GetTag(oITEM);
    //set some local variables on the player object for later use
    SetLocalObject(oPC, "BONES_INPUT", oITEM);
    //level requirement
    int nREQ = 15;
    int nRANK = GetSkillRank(SKILL_RUNECRAFTING, oPC);
    if (nRANK < nREQ)
    {
        sTXT = "You need " + IntToString(nREQ) + " ranks in Runecrafting to cast this spell.";
        SendMessageToPC(oPC, sTXT);
        return;
    }

    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only cast this spell on bones in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        return;
    }

    if (GetItemQuantity(oPC, "naturerune") < 1)
        nFAIL = TRUE;
    else if (GetItemQuantity(oPC, "waterrune") < 2)
        nFAIL = TRUE;
    else if (GetItemQuantity(oPC, "earthrune") < 2)
        nFAIL = TRUE;

    if (nFAIL == TRUE)
    {
        SendMessageToPC(oPC, "You need at least 1 nature, 2 earth, and 2 water runes");
        return;
    }
        int nFindBones = FindSubString(sITEM_TAG, "bones");
        if (nFindBones == -1)
        {
            SendMessageToPC(oPC, "This item cannot be transformed.");
            return;
        }
    else
    {
		
        if (sITEM_TAG == "dragonbones")
		
        {
		// Check if the player has 5 free inventory slots
    	int maxInvSize = 128;
    	int currentInvSize = GetInventoryNum(oPC);
    	int freeSpace = maxInvSize - currentInvSize;
    	if (freeSpace < 5)
    	{
        	SendMessageToPC(oPC, "You need at least 5 free inventory spaces.");
        	return;
    	}

            // remove the used items from the player's inventory, play VFX, play animation
            AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "worship", TRUE));
            eVFX = EffectNWN2SpecialEffectFile("fx_bonestobananas");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
 			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
            RemoveItems(oPC, "naturerune", 1);
            RemoveItems(oPC, "waterrune", 2);
            RemoveItems(oPC, "earthrune", 2);
            RemoveItems(oPC, sITEM_TAG, 1);
            //amount of XP given
            int nXP = 25;
            //Skill 2da ID
            int nSKILL = 36;
            DelayCommand(1.5, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
            ExecuteScript("profession_action", oPC);
            return;
        }
		else if (sITEM_TAG == "bigbones")
		
        {
		// Check if the player has 5 free inventory slots
    	int maxInvSize = 128;
    	int currentInvSize = GetInventoryNum(oPC);
    	int freeSpace = maxInvSize - currentInvSize;
    	if (freeSpace < 3)
    	{
        	SendMessageToPC(oPC, "You need at least 3 free inventory spaces.");
        	return;
    	}

            // remove the used items from the player's inventory, play VFX, play animation
            AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "worship", TRUE));
            eVFX = EffectNWN2SpecialEffectFile("fx_bonestobananas");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
 			CreateItemOnObject("Banana", oPC);
            // create the banana item in the player's inventory
			CreateItemOnObject("Banana", oPC);

            RemoveItems(oPC, "naturerune", 1);
            RemoveItems(oPC, "waterrune", 2);
            RemoveItems(oPC, "earthrune", 2);
            RemoveItems(oPC, sITEM_TAG, 1);
            //amount of XP given
            int nXP = 25;
            //Skill 2da ID
            int nSKILL = 36;
            DelayCommand(1.5, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
            ExecuteScript("profession_action", oPC);
            return;
        }
        else
        {
		// Check if the player has 5 free inventory slots
    	int maxInvSize = 128;
    	int currentInvSize = GetInventoryNum(oPC);
    	int freeSpace = maxInvSize - currentInvSize;
    	if (freeSpace < 1)
    	{
        	SendMessageToPC(oPC, "You need at least 1 free inventory space.");
        	return;
    	}
            // remove the used items from the player's inventory, play VFX, play animation
            AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "worship", TRUE));
            eVFX = EffectNWN2SpecialEffectFile("fx_bonestobananas");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
            // create the noted item in the player's inventory
            CreateItemOnObject("Banana", oPC);
            // remove the bones & Runes from the player's inventory
            RemoveItems(oPC, "naturerune", 1);
            RemoveItems(oPC, "waterrune", 2);
            RemoveItems(oPC, "earthrune", 2);
            RemoveItems(oPC, sITEM_TAG, 1);
            //amount of XP given
            int nXP = 25;
            //Skill 2da ID
            int nSKILL = 36;
            DelayCommand(1.5, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
            ExecuteScript("profession_action", oPC);
            return;
        }
    }
}

void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    if (sCOMMAND == "BONESTOBANANAS")
        BonestoBananasInitiate(oPC);
    else
        return;
}