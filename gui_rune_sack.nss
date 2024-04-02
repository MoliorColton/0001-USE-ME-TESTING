void GiveRandomItemsToPlayer(object oPlayer)
{
    int nChaosRuneMin = 100;
    int nChaosRuneMax = 200;
    int nDeathRuneMin = 100;
    int nDeathRuneMax = 200;
    int nBloodRuneMin = 50;
    int nBloodRuneMax = 100;
    int nSoulRuneMin = 25;
    int nSoulRuneMax = 50;
    
    int nChaosRune = nChaosRuneMin + d2(nChaosRuneMax - nChaosRuneMin + 1);
    int nDeathRune = nDeathRuneMin + d2(nDeathRuneMax - nDeathRuneMin + 1);
    int nBloodRune = nBloodRuneMin + d2(nBloodRuneMax - nBloodRuneMin + 1);
    int nSoulRune = nSoulRuneMin + d2(nSoulRuneMax - nSoulRuneMin + 1);

    SendMessageToPC(oPlayer, "Generating random items for you...");

    // Debug text for each item
    SendMessageToPC(oPlayer, "Generated " + IntToString(nChaosRune) + " chaos runes.");
    SendMessageToPC(oPlayer, "Generated " + IntToString(nDeathRune) + " death runes.");
    SendMessageToPC(oPlayer, "Generated " + IntToString(nBloodRune) + " blood runes.");
    SendMessageToPC(oPlayer, "Generated " + IntToString(nSoulRune) + " soul runes.");

    // Give Chaos Runes
    if(nChaosRune > 0)
        CreateItemOnObject("chaosrune", oPlayer, nChaosRune);
    
    // Give Death Runes
    if(nDeathRune > 0)
        CreateItemOnObject("deathrune", oPlayer, nDeathRune);
    
    // Give Blood Runes
    if(nBloodRune > 0)
        CreateItemOnObject("bloodrune", oPlayer, nBloodRune);
    
    // Give Soul Runes
    if(nSoulRune > 0)
        CreateItemOnObject("soulrune", oPlayer, nSoulRune);

    SendMessageToPC(oPlayer, "Random items generated and given to you.");
}

void main()
{
    object oPlayer = GetLastUsedBy();
    if (GetIsObjectValid(oPlayer))
    {
        GiveRandomItemsToPlayer(oPlayer);
    }
}