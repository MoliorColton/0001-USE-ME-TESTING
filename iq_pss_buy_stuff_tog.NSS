// Icequeen's Persistent Stores (10/28/08)
// Toggle store-can-buy: 0=off, -1=on

#include "iq_pss_db_inc"

void main(int nToggle)
{
PSSetBuy(OBJECT_SELF, nToggle);
}