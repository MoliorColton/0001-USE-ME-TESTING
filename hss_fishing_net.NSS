#include "hss_fishing_inc"
#include "tb_loops"
#include "ginc_item"
//#include "tb_skillsandxp"
const int HSS_MIN_NET_TIME = 10;
const int HSS_RANDOM_NET_TIME = 10;
const string NET_ANIM = "fishnet";
const string HARPOON_ANIM = "harpoon";
//temp

void HSS_DoNet(object _oPC, object _oWay, object oItem, string type);
void NettingAnim(float curdelay, float delay, float dist = 1000.0f);
void WaitForCatchNet(float curdelay, float delay, float dist = 1000.0f);
void HSS_DoCatchNet();

object oItem;
string anim;

//---------------------------Net Fishing
void HSS_DoNet(object _oPC, object _oWay, object _oItem, string type)
{
	spottype = type;
	anim = NET_ANIM;
	anim = (type == "harpoon" || type == "harpoon1") ? HARPOON_ANIM : anim;
	oPC = _oPC;
	oWay = _oWay;
	oItem = _oItem;
	float fDist = HSS_GetDistanceBetweenNoZ(oPC, oWay);
	string sWay = GetTag(oWay);	
	string sFishWay = GetStringLeft(sWay, 8);
	
	if (ListInventory(oPC) >= 128)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You can't carry any more fish.");
		EndFishing();
		return;
	}
	
	// moved casting animation from up here to below
	float fDir = GetNormalizedDirection(GetFacing(oWay));
	//object oSpot = GetLocalObject(oPC, "fishingspot");
	string sSender = ObjectToString(oWay);
	
	//**Begin Level-Based Timer System
	int level = GetSkillRank(SKILL_FISHING, oPC);
	int spotlevel = StringToInt(GetLocalString(oSpot, "level"));
	int timecap = StringToInt(GetLocalString(oSpot, "timecap"));
	int timespan = level - spotlevel;
	timespan = (timespan < timecap) ? timespan : timecap; //10 is maximum level time reduction
	int skilltime = timecap-(Random(timespan/4)+3*timespan/4);
	int minTime = spotlevel/10;
	int nCastTime = 1 + minTime + skilltime;//(1/timespan)*(HSS_MIN_CAST_TIME + (Random(HSS_RANDOM_CAST_TIME) + 1));
	//SendMessageToPC(oPC, "<color=white>" + "timer:1 +" + IntToString(minTime) + "+" + IntToString(skilltime) + " = " + IntToString(nCastTime) + 
	//"\nmintime: spotlevel/10 = " + IntToString(minTime) + 
	//"\nskilltime: "+IntToString(timecap) +"-(Random("+ IntToString(timespan)+"/4)+(3/4)*"+
	//IntToString(timespan)+"): " + IntToString(skilltime));
	//	**End Level-Based Timer System**
	
	//Triston's fix for casting animation on arival
	AssignCommand(oPC, NettingAnim(IntToFloat(nCastTime), IntToFloat(nCastTime))); 
	
	
	//AssignCommand(oPC, ActionDoCommand(HSS_DoNetFishingFeedback(oPC, nCastTime,
	//lCast, eSplash, nMinCast, sSender, nCastID)));	
}

void NettingAnim(float curdelay, float delay, float dist)
{
	float curdist = GetDistanceBetween(oPC, oWay);
	if (curdist <= 1.0f  && GetLocalInt(oPC, "isfishing") == 0)
	{
		//show the progbar
		loc = GetLocation(oPC);
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, WaitForCatchNet(curdelay, delay));
	}
	else if (curdist < dist)
	{
	//WARNING: Do NOT remove this delay...
		//so we don't freeze
		DelayCommand(0.5f, AssignCommand(oPC, NettingAnim(curdelay, delay, curdist)));
	}
	else
	{
		EndFishing();
	}
}

void WaitForCatchNet(float curdelay, float delay, float dist)
{
	if (ListInventory(oPC) >= 128)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You can't carry any more fish.");
		EndFishing();
		return;
	}
	//SendMessageToPC(oPC, "DEBUG: Spot is " + IntToString(GetIsObjectValid(oSpot)));
	if (!GetIsObjectValid(oSpot))
	{
		EndFishing();
		return;
	}
	AssignCommand(oPC, ActionDoCommand(SetFacing(GetFacing(oWay))));
	if (anim == HARPOON_ANIM)
	{
		string harpoontag = GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
		if (harpoontag != HARPOON_TAG)
		{
			object oharpoon = GetItemPossessedBy(oPC, HARPOON_TAG);
			AssignCommand(oPC, ActionEquipItem(oharpoon, INVENTORY_SLOT_RIGHTHAND));
			if (oharpoon == OBJECT_INVALID)
			{
				SendMessageToPC(oPC, "<color=white>" + "You don't seem to have a harpoon ready.");
				EndFishing();
				return;
			}
		}
	} else if (GetDistanceToObject(oItem) != -1.0)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You don't seem to have your fishing equiptment ready.");
		EndFishing();
		return;
	}
	
	{
		SetLocalInt(oPC, "isfishing", 1);
		//WARNING: Do NOT remove this delay...
		//so we don't freeze
		DelayCommand(step, AssignCommand(oPC, WaitForCatchNet(curdelay, delay-step, curdist)));
		DelayCommand(0.2f, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, anim, 0)));
		//progress bar
		float progress = 1.0-(delay / curdelay);
		//DisplayProgbar();
		//SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", progress);
		SendMessageToPC(oPC, "<color=white>" + "Current Activity: " + GetLocalString(oPC, "activity"));
		EndFishing();
	}
}

void HSS_DoCatchNet()
{
 	
	//clear out the queue, so no casting spam.
	//AssignCommand(oPC, ClearAllActions());  
	
	//remove the cast ID

	object oCatch;
	object oTempCatch;
	string sCatch;
	
	// oSpot = GetLocalObject(oPC, "fishingspot");
	int level = GetSkillRank(SKILL_FISHING, oPC);
	int spotlevel = StringToInt(GetLocalString(oSpot, "level"));
	int timecap = StringToInt(GetLocalString(oSpot, "timecap"));
	int timespan = level - spotlevel;
	int nRoll = timespan+Random(timecap*2);
	
	//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "levelspan_" + IntToString(timespan) +"+random(timecap*2) < timecap_"+
	//	IntToString(timecap));
	if (nRoll < timecap)
	{
	SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Your catch slips right "  +
		"through your fingers.");
	//AssignCommand(oPC, PlaySound("fs_water_hard2"));
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
					 1.0, 6.0));
					 
	//CloseGUIScreen(oPC, "leg_info_progbar");
 				
	DelayCommand(1.5f, AssignCommand(oPC, HSS_DoNet(oPC, oWay, oItem, spottype)));
	EndFishing();
	return;
	}
	
	SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Your manage to catch a fish.");
		
	nRoll = (Random(4) == 0) ? Random(spotlevel+(timecap*2)) : Random(110);
	int nRoll1 = ( Random(2) == 0) ? Random(110) : 0;
	//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Your level " + 
	//	IntToString(level) + " roll " + IntToString(nRoll) );
	//test a catch rolling system
	if (spottype == "cage")
	{
		sCatch = FISH_LOBSTER;
		GiveXP(oPC, "fishing", FISH_LOBSTER_XP);
	}
	else if (spottype == "bignet")
	{
		if (nRoll1 > 100)`
		{
			sCatch = "casket"; //gives casket
			GiveXP(oPC, "fishing", 1); //figure this one out later
		}else if (nRoll1 > FISH_BASS_LEVEL)`
		{
			sCatch = "miscillaniousshit"; //boot and what not
			GiveXP(oPC, "fishing", 1); //figure this one out later
		}else if (level >= FISH_BASS_LEVEL && nRoll > FISH_COD_LEVEL && nRoll <= FISH_BASS_LEVEL)`
		{
			sCatch = FISH_BASS;
			GiveXP(oPC, "fishing", FISH_BASS_XP);
		}else if (level >= FISH_COD_LEVEL && nRoll > FISH_MACKEREL_LEVEL && nRoll <= FISH_COD_LEVEL)`
		{
			sCatch = FISH_COD;
			GiveXP(oPC, "fishing", FISH_COD_XP);
		}
		else
		{
			sCatch = FISH_MACKEREL;
			GiveXP(oPC, "fishing", FISH_MACKEREL_XP);
		}
	}
	else if (spottype == "net1")
	{
		sCatch = FISH_MONKFISH;
		GiveXP(oPC, "fishing", FISH_MONKFISH_XP);
	}
	else if (spottype == "net")
	{
		if (level >= FISH_ANCHOVIES_LEVEL && nRoll < level)`
		{
			sCatch = FISH_ANCHOVIES;
			GiveXP(oPC, "fishing", FISH_ANCHOVIES_XP);
		}
		else
		{
			sCatch = FISH_SHRIMP;
			GiveXP(oPC, "fishing", FISH_SHRIMP_XP);
		}
	}
	else if (spottype == "harpoon")
	{
		if (level >= FISH_SWORDFISH_LEVEL && nRoll < level)`
		{
			sCatch = FISH_SWORDFISH;
			GiveXP(oPC, "fishing", FISH_SWORDFISH_XP);
		}
		else
		{
			sCatch = FISH_TUNA;
			GiveXP(oPC, "fishing", FISH_TUNA_XP);
		}
	}
	else if (spottype == "harpoon1")
	{
			sCatch = FISH_SHARK;
			GiveXP(oPC, "fishing", FISH_SHARK_XP);
	}
	//stack code -- bait is now stackable
	
		//oTempCatch = CreateItemOnObject(sCatch, IPGetIPWorkContainer(oPC));
		//oCatch = CopyItem(oTempCatch, oPC, TRUE);
		//DestroyObject(oTempCatch);
		//AssignCommand(oPC, PlaySound("fs_water_hard2"));
		//AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
		//				 1.0, 6.0));
	oCatch = CreateItemOnObject(sCatch, oPC);
	DelayCommand(1.5f, AssignCommand(oPC, HSS_DoNet(oPC, oWay, oItem, spottype)));
	EndFishing();
	//CloseGUIScreen(oPC, "leg_info_progbar");
}


float step = 0.5f; //how often to loop
float curdist = GetDistanceBetweenLocations(GetLocation(oPC), loc);
    //float curdist = GetDistanceBetween(oPC, oWay);
	//float delay;
   /* if (delay <= 0.0)
    {
        AssignCommand(oPC, ActionDoCommand(HSS_DoCatchNet()));
    } else if (curdist <= dist && GetLocalString(oPC, "activity") == "fishing") //check for changing activities
    {