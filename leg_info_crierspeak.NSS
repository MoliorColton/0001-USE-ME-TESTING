/*

    Script:			This script is called by the master heartbeat script when the Info plugin is
					active.  It is used on Town Criers to announce any messages that may be waiting
					in their Placeable Message Queue object.  Messages are placed in the queue by
					the leg_info_crieradd script.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		12/21/2010 - 1.00 MV - Initial Release
					09/18/2012 - 1.1 MV - Added support to disable Hear Ye Hear Ye Message
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Hi my name is...my name is... my name is...
	int iCurrentTime = LEG_COMMON_TimeStamp();
	int iLastTime = GetLocalInt(OBJECT_SELF, "LastTime");
	string sCrierPostTag = GetLocalString(OBJECT_SELF, "LEG_INFO_CrierPostTag");
	int iNoHearYe = GetLocalInt(OBJECT_SELF, "LEG_INFO_DisableHearYe");
	if (sCrierPostTag == "")
		return;
	
	// We only want 1 annoucment per minute
	if (iCurrentTime >= iLastTime + REAL_MINUTES)
	{
		// Find my Crier Post
		object oCrierPost = GetObjectByTag(sCrierPostTag);
		
		// See if there are any messages in my queue
		string sText1 = LEG_COMMON_GetFirstArrayElement(oCrierPost, "LEG_CRIER_LINE1");
		string sText2;
		int iSpeakCount;
		
		// If I have a line 1, then I have something to say.
		if (sText1 != "#EOA#")
		{
			iSpeakCount = GetLocalInt(oCrierPost, "LEG_CRIER_CURRENTSPEAKCOUNT");
			sText2 = LEG_COMMON_GetFirstArrayElement(oCrierPost, "LEG_CRIER_LINE2");
			if (!iNoHearYe)
			{
				SpeakString("Hear ye, hear ye!");
			}
			DelayCommand(5.0, SpeakString(sText1));
			DelayCommand(10.0, SpeakString(sText2));
			iSpeakCount++;
			
			// If we've spoke this enough, then reset the speak count and remove the entry
			// from the array.
			if (iSpeakCount >= CRIERCOUNT)
			{
				SetLocalInt(oCrierPost, "LEG_CRIER_CURRENTSPEAKCOUNT", 0);
				LEG_COMMON_DeleteCurrentArrayElement(oCrierPost, "LEG_CRIER_LINE1");
				LEG_COMMON_DeleteCurrentArrayElement(oCrierPost, "LEG_CRIER_LINE2");
			}
			else
				SetLocalInt(oCrierPost, "LEG_CRIER_CURRENTSPEAKCOUNT", iSpeakCount);
		}
		
		SetLocalInt(OBJECT_SELF, "LastTime", iCurrentTime);
	}
}