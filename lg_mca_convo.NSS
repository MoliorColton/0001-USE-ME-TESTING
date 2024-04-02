//Script to have items call convos
void main()
{
 //Get the PC!
 object oPC = GetItemActivator();
 //Takes the convo as a variable called "convo" from the item
 string convo = GetLocalString(OBJECT_SELF, "convo");
 
 //Tell the PC to start a conversation
 AssignCommand(oPC, ActionStartConversation(oPC, convo));
}