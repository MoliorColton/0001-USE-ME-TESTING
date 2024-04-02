
void main(string xValue, string yValue, string zValue)
{
	object oPC = OBJECT_SELF;
	
	if(GetTag(GetArea(oPC)) == "TheNexus")
	{
		SendMessageToPC(oPC, "Action disabled in The Nexus.");
		return;
	}		
	
	vector vVector = Vector(StringToFloat(xValue), StringToFloat(yValue), StringToFloat(zValue));
	location lLoc = Location(GetArea(oPC), vVector, 1.0);
	
	if(GetIsLocationValid(lLoc) && GetDistanceBetweenLocations(GetLocation(oPC), lLoc) <= 4.0)
	{
		SetLocalLocation(oPC,  "Last_Gold_Drop_Loc", lLoc);
		DisplayGuiScreen(oPC, "SCREEN_GOLD_DROP", FALSE, "golddropinputbox.xml");
	}
	else
	{
		SendMessageToPC(oPC, "Location invalid or too far away.");
	}	
}	