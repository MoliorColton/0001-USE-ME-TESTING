// Icequeen's Persistent Stores (10/28/08)
// Can Markdown be Adjusted?

#include "iq_pss_db_inc"

int StartingConditional(int nAmount)
{
 int nMark=PSGetMarkdown(OBJECT_SELF);
 if (abs(nAmount)==nAmount) nMark=101-nMark;
 nAmount=abs(nAmount);
 if (nMark>nAmount) return TRUE;
 return FALSE;
}