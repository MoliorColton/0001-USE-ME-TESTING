// =============================================================
//
//    File: row_inc_database
//    Desc: Rowell's Database Include File
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Feb 02, 2007
// Version: 1.0.4
//
//   Usage: Contains all the Database Usage functions
//
// =============================================================

#include "nwnx_sql"
#include "nwnx_include"
#include "nwnx_clock"
#include "row_inc_settings"



// GLOBAL FUNCTIONS
// =============================================================

// GetArrayCount(string strArray)
//   Given a String delimited by pipes ("|"), will determine how many seperate entities there are
//   in the "array".
int    GetArrayCount(string strArray);

// GetArrayString(string strArray, int iNum)
//   Given the index inside an array, returns the string value.
//   Example:  GetString(arrUserList, 2)  will return the 2nd user in the array
string GetArrayString(string strArray, int iNum);


// GetArrayString(string strArray, int iNum)
//   Given the index inside an array, returns the integer value.
//   Example:  GetString(arrPlayerLevels, 5)  will return the 5th Player Level in the array
int    GetArrayInt(   string strArray, int iNum);

// DBOpen(string sSQL)
//   Issues a SQL Command to the SQL Database (calls SQLExecDirect(sSQL) )
//   Example: DBOpen("SELECT CharName FROM Table_Character");
void   DBOpen(string sSQL);

// DBTableExists(string strTable, string strAdd, object oPC=OBJECT_INVALID)
//   Checks the Database to see if strTable exists.
//   If the table does not exist, the SQL Command in strAdd is issued to create it
//   using only the field list and definitions.
//   Example: DBTableExists("Table_Test", "TestID int,TestName varchar(10)");
int    DBTableExists( string strTable, string strAdd, object oPC=OBJECT_INVALID);

// DBRecordExists(string strTable, string strCriteria, object oPC=OBJECT_INVALID)
//   Checks strTable to see if the record defined in strCriteria exists.
//   Example: blnCharFound = DBRecordExists("Table_Character", "CharacterID=200");
int    DBRecordExists(string strTable, string strCriteria, object oPC=OBJECT_INVALID);

// DBReadString(string strTable, string strField, string strCriteria, object oPC=OBJECT_INVALID)
//   Searches strTable using the SQL Search defined in strCriteria, and returns strField as a String.
//   Example:  strCharName = DBReadString("Table_Character", "CharName", "CharacterID=152");
string DBReadString(  string strTable, string strField,  string strCriteria, object oPC=OBJECT_INVALID);


// DBReadString(string strTable, string strField, string strCriteria, object oPC=OBJECT_INVALID)
//   Searches strTable using the SQL Search defined in strCriteria, and returns strField as an Integer.
//   Example:  intCharLevel = DBReadInt("Table_Character", "Level", "CharacterID=152");
int    DBReadInt(     string strTable, string strField,  string strCriteria, object oPC=OBJECT_INVALID);

// DBUpdateString(string strTable, string strField, string strValue, string strCriteria, object oPC=OBJECT_INVALID)
//   Updates strField in the table strTable with the string value strValue, given the SQL Criteria in strCriteria.
//   Example: DBUpdateString("Table_Character", "CharName", "Bob", "CharacterID=200");
void   DBUpdateString(string strTable, string strField,  string strValue,    string strCriteria, object oPC=OBJECT_INVALID);

// DBUpdateInt(string strTable, string strField, int iValue, string strCriteria, object oPC=OBJECT_INVALID)
//   Updates strField in the table strTable with the integer value strValue, given the SQL Criteria in strCriteria.
//   Example: DBUpdateInt("Table_Character", "XP", 1000, "CharacterID=200");
void   DBUpdateInt(   string strTable, string strField,  int    iValue,      string strCriteria, object oPC=OBJECT_INVALID);

// DBDeleteRecord(string strTable, string strCriteria, object oPC=OBJECT_INVALID)
//   Deletes any records in table strTable based on the SQL Criteria in strCriteria.  Returns result of True/False based on success
//   Example: DBDeleteRecord("Table_Character", "CharacterID>200 AND CharName='Bob'");
int    DBDeleteRecord(string strTable, string strCriteria, object oPC=OBJECT_INVALID);

// DBAddRecord(string strTable, string strFields, string strValues, string strKey, string strCriteria, object oPC=OBJECT_INVALID)
//   Adds a new record in the table strTable.  The fields in strFields will be populated by data in strValues.
//   If a strKey is supplied, then the new record ID is returned from this function, otherwise a search will be performed
//   using the SQL Criteria in strCriteria to return the new record ID.
//   Example: DBAddRecord("Table_Character", "CharName,XP,GP,Level,Race", "'Bob',100,150,1,'Human'", "CharacterID", "CharName='Bob'")
int    DBAddRecord(   string strTable, string strFields, string strValues, string strKey="", string strCriteria="", object oPC=OBJECT_INVALID);

// DBSQLCmd(string sSQL)
//   Used to issue any SQL Commands not listed above, or to perform complex SQL Statements/commands.
void   DBSQLCmd( string sSQL);

// SQLEncode(string sSQL)
//   Converts and returns sString into a SQL-Friendly format, changing the Apostrophe (')  into an Accent (`)
string SQLEncode(string sString);

// SQLDecode(string sSQL)
//   Converts and returns sString from a SQL-Friendly format, changing the Accent (`) into an Apostrophe (')
string SQLDecode(string sString);

// ReplaceString(string theString, string strFind, string strReplace)
//   Searchs through theString for any occurrences of strFind, and replaces them with strReplace
string ReplaceString(string theString, string strFind, string strReplace);

// GetSystemDateTime()
//   Returns the currect System Date and Time.
string GetSystemDateTime();

// DBAddError(string strError)
//   This is a Temporary function, used because the NWN command WriteTimeStampedLogEntry() is not working.
//   Adds strError to the Error Table in the database, to help in debugging and notification.
void   DBAddError(string strError);

// =============================================================


string SQLEncode(string sString) {
  return SQLEncodeSpecialChars(sString);
}

string SQLDecode(string sString) {
  return sString;
}

string ReplaceString(string theString, string strFind, string strReplace) {
  string st = theString;
  int    i  = 0;
	
  i = FindSubString(GetStringLowerCase(theString), GetStringLowerCase(strFind));
  while (i > 0) {
	st = GetStringLeft(theString, i);
	st = st + strReplace;
	st = st + GetStringRight(theString, GetStringLength(theString) - (i + GetStringLength(strFind)));
	i = FindSubString(GetStringLowerCase(theString), GetStringLowerCase(strFind));
  }	
  return st;	
}

string GetSystemDateTime() {
  string st = ( GetSystemDate() + " " + GetSystemTime() );
  return st;
}

// =============================================================
// COUNT THE NUMBER OF MEMBERS IN AN ARRAY
// =============================================================
int GetArrayCount(string strArray) {
  string sTemp = strArray;
  int    i     = 0;
  int    c     = 0;
  
  c = FindSubString(sTemp, "|") + 1;
  if (c > 0) {
    while (sTemp != "" && i < 100) {
	  if (c == GetStringLength(sTemp))
	  	sTemp = "";
	  else {
	    sTemp = GetStringRight(sTemp, GetStringLength(sTemp)-c);
		if (GetStringLeft(sTemp, 1) == "|")
		  if (GetStringLength(sTemp) == 1)
		  	sTemp = "";
		  else
		    sTemp = GetStringRight(sTemp, GetStringLength(sTemp) - 1);
	  }
	  i++;
	  c = FindSubString(sTemp, "|") + 1;	
	}
  } else {
    return 1;
  }
  
  return i;
  
}

// =============================================================
// PULL A STRING OUT OF AN ARRAY
// =============================================================
string GetArrayString(string strArray, int iNum) {
  string s = strArray;
  string t;
  int    i = 1;
  int    c;
  
  c = FindSubString(s, "|") + 1;
  if (c > 0) {
    while (GetStringLength(s) > 0) {
	  if (c == GetStringLength(s)) {
	  	t = GetStringLeft(s, GetStringLength(s)-1);
		s = "";
		
		if (i == iNum) 
		  return t;
		else 
		  return "";
		  
	  } else {
  	    t = GetStringLeft(s, c-1);
	    s = GetStringRight(s, GetStringLength(s)-c);
		
	    if (i == iNum) 
		  return t; 
	  }
	  i++;
	  c = FindSubString(s, "|") + 1;	
	}
	return "";
  } else {
    return s;
  }

  return "";
  
}


// =============================================================
// PULL AN INTEGER OUT OF AN ARRAY
// =============================================================
int GetArrayInt(string strArray, int iNum) {
  string t;
  string s = strArray;
  int    i = 1;
  int    c = 0;
  
  c = FindSubString(s, "|") + 1;
  if (c > 0) {
    while (GetStringLength(s) > 0) {
	
	  if (c == GetStringLength(s)) {
	  	t = GetStringLeft(s, GetStringLength(s)-1);
		s = "";
		
		if (i == iNum) 
		  return StringToInt(t);
		else 
		  return 0;
	  } else {
	    t = GetStringLeft(s, c-1);
	    strArray = GetStringRight(s, GetStringLength(s)-c);
	    if (i == iNum) 
		  return StringToInt(t);
	  }
	  i++;
	  c = FindSubString(s, "|") + 1;	
	}
	return 0;
  } else {
    return StringToInt(s);
  }

  return 0;
  
}


// =============================================================
// OPEN A SQL READ COMMAND (BUT DON'T ACTUALLY READ)
// =============================================================
void DBOpen(string sSQL) {
  
  if (gDatabaseType == DATABASE_TYPE_NWNX) {
    SQLExecDirect(sSQL);
  }

  // After calling this command, follow up with the following example:
  //   while (SQLFetch() == SQL_SUCCESS) {
  //     s1 = SQLDecode(SQLGetData(1));
  //     s2 = SQLDecode(SQLGetData(2));
  //     i3 = StringToInt(SQLGetData(3));
  //     ...
  //   }
	
}


// =============================================================
// CHECK IF A TABLE EXISTS IN THE DATABASE
// =============================================================
int DBTableExists(string strTable, string strAdd, object oPC=OBJECT_INVALID) {
  string sSQL;
  int    iCountExists   = FALSE;
  int    bTableNotFound = FALSE;
  
  if (gDatabaseType < DATABASE_TYPE_NWNX)
    return TRUE;
	
  // CHECK TABLE FOR POSITIVE ID
  strTable = gTable_Prefix + strTable;
  if (GetLocalString(GetModule(), strTable) == "Y") 
    return TRUE;	

  // CHECK IF THE TABLE EXISTS AND HAS RECORDS
  sSQL = "SELECT COUNT(*) FROM " + strTable;
  if (iNWNdebug)
  	DBAddError("DBTableExists(" + strTable + "): ");
  SQLExecDirect(sSQL);
  
  // IF THE TABLE DOES NOT EXIST, OR THERE ARE NO RECORDS IN IT
  // RE-MAKE THE TABLE
  if (SQLFetch() == SQL_SUCCESS) {
    // DO NOTHING
	if (iNWNdebug)
	  DBAddError("Table Exists");
  } else {
    bTableNotFound = TRUE;
	DBAddError("Table DOES NOT Exist");
  }
  
  // DO THE TABLE RE-MAKE HERE
  if (bTableNotFound == TRUE) {
    // CREATE A NEW TABLE
	sSQL = "CREATE TABLE `" + strTable + "` (" + strAdd + ")";
	if (gDatabaseFormat == DATABASE_FORMAT_MYSQL) 
  		sSQL = sSQL + " ENGINE=MyISAM DEFAULT CHARSET=latin1";

    SQLExecDirect("DROP TABLE " + strTable);
    SQLExecDirect(sSQL);

	DBAddError("CREATE Table with: " + sSQL);

	// CREATE ENTRY IN THE RECORD COUNTER TABLE
	if (strTable != gTable_Prefix + "Table_Count") {
	  if (DBRecordExists("Table_Count", "TableName='" + strTable + "'") == FALSE) {
		sSQL = "INSERT INTO " + gTable_Prefix + "Table_Count (TableName,TableCount) VALUES ('" + strTable + "',0)";
   		SQLExecDirect(sSQL);
	  }
	}
	
  } else {
	if (DBRecordExists("Table_Count", "TableName='" + strTable + "'") == FALSE) {
		sSQL = "INSERT INTO " + gTable_Prefix + "Table_Count (TableName,TableCount) VALUES ('" + strTable + "',0)";
   		SQLExecDirect(sSQL);
	}
  }
  
  SetLocalString(GetModule(), strTable, "Y");
  
  return (bTableNotFound == FALSE);

}


// =============================================================
// CHECK IF A RECORD EXISTS IN THE DATABASE
// =============================================================
int DBRecordExists(string strTable, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
    
  strTable = gTable_Prefix + strTable;
  
  if (gDatabaseType < DATABASE_TYPE_NWNX) {
  	return TRUE;
  } else {
  	// NWNX2 SQL DATABASE
	sSQL = "SELECT * FROM " + strTable + " WHERE " + strCriteria;
    SQLExecDirect(sSQL);
	if (SQLFetch() == SQL_SUCCESS) {
	  return TRUE;
	} 
  }
  
  return FALSE;
  
}  
  
  
// =============================================================
// READ THE RECORD COUNT FOR THE TABLE FROM THE DATABASE
// =============================================================
int DBGetNextRecordID(string strTable) {
	int iNum;
	string sSQL;
	
	strTable = gTable_Prefix + strTable;
	sSQL = "SELECT TableCount FROM Table_Count WHERE TableName='" + strTable + "'";
    SQLExecDirect(sSQL);
	if (SQLFetch() == SQL_SUCCESS) {
	  iNum = StringToInt(SQLGetData(1));
	  iNum++;
	  sSQL = "UPDATE Table_Count SET TableCount=" + IntToString(iNum) + " WHERE TableName='" + strTable + "'";
	  SQLExecDirect(sSQL);
	} else {
	  iNum = 1;
	  sSQL = "INSERT INTO Table_Count (TableName,TableCount) VALUES ('" + strTable + "',1)";
   	  SQLExecDirect(sSQL);
	}
	
	return iNum;
		
} 
	

// =============================================================
// READ A STRING FROM THE DATABASE
// (can handle muliple-fields, stored in a String Array)
// =============================================================
string DBReadString(string strTable, string strField, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
  string sText     = "";
  int    iAreMulti = (FindSubString(strField, ",") > 0);
  int    iFieldCnt = 1;
  int	 i;
  
  // IF THERE ARE MULTIPLE FIELDS, COUNT HOW MANY
  if (iAreMulti == TRUE) {
	sText = strField;
	iFieldCnt = 0;
	while (sText != "") {
		iFieldCnt++;
		i = FindSubString(sText, ",")+1;
		if (i > 0)
			sText = GetStringRight(sText, GetStringLength(sText) - i);
		else
			sText = "";
	}
  }
  
  i = 1;
  strTable = gTable_Prefix + strTable;

  if (gDatabaseType == DATABASE_TYPE_NONE) { 
  	if (oPC != OBJECT_INVALID)
	  return SQLDecode(GetLocalString(oPC, strTable+strField)); 
	else
	  return SQLDecode(GetLocalString(GetModule(), strTable+strField+strCriteria));
  }
  
  if (gDatabaseType == DATABASE_TYPE_NWN) {
  	// BUILT-IN NWN DATABASE
	if (iAreMulti == FALSE) {
	  if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
	  sText = GetCampaignString(strTable, strField, oPC);
	}
  } else {
  	// NWNX2 SQL DATABASE
    sSQL = "SELECT " + strField + " FROM " + strTable + " WHERE " + strCriteria;
    SQLExecDirect(sSQL);
	sText = "";
	if (iAreMulti == TRUE) {
	  while (SQLFetch() == SQL_SUCCESS) {
	    for (i=1;i<=iFieldCnt;i++) {
			sText = sText + SQLGetData(i) + "/";
	    }
		sText = GetStringLeft(sText, GetStringLength(sText) - 1);
		sText = sText + "|";
	  } 
	} else {
	  while (SQLFetch() == SQL_SUCCESS) { 
	  	sText = SQLGetData(1) + "|"; 
	  }	
	}
	
	if (GetStringRight(sText, 1) == "|")
		sText = GetStringLeft(sText, GetStringLength(sText)-1);
				
  }
  
  return SQLDecode(sText);
  
}


// =============================================================
// READ AN INTEGER FROM THE DATABASE
// =============================================================
int DBReadInt(string strTable, string strField, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
  int    iAreMulti = (FindSubString(strField, ",") > 0);
  int    iNum = 0;
  
  strTable = gTable_Prefix + strTable;

  if (iAreMulti == TRUE)  { return 0; }
  if (gDatabaseType == DATABASE_TYPE_NONE) {
  	if (oPC != OBJECT_INVALID)
	  return GetLocalInt(oPC, strTable+strField); 
	else
	  return GetLocalInt(GetModule(), strTable+strField+strCriteria);
  }
  
  if (gDatabaseType == DATABASE_TYPE_NWN) {
  	// BUILT-IN NWN DATABASE
    if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
	iNum = GetCampaignInt(strTable, strField, oPC); 
  } else {
  	// NWNX2 SQL DATABASE
    sSQL = "SELECT " + strField + " FROM " + strTable;
	if (strCriteria != "")
	  sSQL = sSQL + " WHERE " + strCriteria;
	if (iNWNdebug) WriteTimestampedLogEntry("DBReadInt IN: " + sSQL);
    SQLExecDirect(sSQL);
	if (SQLFetch() == SQL_SUCCESS) { iNum = StringToInt(SQLGetData(1)); }	
  }
  
  if (iNWNdebug) WriteTimestampedLogEntry("DBReadInt OUT: " + IntToString(iNum));

  return iNum;
}


// =============================================================
// UPDATE A STRING FIELD IN THE DATABASE
// =============================================================
void DBUpdateString(string strTable, string strField, string strValue, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
  
  strTable = gTable_Prefix + strTable;
  if (strValue != gDateTimeNow)
	strValue = SQLEncode(strValue);

  if (gDatabaseType == DATABASE_TYPE_NONE) {
  	if (oPC != OBJECT_INVALID)
	  SetLocalString(oPC, strTable+strField, strValue); 
	else
	  SetLocalString(GetModule(), strTable+strField+strCriteria, strValue);
    return;
  }
  
  if (gDatabaseType == DATABASE_TYPE_NWN) {
  	// BUILT-IN NWN DATABASE
    if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
	SetCampaignString(strTable, strField, strValue, oPC);
  } else {
  	// NWNX2 SQL DATABASE
	if (strValue == gDateTimeNow)
  	  sSQL = "UPDATE " + strTable + " SET " + strField + "=" + strValue + " WHERE " + strCriteria;
	else
  	  sSQL = "UPDATE " + strTable + " SET " + strField + "='" + strValue + "' WHERE " + strCriteria;
	if (iNWNdebug) WriteTimestampedLogEntry("DBUpdateString: " + sSQL);
    SQLExecDirect(sSQL);	
  }
  
}


// =============================================================
// UPDATE AN INTEGER FIELD IN THE DATABASE
// =============================================================
void DBUpdateInt(string strTable, string strField, int iValue, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
  
  strTable = gTable_Prefix + strTable;

  if (gDatabaseType == DATABASE_TYPE_NONE) {
  	if (oPC != OBJECT_INVALID)
	  SetLocalInt(oPC, strTable+strField, iValue); 
	else
	  SetLocalInt(GetModule(), strTable+strField+strCriteria, iValue);
    return;
  }
  
  if (gDatabaseType == DATABASE_TYPE_NWN) {
  	// BUILT-IN NWN DATABASE
    if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
	SetCampaignInt(strTable, strField, iValue, oPC);
  } else {
  	// NWNX2 SQL DATABASE
  	sSQL = "UPDATE " + strTable + " SET " + strField + "=" + IntToString(iValue) + " WHERE " + strCriteria;
	if (iNWNdebug) WriteTimestampedLogEntry("DBUpdateInt: " + sSQL);
    SQLExecDirect(sSQL);	
  }

}


// =============================================================
// DELETE A RECORD FROM THE DATABASE
// =============================================================
int DBDeleteRecord(string strTable, string strCriteria, object oPC=OBJECT_INVALID) {
  string sSQL;
  int    iSuccess = FALSE;
  
  strTable = gTable_Prefix + strTable;

  if (gDatabaseType == DATABASE_TYPE_NONE) { return 0; }
  
  if (gDatabaseType == DATABASE_TYPE_NWN) {
  	// BUILT-IN NWN DATABASE
    if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
	DeleteCampaignVariable(strTable, strCriteria, oPC);
	iSuccess = TRUE;
  } else {
  	// NWNX2 SQL DATABASE
    sSQL = "DELETE FROM " + strTable + " WHERE " + strCriteria;
	if (iNWNdebug) WriteTimestampedLogEntry("DBDeleteRecord: " + sSQL);	
    SQLExecDirect(sSQL);	
	iSuccess = TRUE;
  }

  return iSuccess;

}


// =============================================================
// ADD A RECORD TO THE DATABASE
// This Function only works with SQL/NWNX2 Database.
// For Adding Records/Fields to the NWN Database, use the:
//   DBUpdateString() and DBUpdateInt() functions.
// =============================================================
int DBAddRecord(string strTable, string strFields, string strValues, string strKey="", string strCriteria="", object oPC=OBJECT_INVALID) {
  string sSQL;
  int    iSuccess  = FALSE;
  int    iAreMulti = (FindSubString(strFields, ",") > 0);
  int    iNum;
  
  strTable = gTable_Prefix + strTable;

  if (gDatabaseType == DATABASE_TYPE_NONE) { return FALSE; }
  
  if (gDatabaseType == DATABASE_TYPE_NWN && iAreMulti == FALSE) { 
    if (oPC == OBJECT_INVALID) { oPC = GetModule(); }
    DBUpdateString(strTable, strFields, strValues, strCriteria, oPC);
	iSuccess = TRUE;
  }
  
  if (gDatabaseType == DATABASE_TYPE_NWNX) {
    if (strKey != "") {
		iNum = DBGetNextRecordID(strTable);
		strFields = strKey + "," + strFields;
		strValues = IntToString(iNum) + "," + strValues;
	} else
		iNum = 0;
  	sSQL = "INSERT INTO " + strTable + "(" + strFields + ") VALUES (" + strValues + ")";
	if (iNWNdebug) WriteTimestampedLogEntry("DBAddRecord: " + sSQL);
    SQLExecDirect(sSQL);	
	iSuccess = iNum;
  }

  if (strCriteria != "" && strKey != "") {
    iSuccess = DBReadInt(strTable, strKey, strCriteria, oPC);
  }
  
  return iSuccess;

} 


// =============================================================
// PERFORM OTHER SQL COMMAND
// This Function only works with SQL/NWNX2 Database.
// =============================================================
void DBSQLCmd(string sSQL) {
  
  if (gDatabaseType == DATABASE_TYPE_NWNX) {
	if (iNWNdebug) WriteTimestampedLogEntry("DBSQLCmd: " + sSQL);
    SQLExecDirect(sSQL);	
  }

} 


void DBAddError(string strError) {

  	WriteTimestampedLogEntry(strError);
	
	strError = SQLEncode(strError);
	strError = GetStringLeft(strError, 300);
	DBAddRecord("Table_Error", "ErrorDesc,ErrorDate", "'"+strError+"'," + gDateTimeNow, "ErrorID");

}