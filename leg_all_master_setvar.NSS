/*

    Script:			This script is used on conversation action nodes to set variables on a passed
					target.
	Version:		1.0
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		07/19/2015 - 1.00 MV - Initial Release
*/
// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(string sTarget, string sVar, string sValue, string sType)
{
	if (sType == "Int")
		SetLocalInt(GetObjectByTag(sTarget), sVar, StringToInt(sValue));
	else if (sType == "String")
		SetLocalString(GetObjectByTag(sTarget), sVar, sValue);
	else if (sType == "Float")
		SetLocalFloat(GetObjectByTag(sTarget), sVar, StringToFloat(sValue));


}