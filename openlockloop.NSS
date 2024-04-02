#include "ginc_wp"
void main()
{
int iCurrentWP = GetCurrentWaypoint();
PlayCustomAnimation(OBJECT_SELF, "openlockloop", 1);
}