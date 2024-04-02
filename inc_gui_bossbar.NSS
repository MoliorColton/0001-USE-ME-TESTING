//------------------------------------------------------------------------------
// Include file for the GUI Boss Bar mini-system
//------------------------------------------------------------------------------
/*
	How the boss bar works:
	The boss bar GUI is a simple GUI object which sits at the top of the
	player's screen and displays a line of text and a progress bar.
	It's essentially a giant health bar, but it can also be used to display the
	state of a variable.
	
	To open the bar:
	Use OpenBossBar();
	
	To close the bar:
	Use CloseBossBar();
	
	That's it!
	
	Notes:
	 o  Text space for the title is limited to 500 pixels (just under ~30
	 	characters I think), though you can modify the XML file to adjust for
		longer titles if you really need to. This is more than sufficient for
		short messages like "Zehir's Evilness", however.
	
	 o  If making custom textures for the boss bar, note that the default size
	 	is 400x25 pixels for the bar and 403x27 for the border. However, any
		texture you use will be resized to fit (the default textures included
		have different sizes).
	
	 o  You can resize the boss bar and/or reposition the GUI easily by
	 	modifying the XML file.
*/
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constants
//------------------------------------------------------------------------------

const string GUI_BOSSBAR_XML = "bossbar.xml";
const string GUI_BOSSBAR_SCREEN_NAME = "SCREEN_BOSS";
const string GUI_BOSSBAR_TEXT_NAME = "BOSS_TEXT";
const string GUI_BOSSBAR_BAR_NAME = "BOSS_HEALTHBAR";
const string GUI_BOSSBAR_VARNAME_TARGET = "SCREEN_BOSS_TARGET";
const string GUI_BOSSBAR_VARNAME_FLOAT = "SCREEN_BOSS_VARNAME";
const string GUI_BOSSBAR_TEXTURE_BAR = "xpbar.tga";
const string GUI_BOSSBAR_TEXTURE_BG = "xpbar_bg.tga";


//------------------------------------------------------------------------------
// Function prototypes
//------------------------------------------------------------------------------

//Displays a giant health bar for oPC.  This will display sText and the current
//health of oBoss.
// oBoss - The creature whose health will be displayed.
// sText - The text shown above the health bar. If "", it will use the text
//		specified in the XML file, which defaults to "Health". If you want to a
//		blank string, use " " instead.
// oPC - The PC who will see the health bar.
// sBarTex - The texture to use for the health bar. This should be a TGA file,
//		e.g. "mybartexture.tga". "" uses the default.
// sBackTex - The texture to use for the bar's background (and border). As
//		above, it's meant to be a TGA. "" uses the default.
// sTrackFloat - If this is not "", the bar will display this local floating
//		point variable on oBoss (i.e. sTrackFloat is the name of the variable),
//		instead of oBoss' health. This should be a number between 0.0 and 1.0.
// sFilename - The filename of the XML file.
void OpenBossBar(object oBoss, string sText = "", object oPC = OBJECT_SELF, string sBarTex = "", string sBackTex = "", string sTrackFloat = "", string sFilename = "");


//Closes the Boss Bar for oPC (see OpenBossBar()).
// oPC - The player who has the boss bar visible.
// nClearVars - If TRUE, the variables used by the bar will be deleted from 
//		oPC.
// sScreenName - The name of the screen. Defaults to what is set in
//		"inc_gui_bossbar.nss"
void CloseBossBar(object oPC, int nClearVars = TRUE, string sScreenName = "");


//------------------------------------------------------------------------------
// Function definitions
//------------------------------------------------------------------------------

void OpenBossBar(object oBoss, string sText = "", object oPC = OBJECT_SELF, string sBarTex = "", string sBackTex = "", string sTrackFloat = "", string sFilename = "")
{
	if(sFilename == "")
	{
		sFilename = GUI_BOSSBAR_XML;
	}
	
	SetLocalObject(oPC, GUI_BOSSBAR_VARNAME_TARGET, oBoss);
	if(sTrackFloat != "")
	{
		SetLocalString(oPC, GUI_BOSSBAR_VARNAME_FLOAT, sTrackFloat);
	}
	
	DisplayGuiScreen(oPC, GUI_BOSSBAR_SCREEN_NAME, FALSE, sFilename);
	
	if(sText != "")
	{
		SetGUIObjectText(oPC, GUI_BOSSBAR_SCREEN_NAME, GUI_BOSSBAR_TEXT_NAME, -1, sText);
	}
	
	if(sBarTex != "")
	{
		SetGUITexture(oPC, GUI_BOSSBAR_SCREEN_NAME, GUI_BOSSBAR_BAR_NAME, sBarTex);
	}
}


//Closes the Boss Bar for oPC (see OpenBossBar()).
// oPC - The player who has the boss bar visible.
// nClearVars - If TRUE, the variables used by the bar will be deleted from 
//		oPC.
// sScreenName - The name of the screen. Defaults to what is set in
//		"inc_gui_bossbar.nss"
void CloseBossBar(object oPC, int nClearVars = TRUE, string sScreenName = "")
{
	CloseGUIScreen(oPC, sScreenName);
	
	if(nClearVars)
	{
		DeleteLocalObject(oPC, GUI_BOSSBAR_VARNAME_TARGET);
		DeleteLocalFloat(oPC, GUI_BOSSBAR_VARNAME_FLOAT);
	}
}