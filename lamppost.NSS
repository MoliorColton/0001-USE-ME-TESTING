////////////////////////////////////////////////////////////////////////////////
// Automatically turn lights on during the night or off during the day
////////////////////////////////////////////////////////////////////////////////
// Modified By: Stephen M. LaBar, Jr.
// Modified On: 08/07/2002
////////////////////////////////////////////////////////////////////////////////
// Currently this goes into the OnHeartbeat event handler for an invisible
// object located in a module area.  For ease of use I named my invisible
// object LightOnOff.
////////////////////////////////////////////////////////////////////////////////
// Make a custom placeable light with the tag LampPost and place it in whatever
// area you want in your module.
////////////////////////////////////////////////////////////////////////////////
void main()
{
object oLamp;
int nNth=0;
oLamp = GetObjectByTag("LampPost", nNth);
int validDay = GetIsDawn() || GetIsDay();
int validNight = GetIsDusk() || GetIsNight();

// This part of the script only runs one time.
    if (GetLocalInt (OBJECT_SELF,"RUNONCE") != 1)
    {
    while (GetIsObjectValid(oLamp))
    {
        SetLocalInt(OBJECT_SELF,"RUNONCE",1);
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        SetPlaceableIllumination(oLamp, FALSE);
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);
        RecomputeStaticLighting(GetArea(oLamp));
        nNth++;
        oLamp = GetObjectByTag("LampPost", nNth);
    };
    }
// This part of the script only runs once at validNight.
    if (validNight && GetLocalInt(OBJECT_SELF, "NW_L_AMION") == 0 )
    {
    while (GetIsObjectValid(oLamp))
    {
        PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        SetPlaceableIllumination(oLamp, TRUE);
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",1);
        RecomputeStaticLighting(GetArea(oLamp));
        nNth++;
        oLamp = GetObjectByTag("LampPost", nNth);
    };
    }
// This part of the script only runs once at validDay.
    if (validDay && GetLocalInt(OBJECT_SELF, "NW_L_AMION") == 1)
    {
    while (GetIsObjectValid(oLamp))
    {
        PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        SetPlaceableIllumination(oLamp, FALSE);
        SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);
        RecomputeStaticLighting(GetArea(oLamp));
        nNth++;
        oLamp = GetObjectByTag("LampPost", nNth);
    };
    }
}