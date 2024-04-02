//-----------------------------------------------------------------------
// <copyright file="gb_comp_block.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// gb_comp_block
/*
	companion On Block
*/
// ChazM 12/5/05

//:://////////////////////////////////////////////////
//:: X0_CH_HEN_BLOCK
/*
  OnBlocked handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////


void main()
{
    ExecuteScript("gb_assoc_block", OBJECT_SELF);
}