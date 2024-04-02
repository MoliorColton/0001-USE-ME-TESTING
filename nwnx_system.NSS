// Name     : NWNX System include
// Purpose  : Various functions for accessing the System plugin
// Authors  : Ingmar Stieger (Papillon)
// Modified : 25 Jan 07		-	Edward		- Initial release.
// Modified : 05 Aug 07		-	Edward		- Support for NWNX4 1.08.
// Modified : 12 Oct 08		-	Edward		- Support for NWNX4 1.09.
// Modified : 06 Apr 09		-	Edward		- Support for NWNX4 1.09 relative folders.
// Modified : 07 Apr 09		-	Edward		- Added CPU usage feature.


/************************************/
/* Constants                        */
/************************************/
const string PLUGIN_NAME	= "SYSTEM";


/************************************/
/* Function prototypes              */
/************************************/


// This method resets the server.
void ResetServer( );


// This method gets the CPU usage as a string.
string GetCPU( );


/************************************/
/* Implementation                   */
/************************************/


// This method resets the server.
void ResetServer( ){

	// Variables.
	object oModule			= GetModule( );
	object oPC				= GetFirstPC( );
	
	
	// Boot all the players from the server first, so they don't timeout.
	while( GetIsPC( oPC ) ){
		// Boot this player.
		BootPC( oPC );
		// Get the next player in our server player list.
		oPC = GetNextPC( );
	}
	
	// Reset the server in 1 round's time.
	DelayCommand( 6.0, NWNXSetString( PLUGIN_NAME, "RESET", "", 0, "" ) );
	
	return;
	
}


// This method gets the CPU usage as a string.
string GetCPU( ){

	return( NWNXGetString( PLUGIN_NAME, "GETCPU", "", 0 ) );
	
}