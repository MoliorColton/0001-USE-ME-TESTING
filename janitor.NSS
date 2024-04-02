void main()
{
 ClearAllActions();
 object oNearest = GetNearestObject(OBJECT_TYPE_ITEM, OBJECT_SELF);
 if (GetIsObjectValid(oNearest))
 {
  ActionMoveToObject(oNearest, TRUE, 1.0f);
  int nSay0 = Random(4);
  ActionPickUpItem(oNearest);
}
}
 