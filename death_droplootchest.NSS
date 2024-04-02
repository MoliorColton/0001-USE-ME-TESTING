//-----------------------------------------------------------------------
// <copyright file="death_droplootchest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------

// Takes monster's inventory on death and transfers to a loot chest
// Note: Thinking about using death chest for who got the kill


void MakeLoot() //call in any death script
{
	string chesttag = "lootchest";
	location lLoc = GetLocation(OBJECT_SELF);
    object myLoot = GetFirstItemInInventory(OBJECT_SELF);
	object myChest = CreateObject(OBJECT_TYPE_PLACEABLE, chesttag, lLoc);
	SetLocalObject(OBJECT_SELF, "oKiller", GetLastKiller());
	//Takes inventory and transfers to chest
	while (GetIsObjectValid(myLoot) == TRUE)
	{
		CreateItemOnObject(GetTag(myLoot), myChest, 1 );//GetTag(myLoot)
		ActionTakeItem(myLoot,OBJECT_SELF);
		myLoot = GetNextItemInInventory(OBJECT_SELF);
	}
}

void main()
{
	MakeLoot();
	//below is the default death
	string sDeathScript = GetLocalString(OBJECT_SELF, "deathscript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, OBJECT_SELF);
	
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    object oKiller = GetLastKiller();

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	/*if (!GetIsSpirit(OBJECT_SELF))
    	craft_drop_items(oKiller);*/
}