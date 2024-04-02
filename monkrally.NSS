// HAM Deacon

void main()
{
         object oNPC = OBJECT_SELF;
         string s;
         int c = GetLocalInt(oNPC, "Counter"); // read the counter

         switch(c) // display the corresponding line
         { 
                      case 0 : s = "Go in peace in the name of Saradomin; may his glory shine upon you like the sun."; break;
                      case 1 : s = "The darkness of death comes to all mortals; May Saradomin guide your soul to light."; break;
					  case 2 : s = "The currency of goodness is honour; It retains its value through scarcity. This is Saradomin's wisdom."; break;
					
         }

        c++; // increment counter
        if (c > 2) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }