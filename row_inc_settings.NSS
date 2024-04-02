// =============================================================
//
//    File: row_inc_settings
//    Desc: Rowell's Global Variables
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 13, 2006
// Updated: Feb 02, 2007
// Version: 1.0.4
//
//   Usage: Contains all Global Variables and Settings
//
//	 FOR USE WITH NWNX4 VERSION 1.07
//
// =============================================================


// NOTE:  Use this Script to set all the variables which control the various system of the module.


// NOTE:  You will need to Add 3 new Custom Factions to your module.
//		  It is VERY important that these factions be placed in the proper slots.
//		  RFS_NEUTRAL in slot #5.  This faction should be Neutral (50) to all other Factions.
//		  RFS_HOSTILE in slot #6.  This faction should be Friendly (100) to Hostile and RFS_Hostile.
//		 						   This faction should be Hostile (0) to Player, Commoner, Defender, RFS_Friendly.
//								   This faction should be Neutral (50) to Merchant, RFS_Neutral.
//		  RFS_FRIENDLY in slot #7. This faction should be Hostile (0) to Hostile and RFS_Hostile.
//								   This faction should be Friendly (100) to all other factions.

// GLOBAL VARAIBLES - (DO NOT TOUCH THIS SECTION!)
// =============================================================
int    DATABASE_TYPE_NONE = 0;						// NO DATABASE IS IN USE
int    DATABASE_TYPE_NWN  = 1;						// USE THE BUILT-IN NWN DATABASE
int    DATABASE_TYPE_NWNX = 2;						// USE NWN EXTENDER (NWNX4) AND SQL COMMANDS.  http://www.nwnx.org

int    DATABASE_FORMAT_SQLITE = 1;					// THE DATABASE IS A SQLITE DATABASE
int    DATABASE_FORMAT_MYSQL  = 2;					// THE DATABASE IS A MYSQL DATABASE


// GLOBAL VARIABLES - (YOU CAN CHANGE FROM THIS LINE DOWN)
// =============================================================
string gTable_Prefix      = "";						// CHANGE THIS TO THE BEGINNING PORTION OF YOUR TABLES
													// EXAMPLE: gTable_Prefix="Bob_", WOULD TRY TO ACCESS TABLES NAMED: "Bob_Table_Player"
int    gDatabaseType      = DATABASE_TYPE_NWNX;   	// Use None, NWN DB, SQL/NWNX4
int    gDatabaseFormat    = DATABASE_FORMAT_MYSQL;	// Database is a SQLite, MySQL  Database
int    iNWNdebug          = FALSE;					// DEBUGING IS ON (TRUE) OR OFF (FALSE)

													// THE COMMAND YOUR VERSION OF SQL USES TO GET THE CURRENT REAL DATE AND TIME
													// ONLY ONE SHOULD BE ACTIVE.  
													// IF YOU ARE USING A SQLITE DATABASE, UNCOMMENT OUT THE FIRST LINE.
													// IF YOU ARE USING A MYSQL  DATABASE, UNCOMMENT OUT THE SECOND LINE.
													// --------------------------------------------------------------------------
//	string gDateTimeNow   = "datetime('now')";		// COMMAND SQLITE USES TO GET THE CURRENT REAL DATE AND TIME
	string gDateTimeNow   = "SYSDATE()";			// COMMAND MYSQL  USES TO GET THE CURRENT REAL DATE AND TIME

int    gEnableItemTracking= FALSE;					// TRACK ALL THE ITEMS ALL PLAYERS HAVE, INTO THE DATABASE
													//   SET THIS TO FALSE, AS IT IS STILL IN DEVELOPMENT
													
int    gIDsize			  = 8;						// THE NUMBER OF PLACES FOR ID's  (ie 8 = 00000000, or up to 99,999,999 unique IDs)

						
// PLAYER SETTINGS		
// =============================================================
int    gStartingGold 	  = 250;					// AMOUNT OF GOLD FOR NEW CHARACTERS TO START WITH

				
// DEATH PENALTIES SETTINGS
// =============================================================
float fDeathPenaltyXP     = 0.0;					// PERCENTAGE OF XP IN THE CURRENT LEVEL TAKEN WHEN THE CHARACTER RESPAWNS  (IF GREATER THAN ZERO)
int   iDeathPenaltyXP     = 25;						// RAW AMOUNT OF XP, PER LEVEL, TAKEN WHEN THE CHARACTER RESPAWNS (IF GREATER THAN ZERO)
// ------------------------------------------------ // --- USE ONE SET OR THE OTHER.  DO NOT SET BOTH XP's/GP's ABOVE ZERO. ------------------------------------
float fDeathPenaltyGP     = 0.05;					// PERCENTAGE OF GP TAKEN WHEN THE CHARACTER RESPAWNS  (IF GREATER THAN ZERO)
int   iDeathPenaltyGP     = 0;                      // RAW AMOUNT OF GP, PER LEVEL, TAKEN WHEN THE CHARACTER RESPAWNS (IF GREATER THAN ZERO)

// LOCATION DISCOVERY REWARD SETTINGS
// =============================================================
int   iDiscoveryReward    = 50;						// XP GIVEN TO PLAYER THAT LOCATES A PLACE EQUAL TO HIS LEVEL.
													// THE FORMULA SCALES DOWN THE XP REWARD WHEN A HIGHER LEVEL CHARACTER DISCOVERS A LOWER LEVEL PLACE.																	
// RESTING SYSTEM SETTINGS											
// =============================================================
int   iRestRulesEnforced  = TRUE;					// USE THE REST RULES, WHICH LIMITS THE NUMBER OF TIMES A CHARACTER CAN REST PER HOUR
int   iRestNumberOfTimes  = 2;						// PLAYERS ONLY ALLOWED TO REST iRestNumberOfTimes PER HOUR

// RFS - ROWELL'S FACTION SYSTEM
// =============================================================
int   iRFSactiveSystem    = TRUE;					// WHEN SET TO TRUE, CREATURE USES OnPerception EVENTS TO DETERMINE HOSTILITY TO THE PLAYER.
													// WHEN SET TO FALSE, THE CREATURE'S ATTITUDE/HOSTILITY IS LEFT ALONE...
													// HOSTILE WILL ALWAYS BE HOSTILE, FRIENDLY WILL ALWAYS BE FRIENDLY.
													// THIS IS TO COMBAT A BUG IN NWN2 (as of version 1.02) WHERE PERSONAL REPUTATION IS NOT WORKING.
													// SUGGEST YOU KEEP THIS TO FALSE, AND PUT YOUR CREATURES INTO RFS_HOSTILE, RFS_FRIENDLY AND RFS_FACTION
													// TO START.  WHEN OBSIDIAN FIXES THE REPUTATION BUG, ALL YOU'LL HAVE TO DO IS SET THIS VARIABLE TO TRUE.
int   iRFSmarkUpRate      = 5;						// FOR EACH FACTION RANK, GIVE A X% BONUS/PENALTY TO STORE'S SELL TO PLAYER PRICE
int   iRFSmarkDownRate    = 3;						// FOR EACH FACTION RANK, GIVE A X% BONUS/PENALTY TO THE STORE'S BUY FROM PLAYER PRICE
		

// RBS - ROWELL'S BANKING SYSTEM SETTINGS
// =============================================================
float  fRBS_SavingsRate   = (0.05 / 12);			// THE MONTHLY INTEREST RATE ON SAVINGS. Example: 5% should be  (0.05 / 12)
float  fRBS_LoanRate      = (0.25 / 12);			// THE MONTHLY INTEREST RATE ON LOANS.   Example: 25% should be (0.25 / 12)
int    iRBS_MaxDeposit    = 100000;					// THE MAXIMUM AMOUNT A CHARACTER CAN PLACE IN THE BANK.
int    iRBS_MaxLoan       = 100;              		// THE MAXIMUM AMOUNT A CHARACTER CAN BORROW.  THIS IS BASED ON LEVEL.
                                            		//     EXAMPLE: with this option set to 100, a level 5 character can borrow 500gp
int    iRBS_MaxItems      = 20;						// THE MAXIMUM NUMBER OF ITEMS THAT CAN BE STORED IN THE BANK VAULT.
int    iRBS_AllowStacks   = FALSE;					// ALLOW STACKABLE ITEMS TO BE STORED IN BANK VAULT
													//     LEAVE SET TO FALSE - THERE IS A BUG IN THE NWN2 SCRIPTING LANGUAGE
													
// RQS - ROWELL'S QUESTING SYSTEM SETTINGS
// =============================================================
int    iRQSactiveSystem   = TRUE;					// USE THE QUEST SYSTEM

// RTS - ROWELL'S TRADESKILL SYSTEM SETTINGS
// =============================================================
int    iRTSactiveSystem   = FALSE;					// USE THE TRADESKILLS SYSTEM
int    iRTSdestroyRecipe  = TRUE;					// DESTROY THE RECIPE OBJECT ONCE A CHARACTER HAS LEARNED FROM IT
int    iRTSrewardBaseXP   = 20;						// BASE TRADESKILL XP REWARDED WHEN A PLAYER COMPLETES A RECIPE EQUAL TO HIS LEVEL IN THE TRADESKILL
int    iRTSrewardRange    = 4;						// THE LEVEL RANGE IN WHICH A PLAYER CAN GAIN TRADESKILL XP.
													// EXAMPLE: With iRTSrewardRange=4...
													//			A Level 5 Crafter would get XP for completing Recipes from level 1 to 5.  
													//			A Level 7 Crafter would get XP for completing Recipes from level 3 to 7. etc.
								