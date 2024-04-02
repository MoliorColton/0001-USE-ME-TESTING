// =============================================================
//
//    File: row_web_interface
//    Desc: Rowell's Web Interface, for the Web Security Officer
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 05, 2006
// Updated: Oct 05, 2006
// Version: 1.0.0
//
// =============================================================


void main() {
  object oNPC   = OBJECT_SELF;
  object oPC    = GetLastSpeaker();
  string strKey = GetPCPublicCDKey(oPC);
  string strSpeak;
  
  // MAKE SURE THAT BOTH PARTIES TALKING ARE VALID OBJECTS
  if (oPC == OBJECT_INVALID || oNPC == OBJECT_INVALID || !GetIsPC(oPC)) 
    return;

  // FORCE PUBLIC CD KEY TO DISPLAY  
  SetLocalString(oPC, "TEMP", GetPCPublicCDKey(oPC));
  strKey = GetLocalString(oPC, "TEMP");
  DeleteLocalString(oPC, "TEMP");
  
  // TELL THE PLAYER HIS/HER NWN2 USERNAME	
  strSpeak = "[ Your NWN2 Web Username is: " + GetPCPlayerName(oPC) + " ]";
  SendMessageToPC(oPC, strSpeak);
  
  // TELL THE PLAYER HIS/HER NWN2 PASSWORD
  strSpeak = "[ Your NWN2 Web Password is: " + strKey + " ]";
  SendMessageToPC(oPC, strSpeak);

  // WARN THE PLAYER NOT TO SHARE THIS INFORMATION WITH ANYONE
  strSpeak = "[ DO NOT share this information with anyone. ]";
  SendMessageToPC(oPC, strSpeak);

}