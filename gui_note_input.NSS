

void main()
{
    object oPC = GetPCSpeaker();
    string sInput = GetStringFromInputBox("How many items would you like to note?");
    //validate that the input is a number
    int nInput = StringToInt(sInput);
    if(nInput <= 0)
    {
        SendMessageToPC(oPC, "Invalid number entered.");
        return;
    }
    //store the input in the local variable
    SetLocalInt(oPC, "ENCHANT_RUNEA_QTY", nInput);
    //call the enchanting function
    NoteInitiate(oPC);
}