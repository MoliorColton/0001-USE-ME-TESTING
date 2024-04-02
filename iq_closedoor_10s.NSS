// "On Open" Handler for doors
// Close & lock (if lockable) door after 10 seconds
// Closes linked doors (so the linked door does not get stuck in the "open" position)
void main()
{
object oDoor=OBJECT_SELF;
object oTrans=GetTransitionTarget(oDoor);
if (GetIsObjectValid(oTrans))
	{
	if (GetIsOpen(oTrans)) DelayCommand(10.0, AssignCommand(oTrans, ActionCloseDoor(oTrans)));
	if (GetLockLockable(oTrans)) DelayCommand(10.5, SetLocked(oTrans, TRUE));
	}
if (GetLockLockable(oDoor)) DelayCommand(10.5, SetLocked(oDoor, TRUE));
if (GetIsOpen(oDoor)) DelayCommand (10.0, AssignCommand(oDoor, ActionCloseDoor(oDoor)));
return;
}