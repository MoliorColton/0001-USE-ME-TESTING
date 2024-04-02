//originally Uncle FB's control
// Credit to Kamal too!

//npc_bartender
//Uncle FB
//05/2009
//use 1 generic waypoint tagged "WP_BARTENDER" where you want the bartender to stand
//while waiting for drink orders
//use 1 generic waypoint tagged "WP_KEG" where you want the bartender to get the drinks

void main ()
{
object oNpc = OBJECT_SELF;
object oBar = GetWaypointByTag ("WP_BARTENDER");
float fDirbar = GetFacing (oBar);
float fBar = GetDistanceToObject (oBar);
object oKeg = GetWaypointByTag ("WP_KEG");
float fKeg = GetDistanceToObject (oKeg);
int nRandom = Random(4);
int nBusy = GetLocalInt (oNpc, "busy");
	{switch (nBusy)
		{
//default =  stay near the wp labeled "WP_BARTENDER" and do random animations		  
		default:
		if (fBar >=0.5) {ActionMoveToObject (oBar, 0,0.0); return;}
		else
		{switch (nRandom)
			{
			case 1:
			PlayCustomAnimation (oNpc, "lookleft", 0,5.0);
			break;
			case 2:
			PlayCustomAnimation (oNpc, "lookright", 0, 5.0);
			break;
			default:
			PlayCustomAnimation (oNpc, "gettable", 0, 3.5);
			break;
			}
		}
		break;
//1. move to the keg and fill the drink order		
		case 1:
		ActionMoveToObject (oKeg,0,0.0);
		if (fKeg <= 1.0)
			{switch (Random (2))
				{
				default:
				PlayCustomAnimation (oNpc, "gettable", 0, 2.1);
				SetLocalInt (oNpc, "busy", 2);
				break;
				case 1:
				PlayCustomAnimation (oNpc, "openlock", 0, 3.0);
				SetLocalInt (oNpc, "busy", 2);
				break;
				}
			}
		break;		
//2. after filling order move back to the bar and deliver		
		case 2:
		ActionMoveToObject (oBar,0,0.0);
		if (fBar <= 1.0)
			{
			SetFacing (fDirbar);
			PlayCustomAnimation (oNpc, "gettable", 0, 3.5);
			SetLocalInt (oNpc, "busy", 0);
			}			
		break;
		}
	}
}					
						
			