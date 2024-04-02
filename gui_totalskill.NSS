void main()
{
    object oPC = OBJECT_SELF;
    object oCONTROL = GetControlledCharacter(oPC);
    string sSCREEN = "SCREEN_INVENTORY";
    
    // Initialize a new variable to store the combined skill rank
    int totalSkillRank = 0;

    // Add the skill rank of each skill to the total
    totalSkillRank += GetSkillRank(30, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(31, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(32, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(33, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(34, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(35, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(36, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(37, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(38, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(41, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(42, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(43, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(44, oCONTROL, TRUE);
    totalSkillRank += GetSkillRank(46, oCONTROL, TRUE);

    // Convert the total skill rank to a string and set it as the text of the appropriate GUI object
    string sTotalSkillRank = IntToString(totalSkillRank);
    SetGUIObjectText(oPC, sSCREEN, "TOTAL_SKILL_RANK", 0, sTotalSkillRank);
}