// store_cond_open
/*
	Description: condition d'apparition du message d'ouverture du magasin 
	sinon le placable n'existe pas et le magasin est fermé
	
*/

int StartingConditional()
{
	if (GetObjectByTag(GetLocalString(OBJECT_SELF,"store_name")) == OBJECT_INVALID)
	{
		return 0; // le magasin est fermé
	}else
	{
		return 1; // le magasin est ouvert
	}
}