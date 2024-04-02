#include "x0_i0_position"
#include "x2_inc_itemprop"
#include "tb_skillsandxp"
#include "ginc_item"
#include "tb_loops"

/* ___________________________ Objects _____________________________ */
	//equiptment
const string FISHING_ROD_TAG = "fishingrod";
const string FLY_FISHING_ROD_TAG = "flyfishingrod";
//const string OILY_FISHING_ROD_TAG = ""; //not used yet
const string FISHING_NET_TAG = "smallnet";
const string BIG_FISHING_NET_TAG = "bigfishingnet";
const string LOBSTER_POT_TAG = "lobstercage";
const string HARPOON_TAG = "harpoon";
	//bait
const string FISHING_BAIT_TAG = "fishingbait";
const string FEATHERS_TAG = "feathers";

/* ___________________________ Animations _____________________________ */
const string ANIM_FISHROD = "fishrod";
const string ANIM_FISHROD_LEFT = "fishrod_left";
const string ANIM_FISHROD_RIGHT = "fishrod_right";
const string ANIM_FISHROD_TUG = "fishrod_tug";
const string ANIM_CASTROD = "*1ATTACK01";

/* ___________________________ Catch Resrefs _____________________________ */
const string FISH_SHRIMP = "rawshrimp";
//const string FISH_KARAMBWANJI = "";
const string FISH_SARDINE = "rawsardine";
const string FISH_HERRING = "rawherring";
const string FISH_ANCHOVIES = "rawanchovies";
const string FISH_MACKEREL = "rawmackerel";
const string FISH_TROUT = "rawtrout";
const string FISH_COD = "rawcod";
const string FISH_PIKE = "rawpike";
const string FISH_SALMON = "rawsalmon";
const string FISH_TUNA = "rawtuna";
//const string FISH_RAINBOWFISH = "";
//const string FISH_CAVEEEL = "";
const string FISH_LOBSTER = "rawlobster";
const string FISH_BASS = "rawbass";
const string FISH_SWORDFISH = "rawswordfish";
//const string FISH_LAVAEEL = "";
const string FISH_MONKFISH = "rawmonkfish";
//const string FISH_KARAMBWAN = "";
const string FISH_SHARK = "rawshark";

/* ___________________________ Catch XP _____________________________ */
const int FISH_SHRIMP_XP = 10;
//const int FISH_KARAMBWANJI_XP = 10;
const int FISH_SARDINE_XP = 20;
const int FISH_HERRING_XP = 30;
const int FISH_ANCHOVIES_XP = 40;
const int FISH_MACKEREL_XP = 20;
const int FISH_TROUT_XP = 50;
const int FISH_COD_XP = 45;
const int FISH_PIKE_XP = 60;
//const int FISH_SLIMYEEL_XP = 65;
const int FISH_SALMON_XP = 70;
const int FISH_TUNA_XP = 80;
//const int FISH_RAINBOWFISH_XP = 80;
//const int FISH_CAVEEEL_XP = 80;
const int FISH_LOBSTER_XP = 90;
const int FISH_BASS_XP = 100;
const int FISH_SWORDFISH_XP = 100;
//const int FISH_LAVAEEL_XP = 30;
const int FISH_MONKFISH_XP = 120;
//const int FISH_KARAMBWAN_XP = 105;
const int FISH_SHARK_XP = 110;

/* ___________________________ Catch Levels _____________________________ */
//const int FISH_SHRIMP_LEVEL = 0; //not used
//const int FISH_KARAMBWANJI_LEVEL = 5;
//const int FISH_SARDINE_LEVEL = 5; //not used
const int FISH_HERRING_LEVEL = 10;
const int FISH_ANCHOVIES_LEVEL = 15;
const int FISH_MACKEREL_LEVEL = 16;
//const int FISH_TROUT_LEVEL = 20; //not used
const int FISH_COD_LEVEL = 23;
const int FISH_PIKE_LEVEL = 25;
//const int FISH_SLIMYEEL_LEVEL = 28;
const int FISH_SALMON_LEVEL = 30;
//const int FISH_TUNA_LEVEL = 35; //not used
//const int FISH_RAIBOWFISH_LEVEL = 38;
//const int FISH_CAVEEEL_LEVEL = 38;
//const int FISH_LOBSTER_LEVEL = 40; //not used
const int FISH_BASS_LEVEL = 46;
const int FISH_SWORDFISH_LEVEL = 50;
//const int FISH_LAVAEEL_LEVEL = 53;
const int FISH_MONKFISH_LEVEL = 62;
const int FISH_KARAMBWAN_LEVEL = 65;
const int FISH_SHARK_LEVEL = 76;

//technical
const float ROD_FISHING_DIST = 2.0f;

/* >>>>>>>>>>>>>>>>>>>>>>>>>>> Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< */

//percentage chance that each cast will result in lost bait
//Default: 50
const int HSS_BAIT_LOSS_CHANCE = 10;

//percentage chance that no catch will be made (i.e. this value subtracted
//from 100 will yield the catch chance).  The difference between this value
//and HSS_BAIT_LOSS_CHANCE is the percentage chance of not catching
//something but KEEPING the bait to use again in another cast.
//Default: 80
const int HSS_NO_CATCH_CHANCE = 10;

// Tchos' note: I removed the code checking the no catch chance entirely, 
// so now the chance of not catching anything should be only 10%, and not >50% like before.

//percentage chance that the fishing line will break if the PC rolls a
//1 on his catch roll. (i.e. PC rolls a 1 on a catch and then rolls again
//to see if the line has snapped -- a value of 1 would mean the PC needs
//to roll a 1 one a die 100 twice in a row)
//recommend this setting is a low value -- it just becomes annoying if it
//happens more often than rarely.
//Default: 20 
const int HSS_LINE_SNAP_CHANCE = 20;

//minimum length of time a cast will last in seconds
//Default: 30
const int HSS_MIN_CAST_TIME = 10;
const int HSS_RANDOM_CAST_TIME = 10;
const int HSS_MIN_CAST_DIST = 6;
const int HSS_RAND_CAST_DIST = 10;

//the colour that feedback text is given in
//const string HSS_FEEDBACK_COLOUR = "<color=LightSeaGreen>";
const string HSS_FEEDBACK_COLOUR = "<color=white>";


//debug constant enabling sure catches and stuff
//Default: 0
const int HSS_FISH_DEBUG = 0;


/* >>>>>>>>>>>>>>>>>>>>>>>> End Configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<< */



/* >>>>>>>>>>>>>>>>>>>>>>> Function Prototypes <<<<<<<<<<<<<<<<<<<<<<<<<<<< */


//function for the on_activate of the fishing rod
void HSS_DoCast(object _oPC, object _oRod, object _oWay, string type);

//function that s if something is caught
void HSS_DoCatch();

// the feedback and then call the IfFishing functions.
void HSS_DoFishingFeedback(int nCastTime, location lCast, effect eSplash, int nMinCast, string sSender, int nCastID);

//Get the distance between two object that ignores the z axis differences
float HSS_GetDistanceBetweenNoZ(object oObjectA, object oObjectB);

//do fishing feedback effect if PC is still fishing
void HSS_DoFishingEffectIfFishing(effect eSplash, location lAnim, string sSender, int nCastID);

//do fishing feedback text if PC is still fishing
void HSS_DoFishingFeedbackIfFishing(string sMsg, string sSender, int nCastID);

//returns true if nFlag has been set -- otherwise returns false.
int HSS_GetBitwiseFlag(int nFlag, object oTarget, string sVar);

//adds the unique power use to a fishing rod that doesn't have that power
void HSS_DoFishingLineUse(object oUser, object oTarget);


//Triston: aborting when player leaves fishing spot
void WaitForCatch(float curdelay, float delay, float dist = 1000.0f);
//Triston: my fix for casting anim playing before arrival at fishing spot
void CastingAnim(int time, float dist = 1000.0f);
void DisplayProgbar();
void EndFishing();

//fishing vars
string spottype;
object oPC;
object oRod;
object oWay;
object oBait;
object oSpot;
location loc;

void ReallyPlayCustomAnimation(object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f)
{
	EndAnims(oPC);
	nLooping = (sAnimationName == ANIM_CASTROD) ? 0 : nLooping;
	PlayCustomAnimation(oObject, sAnimationName, nLooping, fSpeed);
}

void FaceSpot()
{
	AssignCommand(oPC, SetFacing(GetFacing(oWay)));
}

void Recast()
{
	DelayCommand(0.2, HSS_DoCast(oPC, oRod, oWay, spottype));
}

void HSS_DoCatch()
{
	//string sWay = GetTag(oWay);
	//string sSpotType = GetStringRight(sWay, 1);
	//int nSurvival = GetSkillRank(SKILL_SURVIVAL, oPC);
	//clear out the queue, so no casting spam.
	AssignCommand(oPC, ClearAllActions());
 	
	
	object oCatch;
	string sCatch;
	
	int level = GetSkillRank(SKILL_FISHING, oPC);
	int spotlevel = StringToInt(GetLocalString(oSpot, "level"));
	int timecap = StringToInt(GetLocalString(oSpot, "timecap"));
	int timespan = level - spotlevel;
	int nRoll = timespan+Random(timecap*2);
	//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "levelspan_" + IntToString(timespan) +"+random(timecap*2) < timecap_"+
	//	IntToString(timecap));
	if (nRoll < timecap)
	{
		DelayCommand(0.7f, EndFishing());
		if (GetItemStackSize(oBait) > 1)
		{
			SetItemStackSize(oBait, GetItemStackSize(oBait)-1);
//***RECASTING***//
		}
		else
		{
			DestroyObject(oBait);
		}	
		 	
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You lost your bait to a " +
			"fish or it was snagged on something.");
		AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
						 1.0, 6.0));
		AssignCommand(oPC, PlaySound("fs_water_hard2"));
		
		//CloseGUIScreen(oPC, "leg_info_progbar");
		DelayCommand(1.5f, Recast());
		
		EndFishing();
	 		
		return;
	}
		
	SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Your manage to catch a fish.");
	
	nRoll = (Random(4) == 0) ? Random(spotlevel+(timecap*2)) : Random(110);
	//test a catch rolling system
	if (spottype == "lure")
	{
		if (level >= FISH_SALMON_LEVEL && nRoll < level)
		{
			sCatch = FISH_SALMON;
			GiveXP(oPC, "fishing", FISH_SALMON_XP);
		}
		else
		{
			sCatch = FISH_TROUT;
			GiveXP(oPC, "fishing", FISH_TROUT_XP);
		}
	}
	else if (spottype == "bait")
	{
		if (level >= FISH_HERRING_LEVEL && nRoll < level)
		{
			sCatch = FISH_HERRING;
			GiveXP(oPC, "fishing", FISH_HERRING_XP);
		}
		else
		{
			sCatch = FISH_SARDINE;
			GiveXP(oPC, "fishing", FISH_SARDINE_XP);
		}
	}
	else if (spottype == "bait1")
	{
			sCatch = FISH_PIKE;
			GiveXP(oPC, "fishing", FISH_PIKE_XP);
	}
	//stack code -- bait is now stackable
	if (GetItemStackSize(oBait) > 1)
	{
		SetItemStackSize(oBait, GetItemStackSize(oBait) - 1);
	}
	else
	{
		DestroyObject(oBait);
	}
	oCatch = CreateItemOnObject(sCatch, oPC);
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 
					 1.0, 6.0));
	//AssignCommand(oPC, PlaySound("fs_water_hard2"));
	DelayCommand(1.5f, Recast());
	
	EndFishing();
	
	//CloseGUIScreen(oPC, "leg_info_progbar");
}

	//---------------------Rod Casting
void HSS_DoCast(object _oPC, object _oRod, object _oWay, string type)
{
	spottype = type;
	oPC = _oPC;
	oRod = _oRod;
	oWay = _oWay;
	//oSpot = GetLocalObject(oPC, "fishingspot");
	if (ListInventory(oPC) >= 128)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You can't carry any more fish.");
		EndFishing();
		return;
	}
	if (GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) != GetTag(oRod))
	{
		AssignCommand(oPC, ActionEquipItem(oRod, INVENTORY_SLOT_RIGHTHAND));
	}
	FaceSpot();
	
	oBait = (type == "lure") ? GetItemInInventory(FEATHERS_TAG, oPC)
	 : GetItemInInventory(FISHING_BAIT_TAG, oPC);
	if (!GetItemStackSize(oBait) > 0)
	{
		if (type == "lure")
		{
			SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need feathers to fly fish.");
		}
		else if (type == "bait" || type == "bait1")
		{
			SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need bait to fish.");
		}
		return;
	}
	
		/* casting speed pseudo
		me lvl 80
		spot lvl 30
	
		int cap = localint spotspeedcap
		if (level > cap)
		{
			level = cap;
		}
		casttime = (min_seconds + random(seconds)) * (level / spot lvl)
		*/ 
		//moved casting animation from up here to below
		
		//**Begin Level-Based Timer System
		int level = GetSkillRank(SKILL_FISHING, oPC);
		int spotlevel = StringToInt(GetLocalString(oSpot, "level"));
		int timecap = StringToInt(GetLocalString(oSpot, "timecap"));
		int timespan = level - spotlevel;
		timespan = (timespan < timecap) ? timespan : timecap; //10 is maximum level time reduction
		int skilltime = timecap-(Random(timespan/4)+3*timespan/4);
		int minTime = spotlevel/10;
		int nCastTime = minTime + skilltime;//(1/timespan)*(HSS_MIN_CAST_TIME + (Random(HSS_RANDOM_CAST_TIME) + 1));
		//SendMessageToPC(oPC, "<color=white>" + "timer:2+" + IntToString(minTime) + "+" + IntToString(skilltime) + " = " + IntToString(nCastTime) + 
		//"\nmintime: spotlevel/10 = " + IntToString(minTime) + 
		//"\nskilltime: "+IntToString(timecap) +"-(Random("+ IntToString(timespan)+"/4)+(3/4)*"+
		//IntToString(timespan)+"): " + IntToString(skilltime));
		//	**End Level-Based Timer System**
	
		DelayCommand(1.7f, AssignCommand(oPC, CastingAnim(nCastTime)));
}

void CastingAnim(int time, float dist)
{
	if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oRod)
	{
		//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You don't seem to have a fishing rod ready.");
		EndFishing();
		return;
	}
	float curdist = GetDistanceBetween(oPC, oWay);
	if (curdist < ROD_FISHING_DIST-0.5)
	{
		//All that casting stuff from above
		loc = GetLocation(oPC);
		AssignCommand(oPC, ClearAllActions());
		
		//oSpot = GetLocalObject(oPC, "fishingspot");
		string sWay = GetTag(oWay);	
		string sFishWay = GetStringLeft(sWay, 8);
		int nMinCast = GetLocalInt(oWay, "HSS_MINCAST");
		nMinCast = (nMinCast == 0) ? HSS_MIN_CAST_DIST : nMinCast;
		int nRandCast = GetLocalInt(oWay, "HSS_RANDCAST");
		nRandCast = (nRandCast == 0) ? HSS_RAND_CAST_DIST : nRandCast;
		int nCastID = Random(65535) + Random(65535);
		
		effect eSplash = EffectNWN2SpecialEffectFile("fx_hss_fishing");
		float fDir = GetNormalizedDirection(GetFacing(oWay));
		float fRanAngle = IntToFloat(Random(20) - Random(20));
		float fRanDist = IntToFloat(nMinCast + Random(nRandCast));
		location lCast = GenerateNewLocation(oWay, fRanDist, fDir + fRanAngle, 0.0);
		//move lCast down to the fishing spot
		vector vCast = GetPositionFromLocation(lCast);
		vCast.z = Vector(vCast.x, vCast.y, GetPosition(oSpot).z).z;
		//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Vector: " + FloatToString(vCast.x)+","+FloatToString(vCast.y)+","+FloatToString(vCast.z)+","+FloatToString(GetPosition(oSpot).z)+".");
		lCast = Location(GetArea(oWay), vCast, GetFacingFromLocation(lCast));
		string sSender = ObjectToString(oWay);
		
		//fix for casting animation on arival
		AssignCommand(oPC, PlaySound("fishing_reel_cast"));
		AssignCommand(oPC, ActionDoCommand(SetLocalInt(oPC, "HSS_CAST_ID", nCastID)));
		
		AssignCommand(oPC, ActionDoCommand(SpawnItemProjectile
		(oPC, OBJECT_INVALID, GetLocation(oPC), lCast, BASE_ITEM_SHURIKEN,
		PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_MISS, DAMAGE_TYPE_SONIC)));
		
		//cool new NWN2 projectile functions
		AssignCommand(oPC, ActionWait(GetProjectileTravelTime(GetLocation(oPC),
		lCast, PROJECTILE_PATH_TYPE_DEFAULT, SPELL_TRAP_SHURIKEN)));	
			
		AssignCommand(oPC, ActionDoCommand(ApplyEffectAtLocation
		(DURATION_TYPE_INSTANT, eSplash, lCast)));  
		
		AssignCommand(oPC, ActionDoCommand(HSS_DoFishingFeedback(time,
		lCast, eSplash, nMinCast, sSender, nCastID)));
		//End Stuff from up top
	
	
		//AssignCommand(oPC, PlaySound("fishing_reel_cast"));
		//start waiting
		DelayCommand(0.4f, AssignCommand(oPC, WaitForCatch(IntToFloat(time), IntToFloat(time))));
		DelayCommand(0.2f, ReallyPlayCustomAnimation(oPC, ANIM_CASTROD, FALSE));
	}
	else if (curdist < dist && GetLocalString(oPC, "activity") == "fishing") //we're still running towards our spot
	{
	//WARNING: Do NOT remove this delay...
		//so we don't freeze
		FaceSpot();
		DelayCommand(0.5f, AssignCommand(oPC, CastingAnim(time, curdist)));
	}
	else
	{
		//SendMessageToPC(oPC, "<color=white>" + "Current Activity: " + GetLocalString(oPC, "activity"));
	}
}

void WaitForCatch(float curdelay, float delay, float dist)
{
	if (ListInventory(oPC) >= 128)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You can't carry any more fish.");
		EndFishing();
		return;
	}
	//SendMessageToPC(oPC, "DEBUG: Spot is " + IntToString(GetIsObjectValid(oSpot)));	
	if (!GetIsObjectValid(oSpot) || GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oRod)
	{
		//SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You don't seem to have a fishing rod ready.");
		EndFishing();
		return;
	}
	{
	//WARNING: Do NOT remove this delay...
		//so we don't freeze
		SetLocalInt(oPC, "isfishing", 1);
		FaceSpot();
		DelayCommand(step, AssignCommand(oPC, WaitForCatch(curdelay, delay-step, curdist)));
		//progress bar
		float progress = 1.0-(delay / curdelay);
		DisplayProgbar();
		//SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", progress);
		//SendMessageToPC(oPC, "<color=white>" + "Current Activity: " + GetLocalString(oPC, "activity"));
		EndFishing();
		return;
	}
}
/*
void Recast()
{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "Yo");
	if (!GetItemStackSize(oBait) > 0)
	{
		return;
	}
	AssignCommand(oPC, HSS_DoCast(oPC, oRod, oWay, spottype));
}
*/
void HSS_DoFishingFeedback(int nCastTime, location lCast, effect eSplash, int nMinCast, string sSender, int nCastID)
{
	int nMsg = Random(14);
	vector vCast = GetPositionFromLocation(lCast);	
	float fTimer;
	string sMsg1;
	string sMsg2;
	int nAnimEvent;
	location lAnim;
 
	switch (nMsg)
		{
	case 0:
	sMsg1 = "You feel a nibble on the line.";
	sMsg2 = "You feel a tug on the line.";
	break;
	
	case 1:
	sMsg1 = "You see a fish jump.";
	nAnimEvent = 1;
	sMsg2 = "Your line goes taut.";
	break;

	case 2:
	sMsg1 = "You have something on the line!  It's fighting hard!";
	nAnimEvent = 1;
	
		switch (Random(5))
		{
		 case 0:
		 sMsg2 = "Your line pulls to the left.";
		 break;

		 case 1:
		 sMsg2 = "Your line goes slack.";
		 break;

		 case 2:
		 sMsg2 = "Your line feels as if it may be snagged.";
		 break;

		 case 3:
		 sMsg2 = "Your line jerks violently!";
		 nAnimEvent = 2;
		 break;

		 case 4:
		 sMsg2 = "Your line pulls to the right.";
		 break;
		 }

	break;

	case 3:
	sMsg1 = "You feel a tug on the line.";
	sMsg2 = "Your line goes taut.";
	break;
		
	case 4:
	sMsg1 = "Your line goes taut.";
	sMsg2 = "You feel a nibble on the line.";	
	break;
		
	case 5:
	sMsg1 = "Your line goes slack.";
	sMsg2 = "You see a fish jump.";
	break;
		
	case 6:
	sMsg1 = "Your line drifts slowly.";
	sMsg2 = "You have something on the line!  It's fighting hard!";
	break;
		
	case 7:
	sMsg1 = "Your line feels as if it may be snagged.";
	sMsg2 = "Your line drifts slowly.";
	break; 
	
	case 8:
	sMsg1 = "Your line pulls to the right.";
	sMsg2 = "Your line goes slack.";
	break;
	
	case 9:
	sMsg1 = "Your line pulls to the left.";
	sMsg2 = "Your line goes slack.";
	break;
	
	case 10:
	sMsg1 = "Your line jerks violently!";
	sMsg2 = "Your line pulls to the left.";
	break;
	
	case 11:
	sMsg1 = "Your line jerks violently!";
	sMsg2 = "Your line pulls to the right.";
	break;
	
	case 12:
	sMsg1 = "Your line lies dead in the water.";
	sMsg2 = "Your line drifts slowly.";
	break;
	
	case 13:
	sMsg1 = "Your line lies dead in the water.";
	sMsg2 = "Your line goes taut.";
	break;
	}
	
	if (nCastTime <= HSS_MIN_CAST_TIME + (HSS_RANDOM_CAST_TIME / 2))
		{
	fTimer = IntToFloat(nCastTime / 2);
	
	if (nAnimEvent == 1)
		{
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
					 IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer, HSS_DoFishingEffectIfFishing(eSplash, lAnim, sSender, nCastID));				 
		 }
		 
		DelayCommand(fTimer, HSS_DoFishingFeedbackIfFishing(sMsg1, sSender, nCastID));
	}
	else
	{
	fTimer = IntToFloat(nCastTime / 3);
	
	if (nAnimEvent == 1)
		{
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
					 IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer, HSS_DoFishingEffectIfFishing(eSplash, lAnim, sSender, nCastID));			 
		 }

	if (nAnimEvent == 2)
		 {
		 lAnim =  Location(GetAreaFromLocation(lCast),GetChangedPosition(vCast,
					 IntToFloat(Random(nMinCast - 2)), IntToFloat(Random(360))), 0.0);
		 
		 DelayCommand(fTimer + fTimer, HSS_DoFishingEffectIfFishing(eSplash, lAnim, sSender, nCastID));
		 }

	DelayCommand(fTimer, HSS_DoFishingFeedbackIfFishing(sMsg1, sSender, nCastID));
	DelayCommand(fTimer + fTimer, HSS_DoFishingFeedbackIfFishing(sMsg2, sSender, nCastID));
	}
	//show the progbar
	DisplayProgbar();
}

void HSS_DoFishingEffectIfFishing(effect eSplash, location lAnim, string sSender, int nCastID)
{
	oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC);
	float fDist = GetDistanceBetweenLocations(GetLocation(oPC), loc);
	object oFisher = oPC;

	if (fDist < 1.0)
		{
		 	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSplash, lAnim);
		}
}

void HSS_DoFishingFeedbackIfFishing(string sMsg, string sSender, int nCastID)
{
	oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC);
	float fDist = GetDistanceBetweenLocations(GetLocation(oPC), loc);
	string sAnim = ANIM_FISHROD;
	object oFisher = oPC;
 	
	if (fDist < ROD_FISHING_DIST && GetLocalInt(oPC, "isfishing") == 1)
	{
	 sAnim =  (sMsg == "Your line pulls to the right.") ? ANIM_FISHROD_RIGHT : (
	 (sMsg == "Your line pulls to the left.") ? ANIM_FISHROD_LEFT : (
	 (sMsg == "Your line jerks violently!") ? ANIM_CASTROD : (
	 (sMsg == "Your line goes taut.") ? ANIM_FISHROD_TUG : (
	 (sMsg == "You have something on the line!  It's fighting hard!") ? ANIM_CASTROD : ANIM_FISHROD 
	 ))));
	 SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sMsg);
	 ReallyPlayCustomAnimation(oPC, sAnim, TRUE);  // animate reeling situations
	 //SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + sMsg);
	}
	else
	{
		EndFishing();
	}
}

float HSS_GetDistanceBetweenNoZ(object oObjectA, object oObjectB)
{
	float fReturn = -1.0000;
	location lA = GetLocation(oObjectA);
	location lB = GetLocation(oObjectB);
	object oAreaA = GetAreaFromLocation(lA);
	object oAreaB = GetAreaFromLocation(lB);	
	
	if (oAreaA != oAreaB ||
		(!GetIsObjectValid(oObjectA) || !GetIsObjectValid(oObjectB)))
		{
	return fReturn;
	}
	
	vector vPosA = GetPositionFromLocation(lA);
	vector vPosB = GetPositionFromLocation(lB);
	float fAx = vPosA.x;
	float fAy = vPosA.y;	
	float fBx = vPosB.x;
	float fBy = vPosB.y;
	
	vPosA = Vector(fAx, fAy, 0.0);
	vPosB = Vector(fBx, fBy, 0.0);	
	lA = Location(oAreaA, vPosA, 0.0);
	lB = Location(oAreaB, vPosB, 0.0);
					
	fReturn = GetDistanceBetweenLocations(lA, lB);
	 	
	
	return fReturn;	
}


int HSS_GetBitwiseFlag(int nFlag, object oTarget, string sVar)
{
	int nVar = GetLocalInt(oTarget, sVar);
	
	if (nVar & nFlag)
		{
		return TRUE;
		}
	
	return FALSE;
}

void HSS_DoFishingLineUse(object oUser, object oTarget)
{
	//not a fishing rod or not a valid target
	if (GetTag(oTarget) != FISHING_ROD_TAG || 	GetObjectType(oTarget) != OBJECT_TYPE_ITEM
	|| !GetIsObjectValid(oTarget))
		{
	SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
				"You can only attach this fishing line and hook to a fishing rod.");
	return;
	}

	//we have a fishing rod but it has a line attached		
	if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_CAST_SPELL) &&
		GetTag(oTarget) == FISHING_ROD_TAG)
		{	 
	SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
				"This fishing rod already has a line and hook attached.");
	return;	
	}
	
	//we have a fishing rod with no line and hook on it
	itemproperty ipRodUse = ItemPropertyCastSpell(
		IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY,
		IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

	IPSafeAddItemProperty(oTarget, ipRodUse);
	SendMessageToPC(oUser, HSS_FEEDBACK_COLOUR +
		"You attach the line and hook to your fishing rod.  You are now ready to fish.");	

}
void DisplayProgbar()
{
	//DisplayGuiScreen(oPC, "leg_info_progbar", FALSE, "leg_info_progbar.xml");
	//SetGUIObjectText(oPC, "leg_info_progbar", "NAME_TEXT", -1, "Fishing");
}
void EndFishing()
{
	EndAnims(oPC);
	CloseLoops(oPC);
	DeleteLocalInt(oPC, "HSS_CAST_ID");
	//CloseGUIScreen(oPC, "leg_info_progbar");
}