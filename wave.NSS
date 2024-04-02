#include "ginc_wp"
void main()
{
int iCurrentWP = GetCurrentWaypoint();
PlayCustomAnimation(OBJECT_SELF, "WAVE", 1);
}