// store_create
/*
	Description: creation des shops (des plaçables) via base de données
	
*/
// Name_Date
#include "nwnx_include"
#include "nwnx_sql"

void main()
{
	object oObject = OBJECT_SELF; //on pointe sur le marchand
	string sMarchand = GetTag(oObject);
	location lObject = GetLocation(oObject); // localisation du marchand
	object oShop; // plaçable de l'echoppe
	int iOuvert = 0; //flag pour si le magasin est accessible; par defaut non; obliger car on peut pas imbriquer deux resultset
	
	string sTAG_ECHOPPE; //tag du magasin via db
	int iSTORE_INFINITE_ITEM; // variable dans la table_shop permettant de suivre ou non la règle de rareté.
	int iMODULE_INFINITE_ITEM = GetGlobalInt("store_infinite_item"); // variable global du module pour suivre ou non la règle de rareté
	int iCHAMP_GOLD; // variable dans la table_shop permettant d'avoir un fond de caisse

	string sQuery = "SELECT s.CHAMP_TAG_ECHOPPE, s.CHAMP_TAG_MARCHAND, s.CHAMP_ZONE, s.CHAMP_nMARKDOWN, s.CHAMP_nMARKUP, s.CHAMP_DISABLED, s.CHAMP_MAXBUY_ITEM, s.CHAMP_IDENTIFYCOST_ITEM";
	sQuery = sQuery + ", s.CHAMP_ATTITUDE, s.CHAMP_HEUREDOUVERTURE, s.CHAMP_HEUREFERMETURE, s.CHAMP_INFINITE_ITEM, s.CHAMP_GOLD FROM table_shop AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sMarchand+"' AND s.CHAMP_DISABLED <> 1";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		sTAG_ECHOPPE = SQLGetData(1);
		int iCHAMP_nMARKDOWN = StringToInt(SQLGetData(4));
		int iCHAMP_nMARKUP = StringToInt(SQLGetData(5));
		int iCHAMP_MAXBUY_ITEM = StringToInt(SQLGetData(7));
		int iCHAMP_IDENTIFYCOST_ITEM = StringToInt(SQLGetData(8));
		string sCHAMP_ATTITUDE = SQLGetData(9);
		string sCHAMP_HEUREDOUVERTURE = SQLGetData(10);
		string sCHAMP_HEUREFERMETURE = SQLGetData(11);
		iSTORE_INFINITE_ITEM = StringToInt(SQLGetData(12));
		int iCHAMP_GOLD = StringToInt(SQLGetData(13));
		
		int iHEUREGAME = GetTimeHour();
		SendMessageToPC(GetLastSpeaker(),"heure : "+IntToString(iHEUREGAME));		
		
		//si le magasin existe
		if ( GetObjectByTag(sTAG_ECHOPPE) != OBJECT_INVALID) 
		{
		SendMessageToPC(GetLastSpeaker(),"le magasin existe");	

			//si le magasin existe on verifie l'heure de fermeture OU qu'il soit ouvert tout le temps (99)
			if ( iHEUREGAME >= StringToInt(sCHAMP_HEUREDOUVERTURE) && iHEUREGAME <= StringToInt(sCHAMP_HEUREFERMETURE) || StringToInt(sCHAMP_HEUREDOUVERTURE) == 99) 
			{
				//on ne fait rien
			}else
			{
				SendMessageToPC(GetLastSpeaker(),"c est l heure de fermer");
				DestroyObject(GetObjectByTag(sTAG_ECHOPPE));//on détruit le plaçable magasin
				return;
			}// fin si c est l heure de fermeture
			 
			iOuvert = 1;	
		}else 
		{
			// et si l'heure du jeu correspond a l'heure d'ouverture OU qu'il doit etre tout le temps ouvert
			if ( iHEUREGAME >= StringToInt(sCHAMP_HEUREDOUVERTURE) && iHEUREGAME <= StringToInt(sCHAMP_HEUREFERMETURE) || StringToInt(sCHAMP_HEUREDOUVERTURE) == 99 ) 
			{
			SendMessageToPC(GetLastSpeaker(),"c est l heure d ouvrir");
			SendMessageToPC(GetLastSpeaker(),"le placeable n existe pas et on le cree");
					
			oShop = CreateObject(OBJECT_TYPE_STORE,sCHAMP_ATTITUDE,lObject,TRUE,sTAG_ECHOPPE);
			SetStoreIdentifyCost(oShop,iCHAMP_IDENTIFYCOST_ITEM);
			SetStoreMaxBuyPrice(oShop,iCHAMP_MAXBUY_ITEM);
			SetLocalInt(oShop,"nMARKDOWN",iCHAMP_nMARKDOWN);
			SetLocalInt(oShop,"nMARKUP",iCHAMP_nMARKUP);
			SetStoreGold(oShop, iCHAMP_GOLD);
			
			iOuvert = 1;
			}// fin if l'heure d'ouverture
		}//fin if else magasin existe ?
	
	}//fin if fetch
	
	if (iOuvert == 1) 
	{
		SendMessageToPC(GetLastSpeaker(),"iOuvert = 1");
		sQuery = "SELECT st.CHAMP_ID_STOCK, st.CHAMP_TAG_SHOP, st.CHAMP_RESREF_ITEM, st.CHAMP_NB_ITEM, st.CHAMP_STACKSIZE_ITEM, st.CHAMP_PRIX_CALCULE, st.CHAMP_PRIX_MODIFICATEUR";
		sQuery = sQuery + ", st.CHAMP_INFINITE_ITEM, st.CHAMP_DROPPABLE_ITEM, st.CHAMP_CURSED_ITEM, st.CHAMP_STOLEN_ITEM, st.CHAMP_USEABLE_ITEM, st.CHAMP_PICKPOCKETABLE_ITEM";
		sQuery = sQuery + " FROM table_shop_stock AS st";
		sQuery = sQuery + " WHERE st.CHAMP_TAG_SHOP = '"+sTAG_ECHOPPE+"' ";
		SQLExecDirect(sQuery);
	
		while (SQLFetch() == SQL_SUCCESS)
		{
			int iCHAMP_ID_STOCK = StringToInt(SQLGetData(1));
			string sCHAMP_RESREF_ITEM = SQLGetData(3);
			int iCHAMP_NB_ITEM = StringToInt(SQLGetData(4));			
			int iCHAMP_STACKSIZE_ITEM = StringToInt(SQLGetData(5));
			string sCHAMP_PRIX_MODIFICATEUR = SQLGetData(7);
			int iCHAMP_INFINITE_ITEM = StringToInt(SQLGetData(8));
			int iCHAMP_DROPPABLE_ITEM = StringToInt(SQLGetData(9));
			int iCHAMP_CURSED_ITEM = StringToInt(SQLGetData(10));
			int iCHAMP_STOLEN_ITEM = StringToInt(SQLGetData(11));
			int iCHAMP_USEABLE_ITEM = StringToInt(SQLGetData(12));
			int iCHAMP_PICKPOCKETABLE_ITEM = StringToInt(SQLGetData(13));				

			while( iCHAMP_NB_ITEM > 0) 
			{
				object oObjectShop = CreateItemOnObject(sCHAMP_RESREF_ITEM,oShop,iCHAMP_STACKSIZE_ITEM);
				
				//Permet de choisir par le magasin si tous ces objets sont en nombre infini
				//
				if (iSTORE_INFINITE_ITEM == 1 || iMODULE_INFINITE_ITEM == 1 || iCHAMP_INFINITE_ITEM == 1)
				{
				  	SetInfiniteFlag(oObjectShop, 1);
				 }else {
				 	SetInfiniteFlag(oObjectShop, 0);
				 }
				SetDroppableFlag(oObjectShop, iCHAMP_DROPPABLE_ITEM);
				SetItemCursedFlag(oObjectShop, iCHAMP_CURSED_ITEM);
				SetPickpocketableFlag(oObjectShop, iCHAMP_PICKPOCKETABLE_ITEM);
				SetStolenFlag(oObjectShop, iCHAMP_STOLEN_ITEM);
				SetUseableFlag(oObjectShop, iCHAMP_USEABLE_ITEM);
				SetLocalInt(oObjectShop,"iCHAMP_ID_STOCK",iCHAMP_ID_STOCK); // on place l'id de l'objet dans une variable
				//pour la mise a jour de la base de données
				
				iCHAMP_NB_ITEM = iCHAMP_NB_ITEM - 1;
			}//fin while iCHAMP_NB_ITEM > 0

		}//fin if fetch 
	}//fin if iOuvert == 1
	
	
}