// Script that changes a mob AI to the passed value.
void main(int iAIProfile, object oTarget)
{
	// Set their AI to the passed profile
	SetLocalInt(oTarget, "LEG_AI_ChangeCalled", iAIProfile);
	
	// Re-Call spawn script to set these (Hope this works LOL)
	ExecuteScript("leg_ai_onspawn", oTarget);
}