//:: Icequeen's Persistent Housing (10/28/08)
// Trigger to unlock nearest door ... For "keyed" doors that have no key
// Useful for Player Housing "Apartmenrs" (where the "house" door(s) is non-transistional)
// To use, paint a small "Open Door Trigger" at the interior of door.
// Script is already attached to trigger's blueprint.

void main()
{
object oDoor=GetNearestObject(OBJECT_TYPE_DOOR);
if (!GetIsObjectValid(oDoor) || GetIsOpen(oDoor)) return;
AssignCommand(oDoor, ActionUnlockObject(oDoor));
DelayCommand(0.1, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
}