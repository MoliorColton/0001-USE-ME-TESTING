//-----------------------------------------------------------------------
// <copyright file="angrysailor_talk2.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// HAM Deacon

void main()
{
         object oNPC = OBJECT_SELF;
         string s;
         int c = GetLocalInt(oNPC, "Counter"); // read the counter

         switch(c) // display the corresponding line
         { 
                      case 0 : s = "You destroyed my crate!"; break;
                      case 1 : s = "You should of looked where you were going!"; break;
					  case 2 : s = "You owe me for this!"; break;
					  case 3 : s = "Yes, I was carrying some valuable items."; break;
					  case 4 : s = "Just empty crates, look at them floating!"; break;
					  case 5 : s = "I owe you nothing, you hit me first!"; break;
					
         }

        c++; // increment counter
        if (c > 5) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }