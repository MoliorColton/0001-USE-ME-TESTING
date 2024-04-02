#include "INC_GUI_BOSSBAR"

void main()
{
	object oObject = GetLocalObject(OBJECT_SELF, "SCREEN_SHOP_TARGET");
	float fPos = 2.5;
	
	string sVariable = GetLocalString(OBJECT_SELF, GUI_BOSSBAR_VARNAME_FLOAT);
	if(sVariable != "")
	{
		fPos = GetLocalFloat(oObject, sVariable);
	}
	else
	{
		int nMaxHP = GetMaxHitPoints(oObject);
		if(GetIsObjectValid(oObject) && nMaxHP != 0)
		{
			fPos = IntToFloat(GetCurrentHitPoints(oObject)) /
								IntToFloat(nMaxHP);
		}
	}
	
	SetGUIProgressBarPosition(OBJECT_SELF, "SCREEN_SHOP", "SHOP_HEALTHBAR", fPos);
}