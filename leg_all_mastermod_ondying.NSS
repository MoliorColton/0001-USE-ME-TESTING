// Make sure player is really dead.  Will tune this up once we have the World System in place with optional death systems
void main()
{
    effect eDeath = EffectDeath(FALSE, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
}