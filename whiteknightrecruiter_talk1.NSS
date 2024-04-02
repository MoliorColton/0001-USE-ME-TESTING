// HAM Deacon

void main()
{
         object oNPC = OBJECT_SELF;
         string s;
         int c = GetLocalInt(oNPC, "Counter"); // read the counter

         switch(c) // display the corresponding line
         { 
                      case 0 : s = "Join the White Knights today, and you will earn yourself some armour!"; break;
                      case 1 : s = "Tired of doing nothing? Join the White Knights for some action!"; break;
					  case 2 : s = "Fancy getting paid while defending your family?"; break;
					  case 3 : s = "Join the White Knights and you will support your family for like!"; break;
					  case 4 : s = "Need a new blade? Some new armour?"; break;
					  case 5 : s = "The White Knights might be the role for you!"; break;
					
         }

        c++; // increment counter
        if (c > 5) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }