// =============================================================
//
//    File: row_inc_banking
//    Desc: Rowell's Banking System
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 14, 2006
// Updated: Jan 18, 2007
// Version: 1.0.3
//
// =============================================================

#include "row_inc_functions"


// =============================================================
// GLOBAL FUNCTIONS
// =============================================================

// RBS_InitCharacter(object oPC)
//   This script is called at the beginning of the Banker Conversation.
//   Initializes the Character with the Banking System.
void RBS_InitCharacter(object oPC);

// RBS_GetSavedGold(object oPC)
//   Returns the amount of gold that oPC has in the Savings Bank.
int  RBS_GetSavedGold(object oPC);

// RBS_GetLoanGold(object oPC)
//   Returns the amount of gold that oPC has Borrowed from the Bank.
int  RBS_GetLoanGold(object oPC);

// RBS_Deposit(int iAmount, object oPC=OBJECT_INVALID)
//   This script takes gold from the character and puts it into the bank.
//   See row_inc_settings toset the Maximum Amount a character can store in the bank.
void RBS_Deposit(int iAmount, object oPC=OBJECT_INVALID);

// RBS_Withdraw(int iAmount, object oPC=OBJECT_INVALID)
//   This script takes gold from the bank and gives it to the character.
void RBS_Withdraw(int iAmount, object oPC=OBJECT_INVALID);

// RBS_Borrow(int iAmount, object oPC=OBJECT_INVALID)
//   This script gives gold to the character and increases the loan.
//   See row_inc_settings toset the Maximum Amount a character can borrow from the bank.
void RBS_Borrow(int iAmount, object oPC=OBJECT_INVALID);

// RBS_Repay(int iAmount, object oPC=OBJECT_INVALID)
//   This script takes gold from the character and repays it toward the loan.
//   See row_inc_settings toset the Maximum Amount a character can borrow from the bank.
void RBS_Repay(int iAmount, object oPC=OBJECT_INVALID);

// RBS_SavingsInterest(object oPC)
//   Calculates and adds interest to oPC Saved Gold in the Bank.
//   Minimum amount to earn interest is 500gp.
//   Interest is calculated monthly.
void RBS_SavingsInterest(object oPC);

// RBS_LoanInterest(object oPC)
//   Calculates and adds interest to oPC Loan in the Bank.
//   Interest is calculated monthly.
void RBS_LoanInterest(object oPC);

// =============================================================


string GetBankTag(object oPC) {
  string sTag;
  
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return "invalid";
	  
  // GET LOCAL VARIABLE FIRST
  if (GetLocalString(oPC, "RBS_BANK_ID") != "")
    return GetLocalString(oPC, "RBS_BANK_ID");
	
  // SET LOCAL VARIABLE TO THE SPEAKING NPC OBJECT
  sTag = GetTag(OBJECT_SELF);
  
  // IF THERE IS NO VALID TAG, USE A DEFAULT
  if (sTag == "")
  	sTag = "default";

  // SET THE LOCAL VARIABLE
  SetLocalString(oPC, "RBS_BANK_ID", sTag);

  return sTag;

}


void RBS_InitCharacter(object oPC) {
  string sBankID = GetBankTag(oPC);
  int    iCID;
  int    iGoldInBank;
  int    iGoldOnLoan;
  
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // ABORT IF THE CHARACTER IS ALREADY INITIALIZED
  if (GetLocalInt(oPC, "RBS_INIT") > 0) {
    SetCustomToken(101, IntToString(GetLocalInt(oPC, "RBS_SAVE_GOLD")));
    SetCustomToken(102, IntToString(GetLocalInt(oPC, "RBS_LOAN_GOLD")));
    SetCustomToken(103, IntToString(iRBS_MaxDeposit - GetLocalInt(oPC, "RBS_SAVE_GOLD")));
    SetCustomToken(104, IntToString((iRBS_MaxLoan * GetLevel(oPC)) - GetLocalInt(oPC, "RBS_LOAN_GOLD")));
  	return;
  }
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  iGoldInBank = DBReadInt("Table_Bank", "SaveGP", "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  iGoldOnLoan = DBReadInt("Table_Bank", "LoanGP", "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // STORE INFORMATION ON THE CHARACTER
  SetLocalInt(oPC, "RBS_SAVE_GOLD", iGoldInBank);
  SetLocalInt(oPC, "RBS_LOAN_GOLD", iGoldOnLoan);
  SetCustomToken(101, IntToString(iGoldInBank));
  SetCustomToken(102, IntToString(iGoldOnLoan));
  SetCustomToken(103, IntToString(iRBS_MaxDeposit - iGoldInBank));
  SetCustomToken(104, IntToString((iRBS_MaxLoan * GetLevel(oPC)) - iGoldOnLoan));
  SetLocalInt(oPC, "RBS_INIT", 1);
  
}

int RBS_GetSavedGold(object oPC) {
  int iGoldInBank;
  
  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  if (GetLocalInt(oPC, "RBS_INIT") == 0)
  	RBS_InitCharacter(oPC);
  
  iGoldInBank = GetLocalInt(oPC, "RBS_SAVE_GOLD");

  SetCustomToken(101, IntToString(iGoldInBank));
  SetCustomToken(103, IntToString(iRBS_MaxDeposit - iGoldInBank));

  return iGoldInBank;
  
}


int RBS_GetLoanGold(object oPC) {
  int iGoldOnLoan;
  
  // FIND OUT HOW MUCH THE CHARACTER HAS ON LOAN
  if (GetLocalInt(oPC, "RBS_INIT") == 0)
  	RBS_InitCharacter(oPC);

  iGoldOnLoan = GetLocalInt(oPC, "RBS_LOAN_GOLD");

  SetCustomToken(102, IntToString(iGoldOnLoan));
  SetCustomToken(104, IntToString((iRBS_MaxLoan * GetLevel(oPC)) - iGoldOnLoan));
    
  return iGoldOnLoan;
  
}


void RBS_Deposit(int iAmount, object oPC=OBJECT_INVALID) {
	string sBankID;
	int    iCID;
	int    iGoldOnHand;
	int    iGoldInBank;

  // GATHER THE DEPOSITING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastSpeaker();
	
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET THE BANK TAG
  sBankID = GetBankTag(oPC);
  
  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  iGoldInBank = RBS_GetSavedGold(oPC);
    
  // MAKE SURE DEPOSIT VALUE IS CORRECT
  iGoldOnHand = GetGold(oPC);
  if (iAmount > iGoldOnHand)
  	iAmount = iGoldOnHand;
  if (iGoldInBank + iAmount > iRBS_MaxDeposit)
  	iAmount = iRBS_MaxDeposit - iGoldInBank;
	
  // IF THE BANK IS EMPTY (NEW ACCOUNT), SET THE INTEREST RATE START DATE TO TODAY (GAME TIME)
  if (iGoldInBank == 0) {
  	if (DBRecordExists("Table_Bank", "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC))
	  	DBUpdateString("Table_Bank", "SaveDate", GetGameDate(), "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  	else {
		int i = DBAddRecord("Table_Bank", "CharacterID,SaveGP,LoanGP,SaveDate,LoanDate,BankTag", 
							IntToString(iCID)+",0,0,'"+GetGameDate()+"','"+GetGameDate()+"','" + sBankID + "'", 
							"BankID", "CharacterID=" + IntToString(iCID), oPC);
    }
  }
  
  // MAKE THE TRANSACTION
  TakeGoldFromCreature(iAmount, oPC, TRUE);
  iGoldInBank = iGoldInBank + iAmount;
  DBUpdateInt("Table_Bank", "SaveGP", iGoldInBank, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // UPDATE THE LOCAL VARIABLE
  SetLocalInt(oPC, "RBS_SAVE_GOLD", iGoldInBank);
  
  // Re-Start the Conversation
  ExecuteScript("row_rbs_start_conv", OBJECT_SELF);
  
}


void RBS_Withdraw(int iAmount, object oPC=OBJECT_INVALID) {
	string sBankID;
	int    iCID;
	int    iGoldInBank;

  // GATHER THE DEPOSITING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastSpeaker();
	
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET THE BANK TAG
  sBankID = GetBankTag(oPC);
  
  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  iGoldInBank = RBS_GetSavedGold(oPC);
    
  // MAKE SURE DEPOSIT VALUE IS CORRECT
  if (iAmount > iGoldInBank)
  	iAmount = iGoldInBank;
	
  // MAKE THE TRANSACTION
  GiveGoldToCreature(oPC, iAmount);
  iGoldInBank = iGoldInBank - iAmount;
  DBUpdateInt("Table_Bank", "SaveGP", iGoldInBank, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // UPDATE THE LOCAL VARIABLE
  SetLocalInt(oPC, "RBS_SAVE_GOLD", iGoldInBank);
  
  // Re-Start the Conversation
  ExecuteScript("row_rbs_start_conv", OBJECT_SELF);
  
}


void RBS_Borrow(int iAmount, object oPC=OBJECT_INVALID) {
	string sBankID;
	int    iCID;
	int    iGoldOnHand;
	int    iGoldOnLoan;
	int    iMaxLoan;

  // GATHER THE DEPOSITING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastSpeaker();
	
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET THE BANK TAG
  sBankID = GetBankTag(oPC);
  
  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  iGoldOnLoan = RBS_GetLoanGold(oPC);
  iMaxLoan    = iRBS_MaxLoan * GetLevel(oPC);
    
  // MAKE SURE DEPOSIT VALUE IS CORRECT
  iGoldOnHand = GetGold(oPC);
  if (iAmount > iGoldOnHand)
  	iAmount = iGoldOnHand;
  if (iGoldOnLoan + iAmount > iMaxLoan)
  	iAmount = iMaxLoan - iGoldOnLoan;
	
  // IF THE BANK IS EMPTY (NEW ACCOUNT), SET THE INTEREST RATE START DATE TO TODAY (GAME TIME)
  if (iGoldOnLoan == 0) {
  	if (DBRecordExists("Table_Bank", "CharacterID=" + IntToString(iCID), oPC))
	  	DBUpdateString("Table_Bank", "LoanDate", GetGameDate(), "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  	else {
		int i = DBAddRecord("Table_Bank", "CharacterID,SaveGP,LoanGP,SaveDate,LoanDate,BankTag", 
							IntToString(iCID)+",0,0,'"+GetGameDate()+"','"+GetGameDate()+"','" + sBankID + "'", 
							"BankID", "CharacterID=" + IntToString(iCID), oPC);
    }
  }
  
  // MAKE THE TRANSACTION
  GiveGoldToCreature(oPC, iAmount);
  iGoldOnLoan = iGoldOnLoan + iAmount;
  DBUpdateInt("Table_Bank", "LoanGP", iGoldOnLoan, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // UPDATE THE LOCAL VARIABLE
  SetLocalInt(oPC, "RBS_LOAN_GOLD", iGoldOnLoan);
  
  // Re-Start the Conversation
  ExecuteScript("row_rbs_start_conv", OBJECT_SELF);
  
}


void RBS_Repay(int iAmount, object oPC=OBJECT_INVALID) {
	string sBankID;
	int    iCID;
	int    iGoldOnLoan;
	int    iMaxLoan;

  // GATHER THE DEPOSITING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastSpeaker();
	
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET THE BANK TAG
  sBankID = GetBankTag(oPC);
  
  // FIND OUT HOW MUCH THE CHARACTER HAS IN THE BANK
  iGoldOnLoan = RBS_GetLoanGold(oPC);
  iMaxLoan    = iRBS_MaxLoan * GetLevel(oPC);
    
  // MAKE SURE DEPOSIT VALUE IS CORRECT
  if (iAmount > iGoldOnLoan)
  	iAmount = iGoldOnLoan;
	
  // MAKE THE TRANSACTION
  TakeGoldFromCreature(iAmount, oPC, TRUE);
  iGoldOnLoan = iGoldOnLoan - iAmount;
  DBUpdateInt("Table_Bank", "LoanGP", iGoldOnLoan, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // UPDATE THE LOCAL VARIABLE
  SetLocalInt(oPC, "RBS_LOAN_GOLD", iGoldOnLoan);
  
  // Re-Start the Conversation
  ExecuteScript("row_rbs_start_conv", OBJECT_SELF);
  
}


void RBS_SavingsInterest(object oPC){
  string sBankID = GetBankTag(oPC);
  string dToday  = GetGameDate();
  string dCheck;
  float  fInterest;
  float  fTotal;
  int    iCID;
  int    iTotal;
  int    iTotalYear;
  int    iTotalMonth;
  int    iGold;
  
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET GOLD IN SAVINGS. ABORT IF UNDER 500gp
  iGold  = RBS_GetSavedGold(oPC);
  if (iGold < 500)
  	return;
	
  // GET LAST INTEREST CHECK
  dCheck = DBReadString("Table_Bank", "SaveDate", "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // CALCULATE INTEREST GAINED
  iTotalYear = ((StringToInt(GetStringLeft(dToday, 4)) - StringToInt(GetStringLeft(dCheck, 4))) * 12);
  
  dToday = GetStringRight(dToday, 4);
  dCheck = GetStringRight(dCheck, 4);
  
  iTotalMonth = StringToInt(GetStringLeft(dToday, 2)) - StringToInt(GetStringLeft(dCheck, 2));
  if (iTotalMonth < 0)
  	iTotalMonth = iTotalMonth + 12;
	
  iTotal = (iTotalYear + iTotalMonth);

  // IF NO MONTHS HAVE PASSED, ABORT
  if (iTotal < 1)
  	return;

  // ADD INTEREST TO THE AMOUNT	
  fInterest = IntToFloat(iGold);
  fTotal    = IntToFloat(iTotal);
  fInterest = fInterest * (fRBS_SavingsRate * fTotal);
  
  SendMessageToPC(oPC, "BANK: You have earned " + IntToString(FloatToInt(fInterest)) + "gp in interest on your savings of " + IntToString(iGold) + "gp for " + IntToString(iTotal) + " months.");
  iGold = iGold + FloatToInt(fInterest);
  
  // CALCULATE INTEREST DATE
  dToday = GetGameDate();
  dToday = GetStringLeft(dToday, GetStringLength(dToday)-2);
  dCheck = dToday + GetStringRight(dCheck, 2);
  
  // UPDATE BANKING RECORD
  DBUpdateInt("Table_Bank", "SaveGP", iGold, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);  
  DBUpdateString("Table_Bank", "SaveDate", dCheck, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  SetLocalInt(oPC, "RBS_SAVE_GOLD", iGold);

}


void RBS_LoanInterest(object oPC){
  string sBankID = GetBankTag(oPC);
  string dToday  = GetGameDate();
  string dCheck;
  float  fInterest;
  float  fTotal;
  int    iCID;
  int    iTotal;
  int    iTotalYear;
  int    iTotalMonth;
  int    iGold;
  
  // ABORT IF NOT A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // DETERMINE THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // GET GOLD ON LOAN. ABORT IF ZERO
  iGold  = RBS_GetLoanGold(oPC);
  if (iGold == 0)
  	return;
	
  // GET LAST INTEREST CHECK
  dCheck = DBReadString("Table_Bank", "LoanDate", "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  
  // CALCULATE INTEREST GAINED
  iTotalYear = ((StringToInt(GetStringLeft(dToday, 4)) - StringToInt(GetStringLeft(dCheck, 4))) * 12);
  
  dToday = GetStringRight(dToday, 4);
  dCheck = GetStringRight(dCheck, 4);
  
  iTotalMonth = StringToInt(GetStringLeft(dToday, 2)) - StringToInt(GetStringLeft(dCheck, 2));
  if (iTotalMonth < 0)
  	iTotalMonth = iTotalMonth + 12;
	
  iTotal = (iTotalYear + iTotalMonth);

  // IF NO MONTHS HAVE PASSED, ABORT
  if (iTotal < 1)
  	return;

  // ADD INTEREST TO THE AMOUNT	
  fInterest = IntToFloat(iGold);
  fTotal    = IntToFloat(iTotal);
  fInterest = fInterest * (fRBS_LoanRate * fTotal);
  
  // APPLY MINIMUM INTEREST IS UNDER 5gp
  if (fInterest < 5.0)
  	fInterest = 5.0;
  
  SendMessageToPC(oPC, "BANK: You have incurred " + IntToString(FloatToInt(fInterest)) + "gp in interest on your loan of " + IntToString(iGold) + "gp for " + IntToString(iTotal) + " months.");
  iGold = iGold + FloatToInt(fInterest);
  
  // CALCULATE INTEREST DATE
  dToday = GetGameDate();
  dToday = GetStringLeft(dToday, GetStringLength(dToday)-2);
  dCheck = dToday + GetStringRight(dCheck, 2);
  
  // UPDATE BANKING RECORD
  DBUpdateInt("Table_Bank", "LoanGP", iGold, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);  
  DBUpdateString("Table_Bank", "LoanDate", dCheck, "CharacterID=" + IntToString(iCID) + " AND BankTag='" + sBankID + "'", oPC);
  SetLocalInt(oPC, "RBS_LOAN_GOLD", iGold);

}