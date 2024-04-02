//****************************************************************
//******************START MAIN SCRIPT******************************
void main(int iFaction, int iRadius)
	{
	object oTarget		= GetItemActivatedTarget();
	float fRadius		= IntToFloat(iRadius);
	string sFaction		= "hm_fr_"+IntToString(iFaction);
	object oSource		= GetObjectByTag(sFaction);
	effect eMark		= EffectVisualEffect(VFX_IMP_ACID_L, FALSE);
	location lLoc		= GetLocation(oTarget);
	object oArea		= GetArea(oTarget);
	
	if (fRadius == 0.0)
		{
		ChangeFaction(oTarget, oSource);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eMark, oTarget);
		return;
		}
	else if (fRadius >= 1.0 && fRadius <= 99.0)
		{
		oTarget		= GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oTarget))
			{
			ChangeFaction(oTarget, oSource);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eMark, oTarget);
			oTarget	=  GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
			}
		}
	else if (fRadius == 100.0)
		{
		oTarget		= GetFirstObjectInArea(oArea);
		while (GetIsObjectValid(oTarget))
			{
			if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
				{
				ChangeFaction(oTarget, oSource);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eMark, oTarget);
				}
			oTarget	=  GetNextObjectInArea(oArea);
			}
		}
	}	