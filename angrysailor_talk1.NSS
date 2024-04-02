//-----------------------------------------------------------------------
// <copyright file="angrysailor_talk1.nss" company="Molior RS">
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
                      case 0 : s = "Crate? YOU destroyed my cart!"; break;
                      case 1 : s = "Don't place a crate in the middle of the dock then!"; break;
					  case 2 : s = "I owe you?"; break;
					  case 3 : s = "I have 4 crates swimming in the ocean thanks to you!"; break;
					  case 4 : s = "They are still my crates! You owe me!"; break;
					  case 5 : s = "You walked into me!"; break;
					
         }

        c++; // increment counter
        if (c > 5) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }