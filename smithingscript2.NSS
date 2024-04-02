void main()
{
    string sXML;
    string sSCREEN;
    string sPLACE = GetTag(OBJECT_SELF);
    if (sPLACE == "furnace")
    {
        sXML = "smithingmenu.xml";
        sSCREEN = "SMITHINGMENU";
    }
		else if (sPLACE == "potterywheel")
    {
        sXML = "potterytable.xml";
        sSCREEN = "POTTERYWHEEL";
    }
		else if (sPLACE == "anvil")
    {
        sXML = "anvilmenu.xml";
        sSCREEN = "ANVILMENU";
    }
		else if (sPLACE == "smelter")
    {
        sXML = "smeltmenu.xml";
        sSCREEN = "SMELTMENU";
    }
		else if (sPLACE == "bitsrefinery")
    {
        sXML = "refinermenu.xml";
        sSCREEN = "REFINERMENU";
    }
		else if (sPLACE == "watersource")
    {
        sXML = "watermenu.xml";
        sSCREEN = "WATERMENU";
    }
		else if (sPLACE == "sink")
    {
        sXML = "doughmenu.xml";
        sSCREEN = "SCREEN_DOUGH_1";
    }
		else if (sPLACE == "cookingsink")
    {
        sXML = "cooksink.xml";
        sSCREEN = "COOKSINKMENU";
    }
		else if (sPLACE == "spinningwheelfletching")
    {
        sXML = "loommenu.xml";
        sSCREEN = "LOOMMENU";
    }
		else if (sPLACE == "spit")
    {
        sXML = "ovenorfire.xml";
        sSCREEN = "OVENMENU";
    }
			else if (sPLACE == "oven")
    {
        sXML = "ovenorfire.xml";
        sSCREEN = "OVENMENU";
    }
		else if (sPLACE == "cremationpyre")
    {
        sXML = "bonesmenu.xml";
        sSCREEN = "BONESMENU";
    }
        else if (sPLACE == "plotitemsplace")
    {
        sXML = "questremoveitemgui.xml";
        sSCREEN = "PLOTITEMMENU";
    }
       else if (sPLACE == "patronstatue")
    {
        sXML = "patrons.xml";
        sSCREEN = "PATRONSMENU";
    }
       else if (sPLACE == "millforflour")
    {
        sXML = "millforflour.xml";
        sSCREEN = "MILLFLOURSMENU";
    }
       else if (sPLACE == "tanner")
    {
        sXML = "temptannermenu.xml";
        sSCREEN = "TANNERMENU";
    }
       else if (sPLACE == "barrowschest")
    {
        sXML = "barrowschest.xml";
        sSCREEN = "BARROWSCHEST";
    }
	       else if (sPLACE == "tokenmenu")
    {
        sXML = "tokenmenu.xml";
        sSCREEN = "TOKENMANU";
    }
		       else if (sPLACE == "slimemenu")
    {
        sXML = "slimemenu.xml";
        sSCREEN = "SLIMEMENU";
    }
		       else if (sPLACE == "spawnitemmenu")
    {
        sXML = "spawnitemmenu.xml";
        sSCREEN = "SPAWNITEMSMENU";
    }
			   else if (sPLACE == "bonegrinder")
    {
        sXML = "bonegrinder.xml";
        sSCREEN = "BONEGRINDERMENU";
    }
			   else if (sPLACE == "ectofuntus")
    {
        sXML = "ectofuntus.xml";
        sSCREEN = "ECTOFUNTUSMENU";
    }
			   else if (sPLACE == "artisanfurnace")
    {
        sXML = "artisanfurnace.xml";
        sSCREEN = "ARTISANMENU";
    }
			  else if (sPLACE == "quenching")
    {
        sXML = "artisanquenchingpool.xml";
        sSCREEN = "ARTISANPOOLMENU";
    }
			  else if (sPLACE == "ceremonialdeposit")
    {
        sXML = "ceremonialdeposit.xml";
        sSCREEN = "ARTISANDEPOSITMENU";
    }
			  else if (sPLACE == "artisanshop")
    {
        sXML = "artisanshop.xml";
        sSCREEN = "ARTISANSHOPMENU";
    }
			 else if (sPLACE == "questxmltester")
    {
        sXML = "q1cooksassistant.xml";
        sSCREEN = "QUEST1COOKSASSISTANT";
    }
			 else if (sPLACE == "xmlworldmap")
    {
        sXML = "moliorworldmap.xml";
        sSCREEN = "MOLIORWORLDMAP";
    }
			 else if (sPLACE == "xmlwizardtraining1")
    {
        sXML = "wizardtraining1.xml";
        sSCREEN = "WIZARDTRAINING1";
    }
				 else if (sPLACE == "tokkulshop")
    {
        sXML = "tokkulshop.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP";
    }
				 else if (sPLACE == "tokkulshop2")
    {
        sXML = "tokkulshop2.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP2";
    }
				 else if (sPLACE == "tokkulshop3")
    {
        sXML = "tokkulshop3.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP3";
    }
				 else if (sPLACE == "Hweenrewardshop")
    {
        sXML = "Hweenrewardshop.xml";
        sSCREEN = "HWEENREWARDSHOP";
    }	
				 else if (sPLACE == "skilltokenshop")
    {
        sXML = "skilltokenexchange.xml";
        sSCREEN = "SKILLTOKENSHOP";
    }	
				 else if (sPLACE == "rsgeneralstore")
    {
        sXML = "rsgeneralstore.xml";
        sSCREEN = "RSGENERALSTORE";
    }
				 else if (sPLACE == "pool2")
    {
        sXML = "pool2.xml";
        sSCREEN = "POOLMENU";
    }
				 else if (sPLACE == "cheatdesk")
    {
        sXML = "cheatdesk.xml";
        sSCREEN = "CHEATDESK";
    }
				 else if (sPLACE == "craftingguildposters")
    {
        sXML = "craftingguildmenu.xml";
        sSCREEN = "CRAFTINGGUILDMENU";
    }
				 else if (sPLACE == "cratetable")
    {
        sXML = "cratemakingmenu.xml";
        sSCREEN = "CRATEMENU";
    }
				 else if (sPLACE == "craftestore")
    {
        sXML = "craftestoremenu.xml";
        sSCREEN = "CRAFTSTOREMENU";
    }
				 else if (sPLACE == "sawmillstore")
    {
        sXML = "sawmillmenu.xml";
        sSCREEN = "SAWMILLSTOREMENU";
    }
				 else if (sPLACE == "canoespot")
    {
        sXML = "canoesystem.xml";
        sSCREEN = "CANOEMENU";
    }
				 else if (sPLACE == "alkharidstore")
    {
        sXML = "rsgeneralstorealkharid.xml";
        sSCREEN = "RSGENERALSTOREALKHARID";
    }
				 else if (sPLACE == "banditcampstore")
    {
        sXML = "rsgeneralstorebanditcamp.xml";
        sSCREEN = "RSGENERALSTOREBANDITCAMP";
    }
				 else if (sPLACE == "canifisstore")
    {
        sXML = "rsgeneralstorecanifis.xml";
        sSCREEN = "RSGENERALSTORECANIFIS";
    }
				 else if (sPLACE == "edgevillestore")
    {
        sXML = "rsgeneralstoreedgeville.xml";
        sSCREEN = "RSGENERALSTOREEDGEVILLE";
    }
				 else if (sPLACE == "faldorstore")
    {
        sXML = "rsgeneralstorefalador.xml";
        sSCREEN = "RSGENERALSTOREFALADOR";
    }
				 else if (sPLACE == "lumbridgestore")
    {
        sXML = "rsgeneralstorelumbridge.xml";
        sSCREEN = "RSGENERALSTORELUMBRIDGE ";
    }
				 else if (sPLACE == "slayerstore")
    {
        sXML = "slayerstores.xml";
        sSCREEN = "RSSTORESSLAYER ";
    }
				 else if (sPLACE == "swordstore")
    {
        sXML = "rsswordshops.xml";
        sSCREEN = "RSSTORESWORD ";
    }
				 else if (sPLACE == "swordkiteshield")
    {
        sXML = "rskiteshieldshop.xml";
        sSCREEN = "RSSTOREKITESHIELD ";
    }
				 else if (sPLACE == "horviksshop")
    {
        sXML = "horviksshop.xml";
        sSCREEN = "RSHORVIKSHOP ";
    }
				 else if (sPLACE == "lowesshop")
    {
        sXML = "lowesarcheryshop.xml";
        sSCREEN = "RSLOWESSHOP ";
    }
				 else if (sPLACE == "zekeshop")
    {
        sXML = "rszekesscimitars.xml";
        sSCREEN = "RSZEKESHOP ";
    }
				 else if (sPLACE == "loiuseplates")
    {
        sXML = "rsloiuselegs.xml";
        sSCREEN = "RSLOIUSELEGS ";
    }
				 else if (sPLACE == "zaffsstaffsshop")
    {
        sXML = "rszaffsstaffs.xml";
        sSCREEN = "RSZAFFSSTAFFS ";
    }
				 else if (sPLACE == "thelessiashop")
    {
        sXML = "rsthelssiavarrock.xml";
        sSCREEN = "RSTHELESSIAVARROCK ";
    }
				 else if (sPLACE == "aubreyruneshop")
    {
        sXML = "rsruneshopaubrey.xml";
        sSCREEN = "RSAUBREYSHOP ";
    }
				 else if (sPLACE == "dommikshop")
    {
        sXML = "rsalkharidcrafting.xml";
        sSCREEN = "RSDOMMIKSSTORE ";
    }
				 else if (sPLACE == "wayneschainsshop")
    {
        sXML = "rsfaladorchainmail.xml";
        sSCREEN = "RSWAYNESCHAINSSHOP ";
    }
				 else if (sPLACE == "flynnsmacemarketshop")
    {
        sXML = "rsflynnsmacemarket.xml";
        sSCREEN = "RSFLYNNSMACEMARKETSHOP ";
    }
				 else if (sPLACE == "harquinsgemsshop")
    {
        sXML = "rsharquinsgems.xml";
        sSCREEN = "RSHARQUINSGEMSHOP ";
    }
				 else if (sPLACE == "bettysmagicshop")
    {
        sXML = "rsbettysmagicshop.xml";
        sSCREEN = "RSBETTYSMAGICSHOP ";
    }
				 else if (sPLACE == "alimorrisaneshop")
    {
        sXML = "rsalimorisaneshop.xml";
        sSCREEN = "RSALIMORRISANESHOP ";
    }
				 else if (sPLACE == "genericfoodstore")
    {
        sXML = "rsfoodstoregeneric.xml";
        sSCREEN = "RSFOODSTOREGENERIC ";
    }
				 else if (sPLACE == "gerrantfishshop")
    {
        sXML = "rsfishingportsarimstore.xml";
        sSCREEN = "RSFISHSTOREPORTSARIM ";
    }
				 else if (sPLACE == "harrysfishshop")
    {
        sXML = "rsharrysfishingshop.xml";
        sSCREEN = "RSHARRYSFISHSHOP ";
    }
				 else if (sPLACE == "herbloreshop")
    {
        sXML = "rsherbloreshop.xml";
        sSCREEN = "RSHERBLORESHOP ";
    }
				 else if (sPLACE == "grumsgoldexchange")
    {
        sXML = "rsjeweleryshopstore.xml";
        sSCREEN = "RSGRUMSGOLDEXCHANGEPORTSARIM";
    }
				 else if (sPLACE == "aemadadventurestore")
    {
        sXML = "gsaemadadventuresupplies.xml";
        sSCREEN = "RSADVENTURESUPPLIES";
    }
				 else if (sPLACE == "rsfarmingshopgenric")
    {
        sXML = "gsfarmingshopgeneric.xml";
        sSCREEN = "RSFARMINGSHOPGENRIC";
    }
				 else if (sPLACE == "rsrufusmeatshop")
    {
        sXML = "rsrufusmeatshop.xml";
        sSCREEN = "RSRUFUSMEATSHOP";
    }
				 else if (sPLACE == "nurmofspickaxesshop")
    {
        sXML = "rsnurmofspickaxes.xml";
        sSCREEN = "RSNURMOFSSHOP";
    }
				 else if (sPLACE == "drogominingshop")
    {
        sXML = "rsdrogominingshop.xml";
        sSCREEN = "RSDROGOMININGSHOP";
    }
				 else if (sPLACE == "shrimpandparrotshop")
    {
        sXML = "rstheshrimpandparrot.xml";
        sSCREEN = "RSSHRIMPANDPARROTSTORE";
    }
				 else if (sPLACE == "rstamayusspearsnew")
    {
        sXML = "rskaramjaspearstorenew.xml";
        sSCREEN = "RSKARAMJASPEARSTORE";
    }
				 else if (sPLACE == "gnomeglider")
    {
        sXML = "gnomeglidermenu.xml";
        sSCREEN = "GNOMEGLIDERMENU";
    }
				 else if (sPLACE == "spirittree")
    {
        sXML = "spirittreemenu.xml";
        sSCREEN = "SPIRITTREEMENU";
    }
					 else if (sPLACE == "legendsshop1")
    {
        sXML = "legendsshop1.xml";
        sSCREEN = "LEGENDSGUILDSHOP1";
    }
						 else if (sPLACE == "legendsshop2")
    {
        sXML = "legendsshop2.xml";
        sSCREEN = "LEGENDSGUILDSHOP2";
    }
						 else if (sPLACE == "elementalsmithing")
    {
        sXML = "qewsmithingmenu.xml";
        sSCREEN = "QEWSMITHINGMENU";
    }
						 else if (sPLACE == "tiadechestore")
    {
        sXML = "rstiadechestore.xml";
        sSCREEN = "RSKARAMJATIADECHESTORE";
    }
						 else if (sPLACE == "hecklefunchstore")
    {
        sXML = "hecklefunchstore.xml";
        sSCREEN = "HECKLEFUNCHSTORE";
    }	
						 else if (sPLACE == "bakerstallstore")
    {
        sXML = "bakerstall.xml";
        sSCREEN = "RSBAKERSTORE";
    }	
						 else if (sPLACE == "martinthwaitstore")
    {
        sXML = "martinthwaitsshop.xml";
        sSCREEN = "MARTINTHWIATSSHOP";
    }
						 else if (sPLACE == "magearenashop1")
    {
        sXML = "magearenashop1.xml";
        sSCREEN = "MAGEARENASHOP1";
    }
						 else if (sPLACE == "ruperthilljournal")
    {
        sXML = "ruperthilljournal.xml";
        sSCREEN = "RUPERTHILLJOURNAL";
    }		
						 else if (sPLACE == "tokkulshopsell01")
    {
        sXML = "tokkulshopsell01.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP_SELL_01";
    }
						 else if (sPLACE == "tokkulshopsell02")
    {
        sXML = "tokkulshopsell02.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP_SELL_02";
    }
						 else if (sPLACE == "tokkulshopsell03")
    {
        sXML = "tokkulshopsell03.xml";
        sSCREEN = "SCREEN_TOKKUL_SHOP_SELL_03";
    }
						 else if (sPLACE == "sigmundsstore")
    {
        sXML = "rssigmundsstore.xml";
        sSCREEN = "RSSIGMUNDSSTORE";
    }
						 else if (sPLACE == "skullgrimsstore")
    {
        sXML = "rsskullgrimsstore.xml";
        sSCREEN = "RSSKULLGRIMSSTORE";
    }
						 else if (sPLACE == "razmiresshop")
    {
        sXML = "rsrazmireshop.xml";
        sSCREEN = "RSRAZMIRESHOP";
    }
						 else if (sPLACE == "buildermerchantsshop")
    {
        sXML = "rsbuildermerchants.xml";
        sSCREEN = "RSBUILDERMERCHANTSSTORE";
    }
						 else if (sPLACE == "slayerpointstore")
    {
        sXML = "slayerpointshop.xml";
        sSCREEN = "SLAYERUNLOCKMENU";
    }
    else return;   
    object oPC = GetLastUsedBy();
    DisplayGuiScreen(oPC, sSCREEN, FALSE, sXML);
}