void main(string sScreenName, string sXmlFileName)
{
    object oPC = GetPCSpeaker();
    DisplayGuiScreen(oPC, sScreenName, FALSE, sXmlFileName, TRUE);
}