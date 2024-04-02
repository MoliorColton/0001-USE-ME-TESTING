void main()
{
	object oPC = GetItemActivator();
	CreateItemOnObject("goldring",oPC);
	CreateItemOnObject("emerald",oPC);
	DestroyObject(OBJECT_SELF);
	CreateItemOnObject("emerald",oPC);
	GiveGoldToCreature(oPC, 450);
}