//-----------------------------------------------------------------------
// <copyright file="countdray.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "ginc_group"

const string GROUP_COUNTDRAYNOR = "grpcountdraynor";

void main()
{
 GroupAddTag(GROUP_COUNTDRAYNOR,"countdraynor");
 GroupOnDeathSetJournalEntry(GROUP_COUNTDRAYNOR, "q_vampireslayer",0); 
}