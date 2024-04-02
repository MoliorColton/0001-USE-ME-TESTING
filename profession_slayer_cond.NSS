#include "_dc_strings"
int StartingConditional(int iCheck)
{
	object oPC = GetPCSpeaker();
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	
	if(iCheck == 1){
	 string sText;
	 switch (d3()){
	  case 1: sText = "I want you to kill"; break;
	  case 2: sText = "Go and eliminate"; break;
	  case 3: sText = "Move out and kill"; break;
	 }
	 int iCR;
	 if(GetTag(OBJECT_SELF) == "turael")
	  iCR = 4;
	 else if(GetTag(OBJECT_SELF) == "mazchna")
	  iCR = 6;
	 else if(GetTag(OBJECT_SELF) == "vannakaedge")
	  iCR = 10;
	 else if(GetTag(OBJECT_SELF) == "chaeldar")
	  iCR = 14;
	 else if(GetTag(OBJECT_SELF) == "sumona")
	  iCR = 20;
	 else if(GetTag(OBJECT_SELF) == "duradel")
	  iCR = 26;
	  
	 string sRows;
	 int iRows = GetNum2DARows("slayertasks");
	 int iSkillRank = GetSkillRank(44,oPC);
	  
		int i;
		for (i = 1; i <= iRows; i++)
		{
		  if(Get2DAString("slayertasks","CR",i) == IntToString(iCR) &&
			 iSkillRank >= StringToInt(Get2DAString("slayertasks","MinRank",i)))
		   sRows = DRKNth_Push(sRows,IntToString(i));
		}
		
		if(sRows != ""){
		 // Quests are available, pick one at random.
		 int iTask = StringToInt(DRKNth_GetRandomElement(sRows));
		 if(iTask == 0)
		  iTask = StringToInt(DRKNth_GetRandomElement(sRows));
		 if(iTask == 0)
		  iTask = StringToInt(DRKNth_GetRandomElement(sRows)); 
		 if(iTask == 0){
		  // Error
		  return FALSE;
		 }
		 if(iSkillRank < StringToInt(Get2DAString("slayertasks","MinRank",iTask)))
		 {
		  // new failsafe
		  return FALSE;
		 }
		 string sMonsterName = Get2DAString("slayertasks","Name",iTask);
		 int iMin = StringToInt(Get2DAString("slayertasks","KillsReqMin",iTask));
		 int iMax = StringToInt(Get2DAString("slayertasks","KillsReqMax",iTask));
		 int iTotal = iMin + Random((iMax - iMin)+1);
		 object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
		 sText += " ";
		 sText += IntToString(iTotal)+" "+sMonsterName+"(s).";
		 
		 SetCustomToken(2102, sText); 
		 
		 SetLocalInt(oESSENCE, "SLAYER_TOTAL", iTotal);
		 SetLocalInt(oESSENCE, "SLAYER_ROW", iTask);
		 
	  	 return TRUE;
		}
	}
	else if(iCheck == 2){
	 int iLVL;
	 int iSkill = GetSkillRank(44, oPC);
	 if(GetTag(OBJECT_SELF) == "turael")
	  return FALSE;
	 else if(GetTag(OBJECT_SELF) == "Mazchna")
	  iLVL = 20;
	 else if(GetTag(OBJECT_SELF) == "Vannaka")
	  iLVL = 35;
	 else if(GetTag(OBJECT_SELF) == "Chaeldar")
	  iLVL = 55;
	 else if(GetTag(OBJECT_SELF) == "Sumona")
	  iLVL = 75; // ?
	 else if(GetTag(OBJECT_SELF) == "duradel")
	  iLVL = 50; // ?
	  
	  if(iSkill < iLVL)
	   return TRUE;
	}
	else if(iCheck == 3){
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 if(iRow == 0)
	  return FALSE;
	  
	 string sMonsters = Get2DAString("slayertasks","Name",iRow);
	 
	 SetCustomToken(2103, sMonsters);
	 return TRUE;
	}
	else if(iCheck == 4){ 
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 int iCR = StringToInt(Get2DAString("slayertasks","CR",iRow));
	 int iGold;
	 switch(iCR){
	  case 4: iGold = 100; break;
	  case 6: iGold = 500; break;
	  case 10: iGold = 2500; break;
	  case 14: iGold = 7500; break;
	  case 20: iGold = 10000; break;
	  case 26: iGold = 50000; break;
	 }
	 
	 SetCustomToken(2104, IntToString(iGold));
	 return TRUE;
	}
	else if(iCheck == 5){ 
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 int iCR = StringToInt(Get2DAString("slayertasks","CR",iRow));
	 int iGold;
	 switch(iCR){
	  case 4: iGold = 100; break;
	  case 6: iGold = 500; break;
	  case 10: iGold = 2500; break;
	  case 14: iGold = 7500; break;
	  case 20: iGold = 10000; break;
	  case 26: iGold = 50000; break;
	 }
	 if(GetGold(oPC) >= iGold)
	  return TRUE;
	}
	else if(iCheck == 6){
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 if(iRow == 0){
	  SetCustomToken(2105, "You are currently not hunting anything.");
	 }
	 else {
	  string sMonsters = Get2DAString("slayertasks","Name",iRow);
	  int iKills = GetLocalInt(oESSENCE, "SLAYER_KILLS");
	  int iTotal = GetLocalInt(oESSENCE, "SLAYER_TOTAL");
	  string sText = "You are currently hunting the following: "+sMonsters;
	  sText += "You were tasked to slay "+IntToString(iTotal);
	  sText += ", you have eliminated "+IntToString(iKills);
	  sText += " so far. ";
	 
	  SetCustomToken(2105,sText);
	 }
	 return TRUE;
	}
	else if(iCheck == 7){
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 if(iRow == 0){
	  SetCustomToken(2106, "You are currently not hunting anything.");
	 }
	 else {
	  string sAreas = Get2DAString("slayertasks","Locations",iRow);
	  string sNames;
		int i;
		for (i = 1; i <= DRKNth_GetCount(sAreas); i++)
		{
		   sNames = DRKNth_Push(sNames,GetName(GetObjectByTag(DRKNth_GetNthElement(sAreas,i))));
		}
	 
	  SetCustomToken(2106, "Your current task can be found at: "+sNames);
	 }
	 return TRUE;
	}
	else if(iCheck == 8){
	 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
	 if(iRow == 0){
	  SetCustomToken(2107, "You are currently not hunting anything.");
	 }
	 else {
	  string sText = Get2DAString("slayertasks","InfoText",iRow);
	 
	  SetCustomToken(2107, "Words of wisdom for this task are: "+sText);
	 }
	 return TRUE;
	}
	else
	{	
		if (GetLocalInt(oESSENCE,"SLAYER_ROW") != 0) return TRUE;
	}
	
 return FALSE;
}