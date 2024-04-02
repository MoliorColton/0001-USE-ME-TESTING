// kinc_spirit_essence
//
// Functions for the manipulation and checking of spirit essences

// EPF 5/30/07

const string SPIRIT_ESSENCE_PREFIX = "nx1_cft_ess_spirit";
const string ESSENCE_PREFIX = "nx1_cft_ess_";

// returns TRUE if oItem is a spirit essence.
int GetIsValidSpiritEssence(object oItem)
{
    string sTag = GetTag(oItem);
    string sSuffix;
    int nPrefixLength = GetStringLength(SPIRIT_ESSENCE_PREFIX);
    int nLength = GetStringLength(sTag);
    
    if(GetIsObjectValid(oItem))
    {
        //check spirit essences
        if(GetStringLeft(sTag,nPrefixLength) == SPIRIT_ESSENCE_PREFIX)
        {
            return TRUE;
        }
        
        //check special essences
        nPrefixLength = GetStringLength(ESSENCE_PREFIX);
        if(GetStringLeft(sTag, nPrefixLength) == ESSENCE_PREFIX)
        {
            sSuffix = GetStringRight(sTag, nLength-nPrefixLength);
			            
           return (sSuffix == "araman" || 
					sSuffix == "founder" ||
					sSuffix == "gann"	||
					sSuffix == "dove"	||
					sSuffix == "oneofmany" || 
					sSuffix == "okku"	||
					sSuffix == "safiya" ||
					sSuffix == "shapeoffire" ||
					sSuffix == "woodman" ||
					sSuffix == "doorkeeper" ||			
					sSuffix == "gulkaush" ||
                    sSuffix == "coven" ||
                    sSuffix == "ujuk" ||
                    sSuffix == "gnarlthorn" ||
                    sSuffix == "shadowvoid" ||
                    sSuffix == "myrkul");
        }
        
    }
    
    return FALSE;
}