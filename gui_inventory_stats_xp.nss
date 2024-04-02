#include "profession_include"





void main()
{
object oPC = OBJECT_SELF;
object oCONTROL = GetControlledCharacter(oPC);
string sSCREEN1 = "GUIDEFISHING1";
string sSCREEN2 = "GUIDECOOKING1";
string sSCREEN3 = "GUIDEFIREMAKING1";
string sSCREEN4 = "GUIDESMITHING1";
string sSCREEN5 = "GUIDEWOODCUTTING1";
string sSCREEN6 = "GUIDEMINING1";
string sSCREEN7 = "GUIDERUNECRAFTING";
string sSCREEN8 = "GUIDECRAFTING1";
string sSCREEN9 = "GUIDEPRAYER1";
string sSCREEN10 = "GUIDECONSTRUCTION1";
string sSCREEN11 = "GUIDEAGILITY1";
string sSCREEN12 = "GUIDEHERBLORE1";
string sSCREEN13 = "GUIDETHIEVINGE1";
string sSCREEN14 = "GUIDEFLETCHINGE1";
string sSCREEN15 = "GUIDESLAYER1";
string sSCREEN16 = "GUIDEHUNTER1";
string sSCREEN17 = "GUIDEFARMING1";




	
			
// Retrieve the gained XP and current level for each skill

// Fishing Skill
int nFishingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"),"SKILLXP_30");
int nFishingLevel = GetSkillRank(SKILL_FISHING, oPC);
int nFishingNeededXP = GetSkillXPNeeded(nFishingLevel + 1);
string sFishingXPText =  "XP: " + IntToString(nFishingXP) + "/" + IntToString(nFishingNeededXP);
SetGUIObjectText(oPC, sSCREEN1, "FISHING_XP", 0, sFishingXPText);

// Cooking Skill
int nCookingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_31");
int nCookingLevel = GetSkillRank(SKILL_COOKING, oPC);
int nCookingNeededXP = GetSkillXPNeeded(nCookingLevel + 1);
string sCookingXPText = "XP: " + IntToString(nCookingXP) + "/" + IntToString(nCookingNeededXP);
SetGUIObjectText(oPC, sSCREEN2, "COOKING_XP", -1, sCookingXPText);

// Firemaking Skill
int nFiremakingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_32");
int nFiremakingLevel = GetSkillRank(SKILL_FIREMAKING, oPC);
int nFiremakingNeededXP = GetSkillXPNeeded(nFiremakingLevel + 1);
string sFiremakingXPText = "XP: " + IntToString(nFiremakingXP) + "/" + IntToString(nFiremakingNeededXP);
SetGUIObjectText(oPC, sSCREEN3, "FIREMAKING_XP", -1, sFiremakingXPText);

// Smithing Skill
int nSmithingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_33");
int nSmithingLevel = GetSkillRank(SKILL_SMITHING, oPC);
int nSmithingNeededXP = GetSkillXPNeeded(nSmithingLevel + 1);
string sSmithingXPText = "XP: " + IntToString(nSmithingXP) + "/" + IntToString(nSmithingNeededXP);
SetGUIObjectText(oPC, sSCREEN4, "SMITHING_XP", -1, sSmithingXPText);

// Woodcutting Skill
int nWoodcuttingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_34");
int nWoodcuttingLevel = GetSkillRank(SKILL_WOODCUTTING, oPC);
int nWoodcuttingNeededXP = GetSkillXPNeeded(nWoodcuttingLevel + 1);
string sWoodcuttingXPText = "XP: " + IntToString(nWoodcuttingXP) + "/" + IntToString(nWoodcuttingNeededXP);
SetGUIObjectText(oPC, sSCREEN5, "WOODCUTTING_XP", -1, sWoodcuttingXPText);

// Mining Skill
int nMiningXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_35");
int nMiningLevel = GetSkillRank(SKILL_MINING, oPC);
int nMiningNeededXP = GetSkillXPNeeded(nMiningLevel + 1);
string sMiningXPText = "XP: " + IntToString(nMiningXP) + "/" + IntToString(nMiningNeededXP);
SetGUIObjectText(oPC, sSCREEN6, "MINING_XP", -1, sMiningXPText);

// Runecrafting Skill
int nRunecraftingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_36");
int nRunecraftingLevel = GetSkillRank(SKILL_RUNECRAFTING, oPC);
int nRunecraftingNeededXP = GetSkillXPNeeded(nRunecraftingLevel + 1);
string sRunecraftingXPText = "XP: " + IntToString(nRunecraftingXP) + "/" + IntToString(nRunecraftingNeededXP);
SetGUIObjectText(oPC, sSCREEN7, "RUNECRAFTING_XP", -1, sRunecraftingXPText);

// Crafting Skill
int nCraftingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_37");
int nCraftingLevel = GetSkillRank(SKILL_CRAFTING, oPC);
int nCraftingNeededXP = GetSkillXPNeeded(nCraftingLevel + 1);
string sCraftingXPText = "XP: " + IntToString(nCraftingXP) + "/" + IntToString(nCraftingNeededXP);
SetGUIObjectText(oPC, sSCREEN8, "CRAFTING_XP", -1, sCraftingXPText);

// Prayer Skill
int nPrayerXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_38");
int nPrayerLevel = GetSkillRank(SKILL_PRAYER, oPC);
int nPrayerNeededXP = GetSkillXPNeeded(nPrayerLevel + 1);
string sPrayerXPText = "XP: " + IntToString(nPrayerXP) + "/" + IntToString(nPrayerNeededXP);
SetGUIObjectText(oPC, sSCREEN9, "PRAYER_XP", -1, sPrayerXPText);

// Construction Skill
int nConstructionXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_39");
int nConstructionLevel = GetSkillRank(SKILL_CONSTRUCTION, oPC);
int nConstructionNeededXP = GetSkillXPNeeded(nConstructionLevel + 1);
string sConstructionXPText = "XP: " + IntToString(nConstructionXP) + "/" + IntToString(nConstructionNeededXP);
SetGUIObjectText(oPC, sSCREEN10, "CONSTRUCTION_XP", -1, sConstructionXPText);

// Agility Skill
int nAgilityXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_40");
int nAgilityLevel = GetSkillRank(SKILL_AGILITY, oPC);
int nAgilityNeededXP = GetSkillXPNeeded(nAgilityLevel + 1);
string sAgilityXPText = "XP: " + IntToString(nAgilityXP) + "/" + IntToString(nAgilityNeededXP);
SetGUIObjectText(oPC, sSCREEN11, "AGILITY_XP", -1, sAgilityXPText);

// Herblore Skill
int nHerbloreXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_41");
int nHerbloreLevel = GetSkillRank(SKILL_HERBLORE, oPC);
int nHerbloreNeededXP = GetSkillXPNeeded(nHerbloreLevel + 1);
string sHerbloreXPText = "XP: " + IntToString(nHerbloreXP) + "/" + IntToString(nHerbloreNeededXP);
SetGUIObjectText(oPC, sSCREEN12, "HERBLORE_XP", -1, sHerbloreXPText);

// Thieving Skill
int nThievingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_42");
int nThievingLevel = GetSkillRank(SKILL_THIEVING, oPC);
int nThievingNeededXP = GetSkillXPNeeded(nThievingLevel + 1);
string sThievingXPText = "XP: " + IntToString(nThievingXP) + "/" + IntToString(nThievingNeededXP);
SetGUIObjectText(oPC, sSCREEN13, "THIEVING_XP", -1, sThievingXPText);

// Fletching Skill
int nFletchingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_43");
int nFletchingLevel = GetSkillRank(SKILL_FLETCHING, oPC);
int nFletchingNeededXP = GetSkillXPNeeded(nFletchingLevel + 1);
string sFletchingXPText = "XP: " + IntToString(nFletchingXP) + "/" + IntToString(nFletchingNeededXP);
SetGUIObjectText(oPC, sSCREEN14, "FLETCHING_XP", -1, sFletchingXPText);

// Slayer Skill
int nSlayerXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_44");
int nSlayerLevel = GetSkillRank(SKILL_SLAYER, oPC);
int nSlayerNeededXP = GetSkillXPNeeded(nSlayerLevel + 1);
string sSlayerXPText = "XP: " + IntToString(nSlayerXP) + "/" + IntToString(nSlayerNeededXP);
SetGUIObjectText(oPC, sSCREEN15, "SLAYER_XP", -1, sSlayerXPText);

// Hunter Skill
int nHunterXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_45");
int nHunterLevel = GetSkillRank(SKILL_HUNTER, oPC);
int nHunterNeededXP = GetSkillXPNeeded(nHunterLevel + 1);
string sHunterXPText = "XP: " + IntToString(nHunterXP) + "/" + IntToString(nHunterNeededXP);
SetGUIObjectText(oPC, sSCREEN16, "HUNTER_XP", -1, sHunterXPText);

// Farming Skill
int nFarmingXP = GetLocalInt(GetItemPossessedBy(oCONTROL, "player_essence"), "SKILLXP_46");
int nFarmingLevel = GetSkillRank(SKILL_FARMING, oPC);
int nFarmingNeededXP = GetSkillXPNeeded(nFarmingLevel + 1);
string sFarmingXPText = "XP: " + IntToString(nFarmingXP) + "/" + IntToString(nFarmingNeededXP);
SetGUIObjectText(oPC, sSCREEN17, "FARMING_XP", -1, sFarmingXPText);




}
