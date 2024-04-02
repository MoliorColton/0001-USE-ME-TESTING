void main()
{

	object oPC = OBJECT_SELF;
	int nSkillRank = GetSkillRank(SKILL_LORE, oPC);
	string sSkillRank = IntToString(nSkillRank);
    string sScreenName = "SCREEN_INVENTORY";
    string sUIObjectName = "RECIPE_DESCRIPTION";
    if (sScreenName == "SCREEN_INVENTORY")
    {
        sUIObjectName = "AGILITY";
    }
		else if (sScreenName == "SCREEN_INVENTORY")
    {
         sUIObjectName = "RECIPE_DESCRIPTION";
    }
    else return;
    SetGUIObjectText(oPC, sScreenName, sUIObjectName, -1, "Recipe Text");
}