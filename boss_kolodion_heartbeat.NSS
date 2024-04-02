void main()
{
	object oBOSS = OBJECT_SELF;
	if (GetTag(oBOSS) == "kolodion") return;
	int nCOUNT = GetLocalInt(oBOSS, "DESPAWN");
	if (GetIsInCombat(oBOSS) == TRUE) DeleteLocalInt(oBOSS, "DESPAWN");
	else SetLocalInt(oBOSS, "DESPAWN", nCOUNT + 1);
	if (nCOUNT == 4) DestroyObject(oBOSS);
}