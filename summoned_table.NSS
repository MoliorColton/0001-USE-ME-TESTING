string RetrieveSummonedCreature(int nTAG, int nTYPE = 0)
{
if (nTYPE == 1)
{
//Add the ResRef of the various HENCHMEN here. Make sure it has three digits (ie 002, 003, ecc.)
switch (nTAG)
{
case 001: return "alkharidbodyguard"; break;
case 002: return "dwarvenscout"; break;
}
}
else
{
//Add the ResRef of the various SUMMONED PETS here. Make sure it has three digits (ie 002, 003, ecc.)
switch (nTAG)
{
case 001: return "cat_summon"; break;
}
}
return "";
}