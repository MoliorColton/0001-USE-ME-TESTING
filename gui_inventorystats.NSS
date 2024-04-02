#include "profession_include"


void main()
{
    object oPC = OBJECT_SELF;
    object oControlled = GetControlledCharacter(oPC);
    string sScreen = "SCREEN_INVENTORY";

    int nFishingRank = GetSkillRank(SKILL_FISHING, oControlled, TRUE);
    int nCookingRank = GetSkillRank(SKILL_COOKING, oControlled, TRUE);
    int nFiremakingRank = GetSkillRank(SKILL_FIREMAKING, oControlled, TRUE);
    int nSmithingRank = GetSkillRank(SKILL_SMITHING, oControlled, TRUE);
    int nWoodcuttingRank = GetSkillRank(SKILL_WOODCUTTING, oControlled, TRUE);
    int nMiningRank = GetSkillRank(SKILL_MINING, oControlled, TRUE);
    int nRunecraftingRank = GetSkillRank(SKILL_RUNECRAFTING, oControlled, TRUE);
    int nCraftingRank = GetSkillRank(SKILL_CRAFTING, oControlled, TRUE);
    int nPrayerRank = GetSkillRank(SKILL_PRAYER, oControlled, TRUE);
    int nHerbloreRank = GetSkillRank(SKILL_HERBLORE, oControlled, TRUE);
    int nThievingRank = GetSkillRank(SKILL_THIEVING, oControlled, TRUE);
    int nFletchingRank = GetSkillRank(SKILL_FLETCHING, oControlled, TRUE);
    int nSlayerRank = GetSkillRank(SKILL_SLAYER, oControlled, TRUE);
    int nFarmingRank = GetSkillRank(SKILL_FARMING, oControlled, TRUE);
	int nHunterRank = GetSkillRank(SKILL_HUNTER, oControlled, TRUE);

    // Cap skill ranks
    if (nFishingRank > 99) nFishingRank = 99;
    if (nCookingRank > 99) nCookingRank = 99;
    if (nFiremakingRank > 99) nFiremakingRank = 99;
    if (nSmithingRank > 99) nSmithingRank = 99;
    if (nWoodcuttingRank > 99) nWoodcuttingRank = 99;
    if (nMiningRank > 99) nMiningRank = 99;
    if (nRunecraftingRank > 99) nRunecraftingRank = 99;
    if (nCraftingRank > 99) nCraftingRank = 99;
    if (nPrayerRank > 99) nPrayerRank = 99;
    if (nHerbloreRank > 99) nHerbloreRank = 99;
    if (nThievingRank > 99) nThievingRank = 99;
    if (nFletchingRank > 99) nFletchingRank = 99;
    if (nSlayerRank > 99) nSlayerRank = 99;
    if (nFarmingRank > 99) nFarmingRank = 99;
	if (nHunterRank > 99) nHunterRank = 99;

    // Convert ranks to strings
    string sFishingRank = IntToString(nFishingRank);
    string sCookingRank = IntToString(nCookingRank);
    string sFiremakingRank = IntToString(nFiremakingRank);
    string sSmithingRank = IntToString(nSmithingRank);
    string sWoodcuttingRank = IntToString(nWoodcuttingRank);
    string sMiningRank = IntToString(nMiningRank);
    string sRunecraftingRank = IntToString(nRunecraftingRank);
    string sCraftingRank = IntToString(nCraftingRank);
    string sPrayerRank = IntToString(nPrayerRank);
    string sHerbloreRank = IntToString(nHerbloreRank);
    string sThievingRank = IntToString(nThievingRank);
    string sFletchingRank = IntToString(nFletchingRank);
    string sSlayerRank = IntToString(nSlayerRank);
    string sFarmingRank = IntToString(nFarmingRank);
    string sHunterRank = IntToString(nHunterRank);

    // Set GUI object texts for each skill
    SetGUIObjectText(oPC, sScreen, "FISHING", 0, sFishingRank);
    SetGUIObjectText(oPC, sScreen, "COOKING", -1, sCookingRank);
    SetGUIObjectText(oPC, sScreen, "FIREMAKING", -1, sFiremakingRank);
    SetGUIObjectText(oPC, sScreen, "SMITHING", -1, sSmithingRank);
    SetGUIObjectText(oPC, sScreen, "WOODCUTTING", -1, sWoodcuttingRank);
    SetGUIObjectText(oPC, sScreen, "MINING", -1, sMiningRank);
    SetGUIObjectText(oPC, sScreen, "RUNECRAFTING", -1, sRunecraftingRank);
    SetGUIObjectText(oPC, sScreen, "CRAFTING", -1, sCraftingRank);
    SetGUIObjectText(oPC, sScreen, "PRAYER", -1, sPrayerRank);
    SetGUIObjectText(oPC, sScreen, "HERBLORE", -1, sHerbloreRank);
    SetGUIObjectText(oPC, sScreen, "THIEVING", -1, sThievingRank);
    SetGUIObjectText(oPC, sScreen, "FLETCHING", -1, sFletchingRank);
    SetGUIObjectText(oPC, sScreen, "SLAYER", -1, sSlayerRank);
    SetGUIObjectText(oPC, sScreen, "FARMING", -1, sFarmingRank);
    SetGUIObjectText(oPC, sScreen, "HUNTER", -1, sHunterRank);
}