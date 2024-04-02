#include "x0_i0_spells"
#include "profession_include"
#include "gui_prof_prayer"

void main(object oPC, int nPRAYER, int nFAMILY)
{
	object oPC = OBJECT_SELF;
		
		{
			DisplayGuiScreen(oPC, "GUIDECOOKING1", TRUE,"guidecooking.xml");
		}
	}
	if (nPOINTS < nCOST)
		CloseGUIScreen(oPC, "GUIDECOOKING1", TRUE,"guidecooking.xml");
	}
}