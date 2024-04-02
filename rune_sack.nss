

void main(object oPlayer)
{
    object oPlayer = GetLastUsedBy();
    if (GetIsObjectValid(oPlayer))
    {
            SendMessageToPC(oPlayer, "Random items generated and given to you.");
    }
}