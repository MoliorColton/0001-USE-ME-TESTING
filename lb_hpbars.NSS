// HIT POINT BAR INCLUDE FILE BY LANCE BOTELLE

// UPDATES THE CREATURES HP BAR DURING COMBAT (IF ENABLED)


void UpdateHPBars(object oCreature, int ForceUpdate);
void UpdateHPBars(object oCreature, int ForceUpdate)
{	
	float fCURHPS = IntToFloat(GetCurrentHitPoints(oCreature));
		
	// CALCULATE THE CURRENT PERCENTAGE
	float fMAXHPS = IntToFloat(GetMaxHitPoints(oCreature));			
	float fPERCENT = fCURHPS/fMAXHPS * 100;
	int iPERCENT = FloatToInt(fPERCENT); 	// 1-100	 	
			
	// CALCULATE BAR POSITION
	string sHPBAR = "alb_hp_100";								// 91-100		
	if(iPERCENT > 80 && iPERCENT < 91){sHPBAR = "alb_hp_90";}	// 81-90
	else if(iPERCENT > 70 && iPERCENT < 81){sHPBAR = "alb_hp_80";}	// 71-80
	else if(iPERCENT > 60 && iPERCENT < 71){sHPBAR = "alb_hp_70";}	// 61-70
	else if(iPERCENT > 50 && iPERCENT < 61){sHPBAR = "alb_hp_60";}	// 51-60
	else if(iPERCENT > 40 && iPERCENT < 51){sHPBAR = "alb_hp_50";}	// 41-50
	else if(iPERCENT > 30 && iPERCENT < 41){sHPBAR = "alb_hp_40";}	// 31-40
	else if(iPERCENT > 20 && iPERCENT < 31){sHPBAR = "alb_hp_30";}	// 21-30
	else if(iPERCENT > 10 && iPERCENT < 21){sHPBAR = "alb_hp_20";}	// 11-20
	else if(iPERCENT > 0 && iPERCENT < 11){sHPBAR = "alb_hp_10";}	// 1-10

	else if(GetIsDead(oCreature))
	{
		RemoveSEFFromObject(oCreature, "alb_hp_100");	
		RemoveSEFFromObject(oCreature, "alb_hp_90");	
		RemoveSEFFromObject(oCreature, "alb_hp_80");	
		RemoveSEFFromObject(oCreature, "alb_hp_70");	
		RemoveSEFFromObject(oCreature, "alb_hp_60");	
		RemoveSEFFromObject(oCreature, "alb_hp_50");	
		RemoveSEFFromObject(oCreature, "alb_hp_40");	
		RemoveSEFFromObject(oCreature, "alb_hp_30");	
		RemoveSEFFromObject(oCreature, "alb_hp_20");	
		RemoveSEFFromObject(oCreature, "alb_hp_10");
		return;
	}
	
	// UPDATE BAR IF REQUIRED				
	string sLASTBAR = GetLocalString(oCreature, "LASTHPBAR");
	SetLocalString(oCreature, "LASTHPBAR", sHPBAR);
	
	if(sLASTBAR != sHPBAR || ForceUpdate == 1)
	{	
		RemoveSEFFromObject(oCreature, sLASTBAR);
		
		if(!GetIsDead(oCreature))
		{
		effect eHPBar = EffectNWN2SpecialEffectFile(sHPBAR);  	 
		
			if(GetGlobalInt("HPBARSSTATE") == 1)
			{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHPBar, oCreature);	
			}
		}
	}
}

// TURN ON ALL HITPOINT BARS OF CREATURES THAT HAVE THEM
void ForceUpdateHPBars(object oPlayer);
void ForceUpdateHPBars(object oPlayer)
{
	int nEnemy = 1;
	object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_TYPE_IS_ALIVE, oPlayer, nEnemy);
	
	while(oCreature != OBJECT_INVALID)			
	{
		
		if(GetLocalString(oCreature, "LASTHPBAR") != ""){UpdateHPBars(oCreature, 1);}
			
		nEnemy++; oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_TYPE_IS_ALIVE, oPlayer, nEnemy);
	}
}

// TURN OFF ALL HP BARS ON ENEMIES WITHIN THE AREA
void ClearDownHPBars(object oPlayer);
void ClearDownHPBars(object oPlayer)
{	
	int nEnemy = 1;
	object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPlayer, nEnemy);
	
	while(oCreature != OBJECT_INVALID)			
	{
		object oAreaPC = GetArea(oPlayer);	object oAreaMON = GetArea(oCreature);	
		
		if(oAreaPC == oAreaMON)
		{
			RemoveSEFFromObject(oCreature, "alb_hp_100");	
			RemoveSEFFromObject(oCreature, "alb_hp_90");	
			RemoveSEFFromObject(oCreature, "alb_hp_80");	
			RemoveSEFFromObject(oCreature, "alb_hp_70");	
			RemoveSEFFromObject(oCreature, "alb_hp_60");	
			RemoveSEFFromObject(oCreature, "alb_hp_50");	
			RemoveSEFFromObject(oCreature, "alb_hp_40");	
			RemoveSEFFromObject(oCreature, "alb_hp_30");	
			RemoveSEFFromObject(oCreature, "alb_hp_20");	
			RemoveSEFFromObject(oCreature, "alb_hp_10");	
		}
			
		nEnemy++; oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPlayer, nEnemy);
	}
}
 
// EXAMPLE CODE USED IN MY CAMPAIGN:-

void main()
{
		// USES MY OWN FUNCTION HERE
	object oPC = GetControlledCharacter(oPC);
	
	
	if(GetGlobalInt("HPBARSSTATE") == 0)
	{
		SetGlobalInt("HPBARSSTATE", 1);
		SetNoticeText(oPC, "YOU CAST A CRITICAL EYE OVER YOUR ENEMIES");
		
		ForceUpdateHPBars(oPC);
		
		return;
	}
	
	if(GetGlobalInt("HPBARSSTATE") == 1)
	{
		SetGlobalInt("HPBARSSTATE", 0);
		SetNoticeText(oPC, "YOU NO LONGER CRITICALLY OBSERVE YOUR ENEMIES");
		
		ClearDownHPBars(oPC);
	}

}