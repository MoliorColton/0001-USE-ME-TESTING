#include "profession_include"


void main()



{
// Get the player object
object oPC = GetPCSpeaker();
﻿
// Create a GUI element
object oGUI = CreateObject(OBJECT_TYPE_GUI, "my_gui");
SetGUIObjectDisabled(oGUI, TRUE);
﻿
// Set the script to run when the player levels up a skill
Event_LevelUp(oPC, "OnSkillLevelUp");
}
﻿
// This function is called when the player levels up a skill
void OnSkillLevelUp()
{
// Get the GUI element
object oGUI = GetObjectByTag("my_gui");
﻿
// Get the ID of the skill that was leveled up
int nSkill = GetLevelUpSkill();
﻿
// Ignore skills 0 through 29
if (nSkill < 30)
{
return;
}
﻿
// Get the name and icon of the skill
string sName = GetSkillName(nSkill);
string sIcon = GetSkillIcon(nSkill);
﻿
// Set the text and icon for the GUI element
SetGUIText(oGUI, "Congratulations, you have leveled up the " + sName + " skill!");
SetGUIIcon(oGUI, sIcon);
﻿
// Set the background image for the GUI element
SetGUIBackground(oGUI, "skilllevelupbackgroundelement.tga");
﻿
// Enable the GUI element
SetGUIObjectDisabled(oGUI, FALSE);
}