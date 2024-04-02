//-----------------------------------------------------------------------
// <copyright file="delrithjournal.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "ginc_group"
const string GROUP_ENEMY = "grpdelrith";

void main(string enemytag, string journal, int id)
{
 GroupAddTag(GROUP_ENEMY, "delrith");
 GroupOnDeathSetJournalEntry(GROUP_ENEMY, "demonslayer",9); 
}