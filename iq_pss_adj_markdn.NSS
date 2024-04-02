// Icequeen's Persistent Stores (10/28/08)
// Adjust Markdown by nAmount (+ or - Amount)

#include "iq_pss_db_inc"

void main(int nAmount)
{
int nAdjust=PSGetMarkdown(OBJECT_SELF)+nAmount;
PSSetMarkdown(OBJECT_SELF, nAdjust);
SetCustomToken(6002, IntToString(nAdjust));
}