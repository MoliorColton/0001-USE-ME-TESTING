//-----------------------------------------------------------------------------
//  C Daniel Vale 2007
//  djvale@gmail.com
//
//  C Laurie Vale 2007
//  charlievale@gmail.com
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
//------------------------------------------------------------------------------
//  Script Name: i_vn_mer_purse_ac
//  Description: Use to drop gold on the ground from your purse.
//------------------------------------------------------------------------------

const int nGold = 10;
const string PLACEABLE_GOLD = "vn_mer_dropped_gold";

void main()
{
	object oPC = GetItemActivator();
	object oPurse = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();
	
	int nGoldOnHand = GetGold(oPC);
	
	if (nGoldOnHand < 10)
	{
		SendMessageToPC(oPC, "You do not have enough gold to be throwing it away.");
	}
	else
	{
		
		AssignCommand( oPC, TakeGoldFromCreature(10, oPC, TRUE) );
		
		CreateObject(OBJECT_TYPE_PLACEABLE, PLACEABLE_GOLD, lTarget);
	}
}