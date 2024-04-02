//-----------------------------------------------------------------------
// <copyright file="gemtoadventurer_talk2.nss" company="Molior RS">
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
                      case 0 : s = "We are working as fast as we can!"; break;
                      case 1 : s = "We would be going a lot faster if you didn't keep interrupting us."; break;
					  case 2 : s = "I don't have to listen to you, human!"; break;
					
         }

        c++; // increment counter
        if (c > 2) c = 0; // loop back when all lines exhausted
        SetLocalInt(oNPC, "Counter", c); // store the counter
		SpeakString(s);
        ExecuteScript("nw_c2_default1", oNPC); // execute NWN2 default script
        }