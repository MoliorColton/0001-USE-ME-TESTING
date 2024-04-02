// Icequeen's Persistent Stores (10/28/08)
// Adjust Markup by nAmount (+ or - Amount)

#include "iq_pss_db_inc"

void main(int nAmount)
{
int nAdjust=PSGetMarkup(OBJECT_SELF)+nAmount;
PSSetMarkup(OBJECT_SELF, nAdjust);
SetCustomToken(6001, IntToString(nAdjust));
}