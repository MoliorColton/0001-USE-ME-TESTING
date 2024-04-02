// =============================================================
//
//    File: row_mod_heartbeat
//    Desc: Rowell's Module Heartbeat Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 12, 2006
// Updated: Nov 12, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnHeartbeat Event in the Module
//
// =============================================================

#include "row_inc_functions"


void main() {
  string sDateTime;
  string sSQL;
  object oPC;
  
  // THE TIME IS SAVED EVERY GAME HOUR, AND ONLY WHEN SQL DATABASE IS USED 
  sDateTime = GetStringLeft(GetGameTime(), 10);

  if (gDatabaseType == DATABASE_TYPE_NWNX && GetLocalInt(GetModule(), "DATABASE_IS_INIT") == 1) {
    if (sDateTime != GetLocalString(GetModule(), "THE_CURRENT_DATE_TIME")) {
	
	  // CHECK IF THE DAY IS NEW, AND IF SO, CHECK IF THE NEW DAY IS A HOLIDAY
	  if (GetStringLeft(GetLocalString(GetModule(), "THE_CURRENT_DATE_TIME"), 8) !=
	      GetStringLeft(sDateTime, 8)) {
		sSQL = DBReadString("Table_Calendar", "value", "month=" + IntToString(GetCalendarMonth()) + " AND day=" + IntToString(GetCalendarDay()));
		if (sSQL == "") {
		  DeleteLocalString(GetModule(), "THE_CURRENT_HOLIDAY");
		} else {
		  SetLocalString(GetModule(), "THE_CURRENT_HOLIDAY", sSQL);
		  oPC = GetFirstPC();
		  while (oPC != OBJECT_INVALID) {
		    SendMessageToPC(oPC, "Today is " + sSQL + ", a holiday to celebrate.");
			oPC = GetNextPC();
		  }
		}
	  }
	
	  // UPDATE THE DATE/TIME INTO THE DATABASE - UPDATED EVERY GAME HOUR
      sSQL = "SET " +
	  		 "Year="  + IntToString(GetCalendarYear()) + "," +
			 "Month=" + IntToString(GetCalendarMonth()) + "," +
			 "Day="   + IntToString(GetCalendarDay()) + "," +
			 "Hour="  + IntToString(GetTimeHour()) + "," +
			 "Min="   + IntToString(GetTimeMinute());
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Calendar " + sSQL + " WHERE Value='current_date'");
  
  	  SetLocalString(GetModule(), "THE_CURRENT_DATE_TIME", sDateTime);
	  
	}
	
  }

  
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================
  
	  
}