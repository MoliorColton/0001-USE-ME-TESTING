#include "profession_include"

void main()
{
    object oPC = OBJECT_SELF;
    object oCONTROL = GetControlledCharacter(oPC);
	string sSCREEN = "SCREEN_INVENTORY";

    // Define variables to store total XP and level for each skill
    int nTotalXP = 0;
    int nTotalLevel = 0;

    // Retrieve XP and level for each skill and add it to the total
    // Fishing Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_30");
    nTotalLevel += GetSkillRank(SKILL_FISHING, oPC);

    // Cooking Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_31");
    nTotalLevel += GetSkillRank(SKILL_COOKING, oPC);

    // Firemaking Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_32");
    nTotalLevel += GetSkillRank(SKILL_FIREMAKING, oPC);

    // Smithing Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_33");
    nTotalLevel += GetSkillRank(SKILL_SMITHING, oPC);

    // Woodcutting Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_34");
    nTotalLevel += GetSkillRank(SKILL_WOODCUTTING, oPC);

    // Mining Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_35");
    nTotalLevel += GetSkillRank(SKILL_MINING, oPC);

    // Runecrafting Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_36");
    nTotalLevel += GetSkillRank(SKILL_RUNECRAFTING, oPC);

    // Crafting Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_37");
    nTotalLevel += GetSkillRank(SKILL_CRAFTING, oPC);

    // Prayer Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_38");
    nTotalLevel += GetSkillRank(SKILL_PRAYER, oPC);

    // Construction Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_39");
    nTotalLevel += GetSkillRank(SKILL_CONSTRUCTION, oPC);

    // Agility Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_40");
    nTotalLevel += GetSkillRank(SKILL_AGILITY, oPC);

    // Herblore Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_41");
    nTotalLevel += GetSkillRank(SKILL_HERBLORE, oPC);

    // Thieving Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_42");
    nTotalLevel += GetSkillRank(SKILL_THIEVING, oPC);

    // Fletching Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_43");
    nTotalLevel += GetSkillRank(SKILL_FLETCHING, oPC);

    // Slayer Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_44");
    nTotalLevel += GetSkillRank(SKILL_SLAYER, oPC);

    // Hunter Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_45");
    nTotalLevel += GetSkillRank(SKILL_HUNTER, oPC);

    // Farming Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_46");
    nTotalLevel += GetSkillRank(SKILL_FARMING, oPC);

    // Barrows Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_47");
    nTotalLevel += GetSkillRank(SKILL_BARROWS, oPC);

    // Buying Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_48");
    nTotalLevel += GetSkillRank(SKILL_BUYING, oPC);

    // Production Skill
    nTotalXP += GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_49");
    nTotalLevel += GetSkillRank(SKILL_PRODUCTION, oPC);
    
	
	// If the total XP is greater than 199,999,999, display "LOTS!"
    // If the total XP is greater than 99,999,999, but less than or equal to 199,999,999, remove the last 6 digits
    string sTotalXPText;
    if (nTotalXP > 199999999)
    {
        sTotalXPText = "LOTS!";
    }
    else if (nTotalXP > 99999999)
    {
        nTotalXP = nTotalXP / 1000000 * 1000000; // Remove the last 6 digits
        sTotalXPText = IntToString(nTotalXP / 1000000) + "m"; // Convert to millions and append "m"
    }
    else
    {
        // Convert total XP to string
        sTotalXPText = IntToString(nTotalXP);
    }

    // Convert total level to string
    string sTotalLevelText = IntToString(nTotalLevel);

    // Set GUI object text for total XP and level
    SetGUIObjectText(oPC, "SCREEN_INVENTORY", "TOTAL_XP", -1, sTotalXPText);
}