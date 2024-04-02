//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: x2_inc_spellhook
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file acts as a hub for all code that
    is hooked into the nwn spellscripts'
    If you want to implement material components
    into spells or add restrictions to certain
    spells, this is the place to do it.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-04
//:: Updated On: 2003-10-25
//:://////////////////////////////////////////////
// ChazM 8/16/06 added workbench check to X2PreSpellCastCode()
// ChazM 8/27/06 modified  X2PreSpellCastCode() - Fire "cast spell at" event on a workbench. 
//#include "x2_inc_itemprop" - Inherited from x2_inc_craft

#include "x2_inc_craft"
#include "ginc_crafting"
#include "profession_include"

const int X2_EVENT_CONCENTRATION_BROKEN = 12400;

// Use Magic Device Check.
// Returns TRUE if the Spell is allowed to be cast, either because the
// character is allowed to cast it or he has won the required UMD check
// Only active on spell scroll
int X2UseMagicDeviceCheck();

// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int X2PreSpellCastCode();

// check if the spell is prohibited from being cast on items
// returns FALSE if the spell was cast on an item but is prevented
// from being cast there by its corresponding entry in des_crft_spells
// oItem - pass GetSpellTargetObject in here
int X2CastOnItemWasAllowed(object oItem);

// Sequencer Item Property Handling
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
// oItem - pass GetSpellTargetObject in here
int X2GetSpellCastOnSequencerItem(object oItem);

int X2RunUserDefinedSpellScript();

int X2UseMagicDeviceCheck()
{
    int nRet = ExecuteScriptAndReturnInt("x2_pc_umdcheck",OBJECT_SELF);
    return nRet;
}

//------------------------------------------------------------------------------
// GZ: This is a filter I added to prevent spells from firing their original spell
// script when they were cast on items and do not have special coding for that
// case. If you add spells that can be cast on items you need to put them into
// des_crft_spells.2da
//------------------------------------------------------------------------------
int X2CastOnItemWasAllowed(object oItem)
{
    int bAllow = (Get2DAString(X2_CI_CRAFTING_SP_2DA,"CastOnItems",GetSpellId()) == "1");
    if (!bAllow)
    {
        FloatingTextStrRefOnCreature(83453, OBJECT_SELF); // not cast spell on item
    }
    return bAllow;

}

//------------------------------------------------------------------------------
// Execute a user overridden spell script.
//------------------------------------------------------------------------------
int X2RunUserDefinedSpellScript()
{
    // See x2_inc_switches for details on this code
    string sScript =  GetModuleOverrideSpellscript();
    if (sScript != "")
    {
        ExecuteScript(sScript,OBJECT_SELF);
        if (GetModuleOverrideSpellScriptFinished() == TRUE)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//------------------------------------------------------------------------------
// Created Brent Knowles, Georg Zoeller 2003-07-31
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
//------------------------------------------------------------------------------
int X2GetSpellCastOnSequencerItem(object oItem)
{

    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    int nMaxSeqSpells = IPGetItemSequencerProperty(oItem); // get number of maximum spells that can be stored
    if (nMaxSeqSpells <1)
    {
        return FALSE;
    }

    if (GetIsObjectValid(GetSpellCastItem())) // spell cast from item?
    {
        // we allow scrolls
        int nBt = GetBaseItemType(GetSpellCastItem());
        if ( nBt !=BASE_ITEM_SPELLSCROLL && nBt != 105)
        {
            FloatingTextStrRefOnCreature(83373, OBJECT_SELF);
            return TRUE; // wasted!
        }
    }

    // Check if the spell is marked as hostile in spells.2da
    int nHostile = StringToInt(Get2DAString("spells","HostileSetting",GetSpellId()));
    if(nHostile ==1)
    {
        FloatingTextStrRefOnCreature(83885,OBJECT_SELF);
        return TRUE; // no hostile spells on sequencers, sorry ya munchkins :)
    }

    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = GetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
    }
    else
    {
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);
    }

    return TRUE; // in any case, spell is used up from here, so do not fire regular spellscript
}

//------------------------------------------------------------------------------
// * This is our little concentration system for black blade of disaster
// * if the mage tries to cast any kind of spell, the blade is signaled an event to die
//------------------------------------------------------------------------------
void X2BreakConcentrationSpells()
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if (GetIsObjectValid(oAssoc) && GetIsPC(OBJECT_SELF)) // only applies to PCS
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
        }
    }
}

//------------------------------------------------------------------------------
// being hit by any kind of negative effect affecting the caster's ability to concentrate
// will cause a break condition for concentration spells
//------------------------------------------------------------------------------
int X2GetBreakConcentrationCondition(object oPlayer)
{
     effect e1 = GetFirstEffect(oPlayer);
     int nType;
     int bRet = FALSE;
     while (GetIsEffectValid(e1) && !bRet)
     {
        nType = GetEffectType(e1);

        if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
            nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_FRIGHTENED ||
            nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_CONFUSED ||
            nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_POLYMORPH)
         {
           bRet = TRUE;
         }
                    e1 = GetNextEffect(oPlayer);
     }
    return bRet;
}

void X2DoBreakConcentrationCheck()
{
    object oMaster = GetMaster();
    if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
    {
         if (GetIsObjectValid(oMaster))
         {
            int nAction = GetCurrentAction(oMaster);
            // master doing anything that requires attention and breaks concentration
            if (nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT ||
                nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT ||
                nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP ||
                nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
            else if (X2GetBreakConcentrationCondition(oMaster))
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
         }
    }
}

//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int X2PreSpellCastCode()
{
	object oPC = OBJECT_SELF;
	int nSPELL = GetSpellId();
	
	//----------------------------------
	//Spell Rune Component for Molior RS
	//----------------------------------
	int nAIR;	int nMND;	int nWAT;	int nERT;	int nFIR;	int nBOD;
	int nCOS;	int nCHA;	int nAST;	int nNAT;	int nLAW;	int nDTH;
	int nBLD;	int nSOU;
	int nSKIP = FALSE;
	
	switch (nSPELL)
	{
		case SPELL_ACID_FOG: nBLD = 1; nAIR = 5; nERT = 7; break;
		case SPELL_BURNING_HANDS: nMND = 1; nAIR = 2; nFIR = 3; break;
		case SPELL_CHAIN_LIGHTNING: nBLD = 1; nAIR = 10; break;
		case SPELL_CONE_OF_COLD: nBLD = 1; nAIR = 5; nWAT = 7; break;
		case SPELL_CONFUSION: nSOU = 1; nERT = 8; nWAT = 8; break;
		case SPELL_DAZE: nBOD = 1; nERT = 2; nWAT = 3; break;
		case SPELL_DELAYED_BLAST_FIREBALL: nBLD = 1; nAIR = 5; nFIR = 7; break;
		case SPELL_FIREBALL: nCHA = 1; nAIR = 3; nFIR = 4; break;
		case SPELL_FLAME_ARROW: nDTH = 1; nAIR = 4; nFIR = 5; break;
		case SPELL_GREATER_SPELL_MANTLE: nDTH = 10; nBLD = 10; break;
		case SPELL_HASTE: nAIR = 10; break;
		case SPELL_HOLD_MONSTER: nNAT = 4; nERT = 5; nWAT = 5; break;
		case SPELL_HOLD_PERSON: nNAT = 2; nERT = 3; nWAT = 3; break;
		case SPELL_INCENDIARY_CLOUD: nBLD = 1; nFIR = 10; break;
		case SPELL_LIGHT: nAIR = 5; nMND = 5; break;
		case SPELL_LIGHTNING_BOLT: nDTH = 1; nAIR = 3; break;
		case SPELL_MAGIC_MISSILE: nMND = 1; nAIR = 1; nWAT = 1; break;
		case SPELL_MELFS_ACID_ARROW: nCHA = 1; nAIR = 2; nERT = 3; break;
		case SPELL_METEOR_SWARM: nBLD = 1; nAIR = 8; nFIR = 10; break;
		case SPELL_RAY_OF_FROST: nMND = 1; nAIR = 1; break;
		case SPELL_SHADOW_SHIELD: nDTH = 10; break;
		case SPELL_SLOW: nNAT = 3; nERT = 4; nWAT = 4; break;
		case SPELL_SPELL_MANTLE: nDTH = 5; nBLD = 5; break;
		case SPELL_FOXS_CUNNING: nMND = 25; break;
		case SPELL_HORRID_WILTING: nBLD = 1; nERT = 10; break;
		case SPELL_ICE_STORM: nDTH = 1; nAIR = 3; nWAT = 3; break;
		case SPELL_ISAACS_LESSER_MISSILE_STORM: nBLD = 1; nAIR = 5; nWAT = 7; break;
		case SPELL_ISAACS_GREATER_MISSILE_STORM: nBLD = 2; nAIR = 10; nWAT = 14; break;
		case SPELL_GEDLEES_ELECTRIC_LOOP: nCHA = 1; nAIR = 2; break;
		case SPELL_CLOUD_OF_BEWILDERMENT: nBOD = 1; nERT = 2; nWAT = 3; break;
		case SPELL_POLAR_RAY: nBLD = 2; nAIR = 10; break;
		case SPELL_ORB_OF_ACID: nDTH = 1; nAIR = 3; nERT = 3; break;
		default: nSKIP = TRUE;
	}
	
	if (nSKIP == FALSE)
	{
		string sRUNE;
		int nRUNE;
		int nFAIL;
		int nCOUNT;
		while (nCOUNT < 14)
		{
			switch (nCOUNT)
			{
				case 0: nRUNE = nSOU; sRUNE = "soulrune"; break;
				case 1: nRUNE = nAIR; sRUNE = "airrune"; break;
				case 2: nRUNE = nMND; sRUNE = "mindrune"; break;
				case 3: nRUNE = nWAT; sRUNE = "waterrune"; break;
				case 4: nRUNE = nERT; sRUNE = "earthrune"; break;
				case 5: nRUNE = nFIR; sRUNE = "firerune"; break;
				case 6: nRUNE = nBOD; sRUNE = "bodyrune"; break;
				case 7: nRUNE = nCOS; sRUNE = "cosmicrune"; break;
				case 8: nRUNE = nCHA; sRUNE = "chaosrune"; break;
				case 9: nRUNE = nAST; sRUNE = "astralrune"; break;
				case 10: nRUNE = nNAT; sRUNE = "naturerune"; break;
				case 11: nRUNE = nLAW; sRUNE = "lawrune"; break;
				case 12: nRUNE = nDTH; sRUNE = "deathrune"; break;
				case 13: nRUNE = nBLD; sRUNE = "bloodrune"; break;
			}
			if (nRUNE > 0)
			{
				if (GetItemQuantity(oPC, sRUNE) < nRUNE)
				{
					nFAIL = TRUE;
					break;
				}
			}
			nCOUNT = nCOUNT + 1;
		}
	
		if (nFAIL == TRUE)
		{
			FloatingTextStringOnCreature("You don't have the required runes to cast the spell.", oPC, FALSE);
			return FALSE;
		}
		else
		{
			nCOUNT = 0;
			while (nCOUNT < 14)
			{
				switch (nCOUNT)
				{
					case 0: nRUNE = nSOU; sRUNE = "soulrune"; break;
					case 1: nRUNE = nAIR; sRUNE = "airrune"; break;
					case 2: nRUNE = nMND; sRUNE = "mindrune"; break;
					case 3: nRUNE = nWAT; sRUNE = "waterrune"; break;
					case 4: nRUNE = nERT; sRUNE = "earthrune"; break;
					case 5: nRUNE = nFIR; sRUNE = "firerune"; break;
					case 6: nRUNE = nBOD; sRUNE = "bodyrune"; break;
					case 7: nRUNE = nCOS; sRUNE = "cosmicrune"; break;
					case 8: nRUNE = nCHA; sRUNE = "chaosrune"; break;
					case 9: nRUNE = nAST; sRUNE = "astralrune"; break;
					case 10: nRUNE = nNAT; sRUNE = "naturerune"; break;
					case 11: nRUNE = nLAW; sRUNE = "lawrune"; break;
					case 12: nRUNE = nDTH; sRUNE = "deathrune"; break;
					case 13: nRUNE = nBLD; sRUNE = "bloodrune"; break;
				}
				RemoveItems(oPC, sRUNE, nRUNE);
				nCOUNT = nCOUNT + 1;
			}
			return TRUE;
		}
	}
	
   object oTarget = GetSpellTargetObject();
   int nContinue;

   //---------------------------------------------------------------------------
   // This stuff is only interesting for player characters we assume that use
   // magic device always works and NPCs don't use the crafting feats or
   // sequencers anyway. Thus, any NON PC spellcaster always exits this script
   // with TRUE (unless they are DM possessed or in the Wild Magic Area in
   // Chapter 2 of Hordes of the Underdark.
   //---------------------------------------------------------------------------
   if (!GetIsPC(oPC))
   {
       if( !GetIsDMPossessed(oPC) && !GetLocalInt(GetArea(oPC), "X2_L_WILD_MAGIC"))
       {
            return TRUE;
       }
   }

   //---------------------------------------------------------------------------
   // Break any spell require maintaining concentration (only black blade of
   // disaster)
   // /*REM*/ X2BreakConcentrationSpells();
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Run use magic device skill check
   //---------------------------------------------------------------------------
   nContinue = X2UseMagicDeviceCheck();

   if (nContinue)
   {
       //-----------------------------------------------------------------------
       // run any user defined spellscript here
       //-----------------------------------------------------------------------
       nContinue = X2RunUserDefinedSpellScript();
   }

   //---------------------------------------------------------------------------
   // The following code is only of interest if an item was targeted
   //---------------------------------------------------------------------------
   if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
   {

       //-----------------------------------------------------------------------
       // Check if spell was used to trigger item creation feat
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft", oPC);
       }

       //-----------------------------------------------------------------------
       // Check if spell was used for on a sequencer item
       //-----------------------------------------------------------------------
       if (nContinue)
       {
            nContinue = (!X2GetSpellCastOnSequencerItem(oTarget));
       }

       //-----------------------------------------------------------------------
       // * Execute item OnSpellCast At routing script if activated
       //-----------------------------------------------------------------------
       if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
       {
             SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
             int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget), oPC);
             if (nRet == X2_EXECUTE_SCRIPT_END)
             {
                return FALSE;
             }
       }

	   /* Brock H. - OEI 07/05/06 - Removed for NWN2
	   
       //-----------------------------------------------------------------------
       // Prevent any spell that has no special coding to handle targetting of items
       // from being cast on items. We do this because we can not predict how
       // all the hundreds spells in NWN will react when cast on items
       //-----------------------------------------------------------------------
       if (nContinue) {
           nContinue = X2CastOnItemWasAllowed(oTarget);
       }
	   */
   }

	//---------------------------------------------------------------------------
	// The following code is only of interest if a placeable was targeted
	//---------------------------------------------------------------------------
	if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
	{	// spells going off on crafting workbenches causes to much carnage.  
		// Maybe we should have the spells actually fire in hard core mode... 
		// Although death by labratory experiment might be too much even for the hard core... ;)
		// We turn off effects for all workbenches just to avoid any confusion.
		// since the spell won't fire or signal the cast event, we do so here.
		if (IsWorkbench(oTarget))
		{
			nContinue = FALSE;
		    //Fire "cast spell at" event on a workbench. (only needed for magical workbenches currently)
		    SignalEvent(oTarget, EventSpellCastAt(oPC, nSPELL, FALSE));
			
		}
	}
			
   return nContinue;
}