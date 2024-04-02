// Script to handle item activations!
void main()
{
	// Get the PC!
	object oPC = GetItemActivator();
	
	// Tell the PC to start a conversation with himself!
	AssignCommand(oPC, ActionStartConversation(oPC, "tinderbox"));
}