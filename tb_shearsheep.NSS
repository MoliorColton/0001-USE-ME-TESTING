#include "tb_animpc"

const int SHEAR_ANIM = 24;
const float SHEAR_TIME = 2.0;
object oSheep;

void ShearSheep();
void StartShearing(object _oPC, object _oSheep)
{
oPC = _oPC;
oSheep = _oSheep;
if (GetLocalInt(oSheep, "sheared") == 1) 
{
	SendMessageToPC(oPC, "<color=white>" + "That sheep has already been sheared.");
	return;
}
if (GetLocalInt(oPC, "isshearing") == 1) //already firing
{
	return;
}
	animtime = 2.0;
	TBPlayCustomAnimation(oPC, SHEAR_ANIM, 1);
	SetLocalInt(oPC, "isshearing", 1);
	DelayCommand(SHEAR_TIME, ShearSheep());
}

void ShearSheep()
{
	DeleteLocalInt(oPC, "isshearing");
	int nRoll = Random(2);
	if (nRoll == 1)
	{	
		CreateItemOnObject("ballofwool", oPC, 1); 
		SetLocalInt(oSheep, "sheared", 1);
		DelayCommand(5.0, SetLocalInt(oSheep, "sheared", 0));
	}else
	{
		//Sheep should run from you..  AssignCommand(oSheep, ActionMoveAwayFromObject(oPC, 0, 10.0));
		SendMessageToPC(oPC, "<color=white>" + "The sheep slips away from you.");
	}
}