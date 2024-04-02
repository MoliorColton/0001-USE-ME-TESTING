void GiveRandomItemsToPlayer(object oPC)
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

    SendMessageToPC(oPC, "Generating random items for you...");

    // Debug text for each item
    SendMessageToPC(oPC, "Generated " + IntToString(nChaosRune) + " chaos runes.");
    SendMessageToPC(oPC, "Generated " + IntToString(nDeathRune) + " death runes.");
    SendMessageToPC(oPC, "Generated " + IntToString(nBloodRune) + " blood runes.");
    SendMessageToPC(oPC, "Generated " + IntToString(nSoulRune) + " soul runes.");

    // Give Chaos Runes
    if(nChaosRune > 0)
        CreateItemOnObject("chaosrune", oPC, nChaosRune);
    
    // Give Death Runes
    if(nDeathRune > 0)
        CreateItemOnObject("deathrune", oPC, nDeathRune);
    
    // Give Blood Runes
    if(nBloodRune > 0)
        CreateItemOnObject("bloodrune", oPC, nBloodRune);
    
    // Give Soul Runes
    if(nSoulRune > 0)
        CreateItemOnObject("soulrune", oPC, nSoulRune);

    SendMessageToPC(oPC, "Random items generated and given to you.");
}

void main()
{
    object oPC = GetLastUsedBy();
    if (GetIsObjectValid(oPC))
    {
        GiveRandomItemsToPlayer(oPC);
    }
}