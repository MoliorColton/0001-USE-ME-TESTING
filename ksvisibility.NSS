// gui_ks_visibility.nss
// Apply transparency effects
// see <http://social.bioware.com/forum/1/topic/163/index/7851832>
// by Brendan Bellina, aka "Kaldor Silverwand", July 2011

// Updated Aug 2011 by B Bellina
// - added 20, 60, 80 transparency
// - added functions to make weapons visible, invisible
// - added option to apply effects to entire faction

// based on work by MasterChanger, Kamiryn's Official Campaign Tools & Fixes, and M. Rieder's Invisibility VFX

// this script runs on PC character of the player

// Requires ks_fx_ghostly_20.sef, ks_fx_ghostly_40.sef, ks_fx_ghostly_60.sef, and ks_fx_ghostly_80.sef by Kaldor Silverwand
// Requires total_invisibility.sef by M. Rieder

void ks_SetEffect(string sVFX, object oTarget = OBJECT_SELF, int bForWholeFaction = FALSE);
void ks_RemoveEffect(string sVFX, object oTarget = OBJECT_SELF, int bForWholeFaction = FALSE);
void ks_RemoveAllVisibilityEffects(object oTarget = OBJECT_SELF, int bForWholeFaction = FALSE);
void ks_SetWeaponVisibility(object oTarget = OBJECT_SELF, int nVisible = 4, int bForWholeFaction = FALSE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)

void SetVisibility(object oTarget, int nMode)
{
	switch (nMode)
	{
		case 0: // Make character invisible
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetEffect("total_invisibility", oTarget);
			ks_SetWeaponVisibility(oTarget, FALSE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 1: // Make faction invisible
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetEffect("total_invisibility", oTarget, TRUE);
			ks_SetWeaponVisibility(oTarget, FALSE, TRUE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 2: // ghostly 20 character
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetEffect("ks_fx_ghostly_20", oTarget);
			break;
		case 3: // ghostly 20 faction
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetEffect("ks_fx_ghostly_20", oTarget, TRUE);
			break;
		case 4: // ghostly 40 character
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetEffect("ks_fx_ghostly_40", oTarget);
			break;
		case 5: // ghostly 40 faction
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetEffect("ks_fx_ghostly_40", oTarget, TRUE);
			break;
		case 6: // ghostly 60 character
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetEffect("ks_fx_ghostly_60", oTarget);
			break;
		case 7: // ghostly 60 faction
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetEffect("ks_fx_ghostly_60", oTarget, TRUE);
			break;
		case 8: // ghostly 80 character
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetEffect("ks_fx_ghostly_80", oTarget);
			break;
		case 9: // ghostly 80 faction
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetEffect("ks_fx_ghostly_80", oTarget, TRUE);
			break;
		case 10: // Revert character
			ks_RemoveAllVisibilityEffects(oTarget);
			ks_SetWeaponVisibility(oTarget); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 11: // Revert Faction
			ks_RemoveAllVisibilityEffects(oTarget, TRUE);
			ks_SetWeaponVisibility(oTarget, 4, TRUE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 12: // Hide Weapons character
			ks_SetWeaponVisibility(oTarget, FALSE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 13: // Hide Weapons Faction
			ks_SetWeaponVisibility(oTarget, FALSE, TRUE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 14: // Revert Weapons character
			ks_SetWeaponVisibility(oTarget, 4); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
		case 15: // Revert Weapons Faction
			ks_SetWeaponVisibility(oTarget, 4, TRUE); // FALSE for force invisible, TRUE for force visible, 4 for remove override (default)
			break;
	}
}

void ks_SetEffect(string sVFX, object oTarget, int bForWholeFaction)
{
	if (GetIsObjectValid(oTarget))
	{
		if (bForWholeFaction)
		{
			object oMember = GetFirstFactionMember(oTarget, FALSE);
			while (GetIsObjectValid(oMember))
			{
				effect eVfx = SupernaturalEffect(EffectNWN2SpecialEffectFile(sVFX));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVfx, oMember);
				oMember = GetNextFactionMember(oTarget,FALSE);			
			}		
		}
		else
		{
			effect eVfx = SupernaturalEffect(EffectNWN2SpecialEffectFile(sVFX));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVfx, oTarget);
		}
	}
}
	

void ks_RemoveEffect(string sVFX, object oTarget, int bForWholeFaction)
{
	if (GetIsObjectValid(oTarget))
	{
		if (bForWholeFaction)
		{
			object oMember = GetFirstFactionMember(oTarget, FALSE);
			while (GetIsObjectValid(oMember))
			{
				RemoveSEFFromObject(oMember, sVFX);
				oMember = GetNextFactionMember(oTarget,FALSE);			
			}		
		}
		else
		{
			RemoveSEFFromObject(oTarget, sVFX);
		}
	}
}

void ks_RemoveAllVisibilityEffects(object oTarget, int bForWholeFaction)
{
	if (GetIsObjectValid(oTarget))
	{
		if (bForWholeFaction)
		{
			object oMember = GetFirstFactionMember(oTarget, FALSE);
			while (GetIsObjectValid(oMember))
			{
				// list all of the possible effects here
				RemoveSEFFromObject(oMember, "total_invisibility");
				RemoveSEFFromObject(oMember, "ks_fx_ghostly_20");
				RemoveSEFFromObject(oMember, "ks_fx_ghostly_40");
				RemoveSEFFromObject(oMember, "ks_fx_ghostly_60");
				RemoveSEFFromObject(oMember, "ks_fx_ghostly_80");
				oMember = GetNextFactionMember(oTarget,FALSE);			
			}		
		}
		else
		{
			// list all of the possible effects here
			RemoveSEFFromObject(oTarget, "total_invisibility");
			RemoveSEFFromObject(oTarget, "ks_fx_ghostly_20");
			RemoveSEFFromObject(oTarget, "ks_fx_ghostly_40");
			RemoveSEFFromObject(oTarget, "ks_fx_ghostly_60");
			RemoveSEFFromObject(oTarget, "ks_fx_ghostly_80");
		}
	}
}

void ks_SetWeaponVisibility(object oTarget, int nVisible, int bForWholeFaction) // FALSE for force invisible, TRUE for force visible, 4 for remove override
{
	if (GetIsObjectValid(oTarget))
	{
		if (bForWholeFaction)
		{
			object oMember = GetFirstFactionMember(oTarget, FALSE);
			while (GetIsObjectValid(oMember))
			{
				SetWeaponVisibility(oMember, nVisible, 0);
				oMember = GetNextFactionMember(oTarget,FALSE);			
			}		
		}
		else
		{
			SetWeaponVisibility(oTarget, nVisible, 0);
		}
	}
}