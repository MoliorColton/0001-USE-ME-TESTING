// Update DB when Buy or Sell Item
/*
	Description: Met a jour la base de données des magasins
	lors de l'aquisition ou la perte d'un objet de l'inventaire du joueur
	
	si le magasin vend alors l'inventaire d'un joueur lancera l'event aquiere item
	--> nombre d'item en - (sAction = "sell")
	
*/
#include "nwnx_include"
#include "nwnx_sql"

void store_updatedb(object oItem , string sAction)
{
	string sQuery;
	int iCHAMP_ID_STOCK =  GetLocalInt(oItem,"iCHAMP_ID_STOCK");	
   if (!iCHAMP_ID_STOCK == 0) 
   {
	if (sAction == "sell") 
	{
	
		sQuery = "SELECT st.CHAMP_ID_STOCK, st.CHAMP_NB_ITEM, st.CHAMP_INFINITE_ITEM ";
		sQuery = sQuery + " FROM table_shop_stock AS st";
		sQuery = sQuery + " WHERE st.CHAMP_ID_STOCK = "+IntToString(iCHAMP_ID_STOCK)+" ";
		SQLExecDirect(sQuery);
	
		while (SQLFetch() == SQL_SUCCESS)
		{
			int iCHAMP_ID_STOCK = StringToInt(SQLGetData(1));
			int iCHAMP_NB_ITEM = StringToInt(SQLGetData(2));			
			int iCHAMP_INFINITE_ITEM = StringToInt(SQLGetData(3));
				
			if (IntToString(iCHAMP_INFINITE_ITEM) == "1") return;  // on ne fait rien car le nombre d'objet est infini
			
			if ( iCHAMP_NB_ITEM == 1 ) 
			{
			 	sQuery = "DELETE FROM table_shop_stock WHERE (CHAMP_ID_STOCK ="+IntToString(iCHAMP_ID_STOCK)+") "; //on supprime le dernier objet	
				SQLExecDirect(sQuery);
			 	return;			
			}//fin if  iCHAMP_NB_ITEM == 0
			
			
			if ( iCHAMP_NB_ITEM > 1) 
			{
			// on update le nombre d'objet
				sQuery ="UPDATE table_shop_stock AS st SET CHAMP_NB_ITEM = CHAMP_NB_ITEM - 1";
				sQuery = sQuery + " WHERE st.CHAMP_ID_STOCK = "+IntToString(iCHAMP_ID_STOCK)+" ";
				SQLExecDirect(sQuery);
				return;
			}//fin if  iCHAMP_NB_ITEM > 0

			//on enlève la variable sur l'objet
			DeleteLocalInt(oItem,"iCHAMP_ID_STOCK");
			
		}//fin while fetch
	
	}//fin if sAction == "sell"
	
	if (sAction == "buy") 
	{
	}//fin if sAction == "buy"
	
}//fin if !iCHAMP_ID_STOCK == 0	
}