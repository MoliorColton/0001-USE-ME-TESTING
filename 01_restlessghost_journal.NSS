//-----------------------------------------------------------------------
// <copyright file="01_restlessghost_journal.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------

// When the skeletonwarlocks die, advance the journal state to 31. 
// EPF 8/17/06 
#include "ginc_group" 
const string GROUP_skelman = "grpskelman"; 
void main()
{
GroupAddTag(GROUP_skelman,"01_skelman1");
GroupAddTag(GROUP_skelman,"01_skelman2");
GroupOnDeathSetJournalEntry(GROUP_skelman, "01_restlessghost",31);	
}