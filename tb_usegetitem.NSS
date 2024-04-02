void main()
{
	object oTarget = OBJECT_SELF;
	string sVariable = "item";
	object oPC = GetLastUsedBy();
    string sTemplate = GetLocalString(oTarget, sVariable);
	
	CreateItemOnObject( sTemplate, oPC, 1 );
}