// store_interface
/*
	Auteur:  Nosfe
	Date : 20-08-2007
	Description: cette interface va permettre de modifier/afficher les informations des magasins
		a partir du jeu, via script;
		Ceci afin d'utiliser ces informations en dehors du système de magasin.
*/
#include "nwnx_include"
#include "nwnx_sql"

const string TABLE_STORE = "table_shop";
const string TABLE_STORE_STOCK = "table_shop_stock";

//------------ Interfaces du magasin ------------------------------------------------------

void DestructionEchoppe(object oMarchand); //va supprimer le plaçable echoppe comme si le magasin était fermé

void SetCHAMP_TAG_ECHOPPE_store(object oMarchand, string sNewTagEchoppe);
string GetCHAMP_TAG_ECHOPPE_store(object oMarchand); // on récupère le tag du magasin dans les variables du marchand
//si aucune variable se trouve sur le marchand alors retourne "no_store"
//si dans la base de données il n'y a pas d'echoppe de ce nom défini alors retourne "no_store_db"

void SetCHAMP_ZONE_store(string sTagMarchand); // modifie le champ de la zone du magasin par rapport au tag du marchand
string GetCHAMP_ZONE_store(string sTagMarchand); // récupère le champ de la zone du magasin par rapport au tag du marchand

void SetCHAMP_nMARKDOWN_store(string sTagMarchand, int nNewValue);
int GetCHAMP_nMARKDOWN_store(string sTagMarchand);

void SetCHAMP_nMARKUP_store(string sTagMarchand, int nNewValue);
int GetCHAMP_nMARKUP_store(string sTagMarchand);

void SetCHAMP_DISABLED_store(string sTagMarchand, int nDisabled=1); //(defaut) 1 pour désactivé , 0 pour réactiver
int GetCHAMP_DISABLED_store(string sTagMarchand);

void SetCHAMP_MAXBUY_ITEM_store(string sTagMarchand, int nMaxBuy=1000); // valeur maximum d'un objet (defaut) 1000 po maximum
int GetCHAMP_MAXBUY_ITEM_store(string sTagMarchand);

void SetCHAMP_IDENTIFYCOST_ITEM_store(string sTagMarchand, int nIdentifycost=100); // le cout d'une identification d'un objet (defaut) 100 po
int GetCHAMP_IDENTIFYCOST_ITEM_store(string sTagMarchand);

void SetCHAMP_ATTITUDE_store(string sTagMarchand, string sAttitude); // Permet de changer le modèle plaçable (magasin_honnete;magasin_malhonnete)
string GetCHAMP_ATTITUDE_store(string sTagMarchand);

void SetCHAMP_HEUREDOUVERTURE_store(string sTagMarchand, string sHeuredouverture); // entre 0 et 23
string GetCHAMP_HEUREDOUVERTURE_store(string sTagMarchand);

void SetCHAMP_HEUREFERMETURE_store(string sTagMarchand, string sHeuredefermeture); // entre 0 et 23
string GetCHAMP_HEUREFERMETURE_store(string sTagMarchand);

void SetCHAMP_INFINITE_ITEM_store(string sTagMarchand, string sInfinite="1"); // rend le nombre d'objet dans ce magasin infini (defaut) 1 infini
string GetCHAMP_INFINITE_ITEM_store(string sTagMarchand);

void SetCHAMP_GOLD_store(string sTagMarchand, string sGold="1000"); // permet de définir le fond de caisse du marchand (defaut) 1000 po
string GetCHAMP_GOLD_store(string sTagMarchand);


//--**************************************************************************************--
//------ Implementations des interfaces -----------------

 //va supprimer le plaçable echoppe comme si le magasin était fermé
void DestructionEchoppe(object oMarchand)
{
	if (!GetIsObjectValid(oMarchand)) return;

	string sMarchand = GetTag(oMarchand);
	
	string sTag = GetLocalString(oMarchand,"store_name"); //va chercher la variable du nom du magasin
	if (sTag == "") return;
	
	DestroyObject(GetObjectByTag(sTag));
}


string GetCHAMP_TAG_ECHOPPE_store(object oMarchand){
	if (!GetIsObjectValid(oMarchand)) return "no_valid";

	string sMarchand = GetTag(oMarchand);
	
	string sTag = GetLocalString(oMarchand,"store_name"); //va chercher la variable du nom du magasin
	if (sTag == "") return "no_store";
	
	string sQuery = "SELECT s.CHAMP_TAG_ECHOPPE";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sTAG_ECHOPPE = SQLGetData(1);
		return sTAG_ECHOPPE;
	}else 
	{
		return "no_store_db";
	}	
}//fin GetCHAMP_TAG_ECHOPPE_store


void SetCHAMP_TAG_ECHOPPE_store(object oMarchand, string sNewTagEchoppe)
{
	if (!GetIsObjectValid(oMarchand)) return;	

	string sMarchand = GetTag(oMarchand);
	
 	SetLocalString(oMarchand,"store_name", sNewTagEchoppe); //va créer une variable du tag echoppe	
	
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_TAG_ECHOPPE = '"+ sNewTagEchoppe +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sMarchand+"' ";
	SQLExecDirect(sQuery);
	
}// SetCHAMP_TAG_ECHOPPE_store

// récupère le champ de la zone du magasin par rapport au tag du marchand
//retourne no_tag_zone si il n'y a une erreur dans l'extraction de la db
string GetCHAMP_ZONE_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_ZONE";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sTAG_ZONE = SQLGetData(1);
		return sTAG_ZONE;
	}else 
	{
		return "no_tag_zone";
	}		
}// GetCHAMP_ZONE_store

int GetCHAMP_nMARKDOWN_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_nMARKDOWN";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	return -1;

}// fin GetCHAMP_nMARKDOWN_store

void SetCHAMP_nMARKDOWN_store(string sTagMarchand, int nNewValue )
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_nMARKDOWN = "+ IntToString(nNewValue) +" ";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);

}// fin SetCHAMP_nMARKDOWN_store


int GetCHAMP_nMARKUP_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_nMARKUP";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	return -1;	

}// fin GetCHAMP_nMARKUP_store

void SetCHAMP_nMARKUP_store(string sTagMarchand, int nNewValue)
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_nMARKUP = "+ IntToString(nNewValue) +" ";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);

} // fin SetCHAMP_nMARKUP_store

int GetCHAMP_DISABLED_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_DISABLED";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	return -1;	

} // fin GetCHAMP_DISABLED_store

//(defaut) 1 pour désactivé , 0 pour réactiver
void SetCHAMP_DISABLED_store(string sTagMarchand, int nDisabled=1) 
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_DISABLED = "+ IntToString(nDisabled) +" ";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);

} // fin SetCHAMP_DISABLED_store

int GetCHAMP_MAXBUY_ITEM_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_MAXBUY_ITEM";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	return -1;	
} //fin GetCHAMP_MAXBUY_ITEM_store

 // valeur maximum d'un objet (defaut) 1000 po maximum
void SetCHAMP_MAXBUY_ITEM_store(string sTagMarchand, int nMaxBuy=1000)
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_MAXBUY_ITEM = "+ IntToString(nMaxBuy) +" ";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);

} // fin SetCHAMP_MAXBUY_ITEM_store

int GetCHAMP_IDENTIFYCOST_ITEM_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_IDENTIFYCOST_ITEM";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		int nValue = StringToInt(SQLGetData(1));
		return nValue;
	}
	return -1;	

} // fin GetCHAMP_IDENTIFYCOST_ITEM_store

 // le cout d'une identification d'un objet (defaut) 100 po
void SetCHAMP_IDENTIFYCOST_ITEM_store(string sTagMarchand, int nIdentifycost=100)
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_IDENTIFYCOST_ITEM = "+ IntToString(nIdentifycost) +" ";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
}// fin SetCHAMP_IDENTIFYCOST_ITEM_store

string GetCHAMP_ATTITUDE_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_ATTITUDE";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sValue = SQLGetData(1);
		return sValue;
	}
	return "no_attitude";		
} // fin GetCHAMP_ATTITUDE_store

// Permet de changer le modèle plaçable (magasin_honnete;magasin_malhonnete)
void SetCHAMP_ATTITUDE_store(string sTagMarchand, string sAttitude)
{
	if (sAttitude == "") return;
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_ATTITUDE = '"+ sAttitude +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
}

string GetCHAMP_HEUREDOUVERTURE_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_HEUREDOUVERTURE";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sValue = SQLGetData(1);
		return sValue;
	}
	return "no_heuredouverture";	
} // fin GetCHAMP_HEUREDOUVERTURE_store

// entre 0 et 23
void SetCHAMP_HEUREDOUVERTURE_store(string sTagMarchand, string sHeuredouverture)
{
	if (StringToInt(sHeuredouverture) < 0 || StringToInt(sHeuredouverture) > 23) return;
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_HEUREDOUVERTURE = '"+ sHeuredouverture +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);	
} // fin  SetCHAMP_HEUREDOUVERTURE_store

string GetCHAMP_HEUREFERMETURE_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_HEUREFERMETURE";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sValue = SQLGetData(1);
		return sValue;
	}
	return "no_heurefermeture";	

} // fin GetCHAMP_HEUREFERMETURE_store

 // entre 0 et 23
void SetCHAMP_HEUREFERMETURE_store(string sTagMarchand, string sHeuredefermeture)
{
	if (StringToInt(sHeuredefermeture) < 0 || StringToInt(sHeuredefermeture) > 23) return;
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_HEUREFERMETURE = '"+ sHeuredefermeture +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);	
}// fin SetCHAMP_HEUREFERMETURE_store

string GetCHAMP_INFINITE_ITEM_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_INFINITE_ITEM";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sValue = SQLGetData(1);
		return sValue;
	}
	return "no_infinite";	
} // fin GetCHAMP_INFINITE_ITEM_store
 
// rend le nombre d'objet dans ce magasin infini (defaut) 1 infini
void SetCHAMP_INFINITE_ITEM_store(string sTagMarchand, string sInfinite="1")
{
	if (sInfinite != "0" || sInfinite != "1") return;
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_INFINITE_ITEM = '"+ sInfinite +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);		
} // fin SetCHAMP_INFINITE_ITEM_store

string GetCHAMP_GOLD_store(string sTagMarchand)
{
	string sQuery = "SELECT s.CHAMP_GOLD";
	sQuery = sQuery + " FROM "+ TABLE_STORE  +" AS s";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() == SQL_SUCCESS)
	{
		string sValue = SQLGetData(1);
		return sValue;
	}
	return "no_gold";	
} // fin GetCHAMP_GOLD_store

// permet de définir le fond de caisse du marchand (defaut) 1000 po
void SetCHAMP_GOLD_store(string sTagMarchand, string sGold="1000")
{
	string sQuery = "UPDATE FROM "+ TABLE_STORE +" AS s";
	sQuery = sQuery + " SET s.CHAMP_GOLD = '"+ sGold +"'";
	sQuery = sQuery + " WHERE s.CHAMP_TAG_MARCHAND = '"+sTagMarchand+"' ";
	SQLExecDirect(sQuery);		
} // fin  SetCHAMP_GOLD_store