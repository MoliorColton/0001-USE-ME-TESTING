//::///////////////////////////////////////////////
//:: Example XP2 OnItemUnAcquireScript
//:: x2_mod_def_unaqu
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemUnAcquire Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:: Modified By : Nosfe  on 2007-08-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "store_updatedb"
void main()
{
     object oItem = GetModuleItemLost();
	 
	 //-------------------------------------------------\\
	 //--           Partie Store Persistant           --\\
	 //-------------------------------------------------\\
	 // si dans les propriétés du module il y a la variable store_infinite_item = 1 alors les objets 
	 //  seront tous en nombre infini quelque soit les paramatres dans le magasin ou l'objet
	 if (GetGlobalInt("store_infinite_item") == 0 ) {	 	 
		store_updatedb(oItem, "buy"); // le magasin achete au joueur
	 }
	 //---        FIN Partie Store Persistant        ---\\
	 	 
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

}