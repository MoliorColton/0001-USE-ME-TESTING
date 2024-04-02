void main()
{
//Get the PC!
object oPC = GetItemActivator();
//Takes the convo as a variable called "convo" from the item
string convo = GetLocalString(OBJECT_SELF, "convo");

//Tell the PC to start a conversation
//12/21/15 clearing actions for prayerbooks fix
if (convo != "")
{
	AssignCommand(oPC, ActionStartConversation(oPC, convo, TRUE, FALSE));
}
}