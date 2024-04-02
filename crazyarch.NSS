// HAM Deacon

void main()
{
         object oNPC = OBJECT_SELF;
         string s;
         int c = GetLocalInt(oNPC, "Counter"); // read the counter

         switch(c) // display the corresponding line
         { 
                      case 0 : s = "I'm Bellock - respect me!."; break;
                      case 1 : s = "Get off my site!"; break;
					  case 2 : s = "No-one messes with Bellock's dig!"; break;
					  case 3 : s = "These ruins are mine!"; break;
                      case 4 : s = "Taste my knowledge!"; break;
					  case 5 : s = "You belong in a museum!"; break;
					  case 6 : s = "You'll end up like the rest!"; break;
					
         }

        c++; // increment counter
        if (c > 6) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }