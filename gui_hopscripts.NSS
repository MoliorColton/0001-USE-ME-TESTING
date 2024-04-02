#include "ginc_param_const"
#include "ginc_transition"

void main(string sDestination, int bIsPartyTranstion)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
     object oDestination    = GetTarget(sDestination);
    StandardAttemptAreaTransition(oPC, oDestination, bIsPartyTranstion);
}