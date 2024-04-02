//::///////////////////////////////////////////////
//:: FileName Npc Statue
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This Script Goes On The "OnHeartBeat" of a NPC Or Creature..
*/
//:://////////////////////////////////////////////
//:: Created By: --|Spectre|--
//:: Created On: 05/08/03
//:://////////////////////////////////////////////


void main()
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN),OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION),OBJECT_SELF);
}
