//////////////////////////////////////////////////
//Function: Use on placeables so PCs can sit.
//Ver: 1.0
//Modified by:
//Date:
///////////////////////////////////////////////////////
//Place this script in the OnUsed handler of the object
///////////////////////////////////////////////////////
void main()
{
    object oChair = OBJECT_SELF;
    //Make sure no one is in chair, if not sitdown.
    if(!GetIsObjectValid(GetSittingCreature(oChair)))
        {
        AssignCommand(GetLastUsedBy(),ActionSit(oChair));
        }
}
//End