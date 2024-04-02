// HAM Deacon

void main()
{
         object oNPC = OBJECT_SELF;
         string s;
         int c = GetLocalInt(oNPC, "Counter"); // read the counter

         switch(c) // display the corresponding line
         { 
                      case 0 : s = "I swear rocks keep falling every time I sleep.."; break;
                      case 1 : s = "..I think I'll move back up to the surface."; break;
					  case 2 : s = "It is easier to mug people on the surface aswell."; break;
					
         }

        c++; // increment counter
        if (c > 2) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }