//Call any scripts for item activation here
void main()
{
    object oItem = GetItemActivated();
	SendMessageToPC(
	if(GetLocalInt(oItem, "healAmt") > 0)
	{
		ExecuteScript("foodHeal", oItem);
	}
	else
	{ 
 		ExecuteScript("itemconvo", oItem);
 	}
}