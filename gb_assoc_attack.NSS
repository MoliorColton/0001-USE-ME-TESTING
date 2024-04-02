//-----------------------------------------------------------------------
// <copyright file="cb_assoc_attack.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
//::///////////////////////////////////////////////
//:: Associate On Attacked
//:: gb_assoc_attack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "hench_i0_assoc"

void main()
{
    if(!GetAssociateState(NW_ASC_IS_BUSY))
    {
        SetCommandable(TRUE);
        // Auldar: Don't want anything to interrupt a Taunt attempt.
		if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && !GetAssociateState(NW_ASC_MODE_PUPPET))
        {
			CheckRemoveStealth();
            // Auldar: Use checks from OnPerceive so we don't run DCR if we have a target.
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if(GetIsObjectValid(GetLastAttacker()))
                {
// 		Jug_Debug(GetName(OBJECT_SELF) + " on attacked combat round");
					HenchDetermineCombatRound(GetLastAttacker());
                }
            }
            if(GetSpawnInCondition(EVENT_ATTACKED))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
            }
        }
    }
}