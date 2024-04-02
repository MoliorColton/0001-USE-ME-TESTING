/*

    Script:			The NPC AI include file.  It is a collection of functions for each of the
					NPC special activities.
	Version:		1.4
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		1.0 - 10/04/2012 MV - Initial Version
					1.1 - 11/04/2012 MV - Moved all anims to PlayCustom wrapper
					1.2 - 11/11/2012 MV - Moved Master Include from AI Include to here.
					1.3 - 11/14/2012 MV - Added 3 new NPC Activities
					1.4 - 07/22/2015 MV - Minor change to Worship

*/
// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////

// Seriously?  Do you really need descriptions of what these do?  I didn't think so.
void LEG_AI_NPCActions_BattleTraining(object oNPC, object oFactionObject);
void LEG_AI_NPCActions_RemoveEffectsFromSpell(object oTarget, int SpellID);
void LEG_AI_NPCActions_FaceObject(object oObject, int iFace = 0);
void LEG_AI_NPCAction_Agree(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Angry(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Sad(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Cook(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_FemDance(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_MaleDance(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Drum(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Flute(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Forge(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Guitar(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_sman(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Meditate(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_SitRead(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Sit(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_SitEat(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Cheer(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_NPC1Training(object oNPC, object oWP);
void LEG_AI_NPCAction_NPC2Training(object oNPC, object oWP);
void LEG_AI_NPCAction_CookingMulti(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_ForgeMulti(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_KneelTalk(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Taunt(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_Worship(object oNPC, object oWP, int iRoll);
void LEG_AI_NPCAction_BardSong(object oNPC, object oWP);
void LEG_AI_NPCAction_Drink(object oNPC, object oWP, int iRoll);



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// //////////////////////////////////////////////////
// LEG_AI_NPCActions_BattleTraining
// //////////////////////////////////////////////////
void LEG_AI_NPCActions_BattleTraining(object oNPC, object oFactionObject)
{
	ChangeFaction(oNPC, oFactionObject);
	object oEnemy = GetNearestObject(OBJECT_TYPE_CREATURE, oNPC);	
	object oEnemy2 = GetNearestObjectByTag ("leg_ai_target" , oNPC);		
	int nEnemycheck = GetIsEnemy(oEnemy, oNPC);
	if (nEnemycheck == TRUE)
	{
		ActionAttack(oEnemy, 0);
	}
	else
	{
		ActionAttack(oEnemy2, 0);
	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCActions_RemoveEffectsFromSpell
// //////////////////////////////////////////////////
void LEG_AI_NPCActions_RemoveEffectsFromSpell(object oTarget, int SpellID)
{
  	effect eLook = GetFirstEffect(oTarget);
  	while (GetIsEffectValid(eLook)) 
	{
    	if (GetEffectSpellId(eLook) == SpellID)
		{
      		RemoveEffect(oTarget, eLook);
			eLook = GetFirstEffect(oTarget);	// 8/28/06 - BDF-OEI: start back at the beginning to ensure that linked effects are removed safely
		}
		else	eLook = GetNextEffect(oTarget);
  	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCActions_FaceObject
// //////////////////////////////////////////////////
void LEG_AI_NPCActions_FaceObject(object oObject, int iFace = 0)
{
	float fFacing = GetFacing(OBJECT_SELF);
	float fWPFacing = GetFacing(oObject) + IntToFloat(iFace);
	if (fFacing != fWPFacing)
	{
		SetFacing(fWPFacing);
	}
}

// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Agree
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Agree(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		PlayCustomAnimation(oNPC, "flirt", 0, 5.0);
	}
	if (iRoll > 24)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "nodyes",0,1.5);
		DelayCommand(1.6, LEG_COMMON_ActionPlayCustomAnimation(oNPC, "chuckle", 0, 2.0));
		DelayCommand(3.7, LEG_COMMON_ActionPlayCustomAnimation(oNPC, "nodyes", 0, 1.5));
	}
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Angry
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Angry(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "nodno", 0, 1.5);
		DelayCommand(1.6,LEG_COMMON_ActionPlayCustomAnimation(oNPC, "intimidate", 0, 4.5));
	}
	else if (iRoll > 24 && iRoll < 50)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "intimidate", 0, 5.0);;
	}
	else if (iRoll > 49 && iRoll < 75)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "talkshout", 0, 6.0);
	}
	else 
	{
		PlayAnimation (10,1.0,0.0);
	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Sad
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Sad(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);

	if (iRoll < 25)
	{
		PlayAnimation (9, 1.0, 0.0);
	}  
	else if (iRoll > 24 && iRoll < 50)
	{
		LEG_COMMON_ActionPlayCustomAnimation (OBJECT_SELF, "talksad",0,6.0);
	}
	else if (iRoll > 49)
	{
		LEG_COMMON_ActionPlayCustomAnimation (OBJECT_SELF, "tired",0,6.0);
	}
}					


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Cook
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Cook(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);
	LEG_AI_NPCActions_FaceObject(oWP);
	
	//by default I'm using the same vfx, but you could change the vfx or equip a dagger to give some variety to the animations.
	effect eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_spoon"), 100);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oNPC);
	if (iRoll < 33)
	{
		PlayAnimation (35, 1.0, 0.0);
	}
	else if (iRoll > 32 && iRoll < 66)
	{
		PlayAnimation (36, 1.0, 0.0);
	}
   	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "cooking02",0,4.0);
		DelayCommand (4.1,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "disablefront",0,1.8));
	}
}






// //////////////////////////////////////////////////
// LEG_AI_NPCAction_FemDance
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_FemDance(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);

	if (iRoll < 33)
	{
		PlayAnimation(27, 1.5, 6.0);
	}
	else if (iRoll > 32 && iRoll < 66)
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "dance01", 0, 4.4);
		DelayCommand(4.5, LEG_COMMON_ActionPlayCustomAnimation(oNPC, "curtsey", 0, 1.4));
	}
}		

// //////////////////////////////////////////////////
// LEG_AI_NPCAction_MaleDance
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_MaleDance(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 33)
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "dance01", 0, 4.0);
		DelayCommand (4.1,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "bow", 0, 1.8));
	}
	else if (iRoll > 32 && iRoll < 66)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "dance02", 1, 5.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "dance02", 1, 5.0);
	}
}		




// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Drum
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Drum(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "playdrum", 0, 3.8);
		DelayCommand(3.8, LEG_COMMON_ActionPlayCustomAnimation (oNPC, "bow", 0, 2.2));
	}
   	else if (iRoll > 24 && iRoll < 50)
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "playdrum", 1, 1.0);
	}
}			



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Flute
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Flute(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll > 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "playflute",0,2.0);
		DelayCommand(2.1,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "playflute", 0, 2.0));
		DelayCommand(4.2,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "curtsey", 0, 1.4));
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "playflute", 1, 1.0);
	}
}







// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Forge
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Forge(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "forge01", 1, 1.0);
	}
   	else if (iRoll > 24 && iRoll < 50)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "dustoff", 0, 6.0);
	}
   else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "craft01", 0, 5.0);
	}
}		



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Guitar
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Guitar(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "playguitar", 0, 1.9);
		DelayCommand (2.0,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "bow", 0, 4.0));
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "playguitar",1,1.0);
	}
}





// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Woodsman
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Woodsman(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 95)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "*1attack01", 1, 4.9);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelidle", 1, 4.9); //maybe you want a periodic rest for your npcs.
	}
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Meditate
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Meditate(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	LEG_COMMON_ActionPlayCustomAnimation(oNPC, "meditate", 1, 1.0);
}


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_SitRead
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_SitRead(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);
	LEG_AI_NPCActions_FaceObject(oWP);
	SetOrientOnDialog(oNPC, FALSE);
	if (iRoll < 75)
	{
		effect eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_book"), 100);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oNPC);
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sitread", 1, 3.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sitteat", 0, 1.0);
	}
}		




// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Sit
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Sit(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	SetOrientOnDialog(oNPC, FALSE);
	if (iRoll < 42)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk01", 0, 6.0);
	}
	else if (iRoll > 41 && iRoll < 67)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sitfidget", 0, 6.0);
	}
	else if (iRoll > 66 && iRoll < 83)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk01", 0, 6.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk02", 0, 6.0);
	}
}		

// //////////////////////////////////////////////////
// LEG_AI_NPCAction_SitEat
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_SitEat(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	SetOrientOnDialog(oNPC, FALSE);
	if (iRoll < 33)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk", 0, 1.0);
	}
	else if (iRoll > 32 && iRoll < 49)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk01", 0, 1.0);
	}
	else if (iRoll > 48 && iRoll < 65)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sitdrink", 0, 2.0);
	}
	else if (iRoll > 64 && iRoll < 90)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "siteat", 0, 1.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sittalk02", 0, 6.0);
	}
}




// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Cheer
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Cheer(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 14) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "victory",0,5.0);
	}
	else if(iRoll > 13 && iRoll < 56)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "clapping",0,3.4);
		DelayCommand(3.5,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "chuckle",0,2.0));
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "talklaugh", 0, 1.0);			
	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_NPC1Training
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_NPC1Training(object oNPC, object oWP)
{
	SetPlotFlag(oNPC,1);
	object oFactionObject = GetObjectByTag("leg_ai_trainingfaction1");
	LEG_AI_NPCActions_BattleTraining(oNPC, oFactionObject);
}		 

// //////////////////////////////////////////////////
// LEG_AI_NPCAction_NPC2Training
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_NPC2Training(object oNPC, object oWP)
{
	SetPlotFlag(oNPC,1);
	object oFactionObject = GetObjectByTag("leg_ai_trainingfaction2");
	LEG_AI_NPCActions_BattleTraining(oNPC, oFactionObject);
}		 



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_CookingMulti
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_CookingMulti(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);
	LEG_AI_NPCActions_FaceObject(oWP);
	
	// Find out which Action Set I am using, how many times I've used this set
	// and when I should change sets.
	int iCurrentActionSet = GetLocalInt(OBJECT_SELF, "AI_ActionSet");
	int iCurrentActionCount = GetLocalInt(OBJECT_SELF, "AI_ActionCount");
	int iCurrentActionChange = GetLocalInt(OBJECT_SELF, "AI_ActionChange");
	effect eEffect;
	switch(iCurrentActionSet)
	{
		case 1:
			eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_spoon"), 100);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oNPC);
			if (iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "cooking01",0,5.9);                   
			}
			else
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "cooking02",0,4.0);
				DelayCommand (4.1,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "disablefront",0,1.8));
			}
			break;
		case 2:
			if (iRoll < 34)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "kneelidle",1,3.0);
				DelayCommand(3.0,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelup",0,1.4));
				DelayCommand(4.5,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "gettable",0,1.4));	
			}
			else if (iRoll > 33 && iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "openlock",1,1.0);	
			}
			else
			{
		 		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "dustoff",0,5.9);	                   
			}
			break;
		case 3:
			if (iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "forge01",0,3.4);   
				DelayCommand(3.5, LEG_COMMON_ActionPlayCustomAnimation (oNPC, "scratchhead",0,1.7));	
			}
			else
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "craft01",1,5.8);
			}
			break;
	
	}

	// Increment how many times I've performed an action.	
	iCurrentActionCount++;
	SetLocalInt(oNPC, "AI_ActionCount", iCurrentActionCount);	
	
	// If I have done this action set enough times, change my WP and set to something else.
	if (iCurrentActionCount >= iCurrentActionChange)
	{
		iCurrentActionCount = 0;
		iCurrentActionSet = Random(2) + 1;
		iCurrentActionChange = d3(2);
		SetLocalInt(oNPC, "AI_ActionCount", 0);
		SetLocalInt(oNPC, "AI_ActionChange", iCurrentActionChange);
		SetLocalInt(oNPC, "AI_ActionSet", iCurrentActionSet);
		SetLocalInt(oNPC, "AI_ChooseNewWP", 1);
	}
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_ForgeMulti
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_ForgeMulti(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);
	LEG_AI_NPCActions_FaceObject(oWP);
	
	// Find out which Action Set I am using, how many times I've used this set
	// and when I should change sets.
	int iCurrentActionSet = GetLocalInt(OBJECT_SELF, "AI_ActionSet");
	int iCurrentActionCount = GetLocalInt(OBJECT_SELF, "AI_ActionCount");
	int iCurrentActionChange = GetLocalInt(OBJECT_SELF, "AI_ActionChange");
	effect eEffect;
	switch(iCurrentActionSet)
	{
		case 1:
			eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_spoon"), 100);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oNPC);
			if (iRoll < 34)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "forge02",1,1.0);	
			}
			else if (iRoll > 33 && iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "craft01",1,5.9);                   
			}
			else
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "forge01",1,1.0);
			}
			break;
		case 2:
			if (iRoll < 34)
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelidle",1,3.0);
				DelayCommand (3.0,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelup",0,1.4));
				DelayCommand (4.5,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "gettable",0,1.4));	
			}
			else if (iRoll > 33 && iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation(oNPC, "openlock",1,1.0);	
			}
			else
			{
		 		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "dustoff",0,5.9);	                   
			}
			break;
		case 3:
			if (iRoll < 67)
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneeldown",0,1.4);
				DelayCommand (1.5,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelup",0,1.4));
				DelayCommand (3.2,LEG_COMMON_ActionPlayCustomAnimation (oNPC, "gettable",0,1.4));	
			}
			else
			{
		        LEG_COMMON_ActionPlayCustomAnimation (oNPC, "openlock",1,1.0);
			}
			break;
	}

	// Increment how many times I've performed an action.	
	iCurrentActionCount++;
	SetLocalInt(oNPC, "AI_ActionCount", iCurrentActionCount);	
	
	// If I have done this action set enough times, change my WP and set to something else.
	if (iCurrentActionCount >= iCurrentActionChange)
	{
		iCurrentActionCount = 0;
		iCurrentActionSet = Random(2) + 1;
		iCurrentActionChange = d3(2);
		SetLocalInt(oNPC, "AI_ActionCount", 0);
		SetLocalInt(oNPC, "AI_ActionChange", iCurrentActionChange);
		SetLocalInt(oNPC, "AI_ActionSet", iCurrentActionSet);
		SetLocalInt(oNPC, "AI_ChooseNewWP", 1);
	}
}




// //////////////////////////////////////////////////
// LEG_AI_NPCAction_KneelTalk
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_KneelTalk(object oNPC, object oWP, int iRoll)
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 33) 
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelidle",1,5.9);
	}
	else
	{
		LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneeltalk",1,5.9);
		//DelayCommand (5.0, LEG_COMMON_ActionPlayCustomAnimation (oNPC, "kneelidle", 1,1.0));
	}
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Taunt
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Taunt(object oNPC, object oWP, int iRoll) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	if (iRoll < 25)
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "taunt ",0,1.9);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "taunt ",1,1.0);
	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Worship
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Worship(object oNPC, object oWP, int iRoll) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	
	if (iRoll == 1) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC,"def_conjureloop",1,1.0);
	}
	else if (iRoll == 2) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "gen_conjureloop",1,6.0);
	}
	else if (iRoll == 3) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "meditate",1,1.0);
	}
	else if (iRoll == 4) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "scrollrecite",1,1.0);
	}
	else if (iRoll == 5) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "worship",1,1.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "touchheart",1,1.0);
	}
}	




// //////////////////////////////////////////////////
// LEG_AI_NPCAction_BardSong
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_BardSong(object oNPC, object oWP) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	LEG_COMMON_ActionPlayCustomAnimation(oNPC, "bardsong",1,4.0);
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_Drink
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_Drink(object oNPC, object oWP, int iRoll) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);
	
	if (iRoll >= 10) 
	{
		effect eEffect;
		int nHold = Random (3);
		switch (nHold)
		{
			case 0: {eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_wine"), 100);}
			case 1: {eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_chalice"), 100);}
			case 2: {eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile("fx_handr_stein"), 100);}
		}
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oNPC);
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "DRINK",1, 5.0, 1.0); 
	}
	else if (iRoll == 9) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "sigh",1,1.0);
	}
	else if (iRoll == 8) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC,  "yawn",1,1.0);
	}
	else if (iRoll == 7) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "laugh",1,1.0);
	}
	else if (iRoll == 6) 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC, "drunk",1,1.0);
	}
	else 
	{
		LEG_COMMON_ActionPlayCustomAnimation(oNPC,  "DRINKBEER_IDLE",1,1.0);
	}
}



// //////////////////////////////////////////////////
// LEG_AI_NPCAction_AnimalGraze
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_AnimalGraze(object oNPC, object oWP, int iRoll) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);

	if (GetDistanceToObject(oWP) <= 45.0) 
	{
		if (iRoll < 4) 
		{
			ActionRandomWalk();
		}
		else 
		{
			ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK, 0.2);
		}
	}
	else 
	{
		ActionMoveToObject(oWP, FALSE, 15.0);
	}
}


// //////////////////////////////////////////////////
// LEG_AI_NPCAction_SitFiget
// //////////////////////////////////////////////////
void LEG_AI_NPCAction_SitFiget(object oNPC, object oWP, int iRoll) 
{
	LEG_AI_NPCActions_FaceObject(oWP);
	LEG_AI_NPCActions_RemoveEffectsFromSpell(oNPC, 100);

	if (iRoll > 16) {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "sitidle", 1, 1.0);}
	else if (iRoll > 12) {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "sittalk01", 1, 1.0);}
	else if (iRoll > 10) {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "sitdrink", 1, 1.0);}
	else if (iRoll > 6) {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "sitread", 1, 1.0);}
	else if (iRoll > 4) {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "siteat", 1, 1.0);}
	else {LEG_COMMON_ActionPlayCustomAnimation(OBJECT_SELF, "sitfidget", 1, 1.0);}

}