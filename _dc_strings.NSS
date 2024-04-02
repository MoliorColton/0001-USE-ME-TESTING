/** @file
* @brief String related functions
*
*  push and pop They add or delete from the right side of an array (the last position). So, if you want to add an element to the end of an array, you would use the push function:
*  shift and unshift If you want to simply add or delete an element from the left side of an array (element zero), you can use the unshift and shift functions. To add an element to the left side, you would use the unshift function and write something like this:
*
* @ingroup DRKcore
* @author Brian T. Meyer and others
*/

  // DARK COMMENT: Unchanged. In use because useful.

/**
General purpose string library, as part of the Common Script Library.

Designed to allow multiple projects work together better in NWN2 and to make commonly used functions available which are rock solid.

Developed for personal use, but also I use it in supporting various community projects, and move all of their string related functions to this one spot.

Credits:
Seed and the Dungeon Eternal Previous admins, which this started from.
Lilac Soul
Jailiax - Spell casting framework
Nytir
Demetrious, Deva B. Winblood and others with the DMFI
Kaedrin
LadyDesire and the folks at the PRC
Numerous sample functions posts, as well as things taken from RealBasic, Javascript, PHP.
*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////




// alphabet sort constants, used to use case statements with strings
const int DRK_LETTER_NA  = -1; // not a letter
const int DRK_LETTER_A  = 1;
const int DRK_LETTER_B  = 2;
const int DRK_LETTER_C  = 3;
const int DRK_LETTER_D  = 4;
const int DRK_LETTER_E  = 5;
const int DRK_LETTER_F  = 6;
const int DRK_LETTER_G  = 7;
const int DRK_LETTER_H  = 8;
const int DRK_LETTER_I  = 9;
const int DRK_LETTER_J  = 10;
const int DRK_LETTER_K  = 11;
const int DRK_LETTER_L  = 12;
const int DRK_LETTER_M  = 13;
const int DRK_LETTER_N  = 14;
const int DRK_LETTER_O  = 15;
const int DRK_LETTER_P  = 16;
const int DRK_LETTER_Q  = 17;
const int DRK_LETTER_R  = 18;
const int DRK_LETTER_S  = 19;
const int DRK_LETTER_T  = 20;
const int DRK_LETTER_U  = 21;
const int DRK_LETTER_V  = 22;
const int DRK_LETTER_W  = 23;
const int DRK_LETTER_X  = 24;
const int DRK_LETTER_Y  = 25;
const int DRK_LETTER_Z  = 26;


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

const string DC_CHAR_BREAK = "\n";

const int DC_ASCIITYPE_INVALID = -1;
const int DC_ASCIITYPE_CONTROL = 0;
const int DC_ASCIITYPE_TAB = 1;
const int DC_ASCIITYPE_RETURN = 2;
const int DC_ASCIITYPE_SPACE = 3;
const int DC_ASCIITYPE_PUNCTUATION = 4;
const int DC_ASCIITYPE_QUOTE = 5;
const int DC_ASCIITYPE_SEPARATOR = 6;
const int DC_ASCIITYPE_EXTENDED = 7;
const int DC_ASCIITYPE_NUMBER = 8;
const int DC_ASCIITYPE_LOWERCASE = 9;
const int DC_ASCIITYPE_UPPERCASE = 10;


int StringCompare( string sString1, string sString2, int nCaseSensitive=FALSE );  //A simple C-Style string compare

/**
* Returns the number of delimited items in the given string, for use with Nth functions in a iterator
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @param iStart Position to start looking for delimiters
* @replaces XXXDRKListGetCount, DRKGetNthCount
* @return The total number of elements
*/
int DRKNth_GetCount( string sIn, string sDelimiter=",", int iStart = 0 )
{
    if ( sIn == "" )
    {
        return 0;
    }

    int iCount = 0;

    int iPosition = 0;
    iPosition = FindSubString( sIn, sDelimiter, iStart );
    if ( iPosition == -1 ) // no more to find
    {
        return 1; // delimiter not present, must be a single element
    }

    //iStart = iPosition+1;
    iCount = 1;

    while( iPosition > -1 )
    {
        iCount++;
        iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
        if ( iPosition == -1 ) // no more to find
        {
            return iCount;
        }
    }
    return iCount;
}


/**
* Returns the position that the Nth item starts at in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @param iStart Position to start looking for delimiters
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces DRKGetNthPosition
* @return
*/
int DRKNth_GetPosition( string sIn, int iOccurance = 1, string sDelimiter=",", int iStart = 0 )
{
    if ( iOccurance == 1 )
    {
        return iStart;
    }

    int iPosition = FindSubString( sIn, sDelimiter, iStart );
    if ( iPosition == -1 ) // no more to find
    {
        return -1;
    }
    //iStart = iPosition+1;
    iOccurance--;

    while( iOccurance > 1 )
    {
        iPosition = FindSubString( sIn, sDelimiter, iPosition+1 );
        if ( iPosition == -1 ) // no more to find
        {
            return -1;
        }
        //iStart = iPosition+1;
        iOccurance--;
    }
    return iPosition+1;
}

/**
* Returns the length of the Nth item in the given string using a comma or another provided parameter
*
* Use the DRKNth_GetPosition prior to get the iPosition Parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iPosition The starting position
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces XXXDRKGetNthLength
* @return Lenght of the Nth Item
*/
int DRKNth_GetElementLength( string sIn, int iPosition, string sDelimiter="," )
{
    //iPosition = DRKNth_GetPosition( sIn, iIndex, sDelimiter );
    int iNextPosition = FindSubString( sIn, sDelimiter, iPosition );

    if ( iNextPosition == -1 ) // no more delimters are present
    {
        iNextPosition = GetStringLength( sIn );
    }


    if ( iNextPosition >= iPosition ) // make sure it's result is 0 or higher
    {
        return iNextPosition-iPosition;
    }
    return 0;
}


/**
* Gets the Nth substring separated by commas, or the given delimiter, Nth is 1 based
* Example:
* GetWord("VFX_IMP_ACID", 3, "_"); // returns "ACID"
* GetWord("Dog,Cat,Frog", 2, ","); // returns "Cat"
* GetWord("Dog", 1, ","); // returns "Dog"
* GetWord("Dog", 2, ","); // returns ""
* GetWord("Hello, it's nice to see you again!", 5, " "); // returns "see"
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer and is reworked to match syntax for RealBasics NthString function, replaces DMFI similar function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index from which to get the value
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @replaces GetWord from the DMFI, JXStringSplit from jailiax, DRKListGetElement from Seed, DRKGetTokenByPosition from theatre system
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces XXXDRKGetNthString
* @return
*/
string DRKNth_GetNthElement(string sIn, int iOccurance, string sDelimiter=",")
{
    if ( GetStringLength( sDelimiter ) != 1 )
    {
        return "";
    }

    // no delimiters
    if ( FindSubString( sIn, sDelimiter ) == -1 )
    {
        if ( iOccurance == 1 )
        {
            return sIn;
        }
        else
        {
            return "";
        }
    }

    sIn = sIn+sDelimiter;

    int nNth = 0;
    int nLength = GetStringLength(sIn);
    string sSub;
    string sWord;
    int nCount=0;
    while (nNth < nLength)
    {
        sSub = GetSubString(sIn, nNth, 1);
        if (sSub==sDelimiter)
        {
            sWord = GetStringLeft(sIn, nNth);

            nCount++;
            if (nCount==iOccurance)
            {
                return sWord;
            }
            sIn = GetStringRight( sIn, nLength-(nNth+1) );

            nLength = GetStringLength(sIn);
            nNth = -1;
        }
        nNth++;
    }
    return "";
}

/**
* Gets the Nth substring separated by commas as an integer, or the given delimiter, Nth is 1 based
* used to replace GetIntParam which is 0 based, so add one to it
*/
int DRKNth_GetNthElementInt(string sIn, int iOccurance, string sDelimiter=",")
{
    return StringToInt( DRKNth_GetNthElement( sIn, iOccurance, sDelimiter) );
}

/**
* Gets the Nth substring separated by commas as an Float, or the given delimiter, Nth is 1 based
* used to replace GetIntParam which is 0 based, so add one to it
*/
float DRKNth_GetNthElementFloat(string sIn, int iOccurance, string sDelimiter=",")
{
    return StringToFloat( DRKNth_GetNthElement( sIn, iOccurance, sDelimiter) );
}

/**
* Returns a random Nth item in the given string using a comma or another provided parameter
* @author Brian Meyer based on RealBasics NthString function
* @replaces XXXDRKPickOneFromList, XXXDRKGetRandomtNthString
* @return
*/
string DRKNth_GetRandomElement(string sIn, string sDelimiter=",")
{
    if (sIn=="") // don't bother
    {
        return "";
    }
    int iOccurance = DRKNth_GetCount( sIn, sDelimiter );
    if ( iOccurance==1 ) // don't bother
    {
        return sIn;
    }
    return DRKNth_GetNthElement( sIn, Random(iOccurance), sDelimiter );
}


/**
* Removes the Nth item in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces XXXDRKGetNthRemove
* @todo Need to do QA checks, see if they compile and if they remove things as advertised
* @return
*/
string DRKNth_RemoveElement(string sIn, int iOccurance, string sDelimiter=",")
{
    if ( FindSubString( sIn, sDelimiter ) == -1 ) // only one element since no delimiters, very easy to change it
    {
        if ( iOccurance == 1 )
        {
            return "";
        }
        else
        {
            return sIn;
        }
    }

    int iPosition = DRKNth_GetPosition( sIn, iOccurance, sDelimiter );
    int iLength = DRKNth_GetElementLength( sIn, iPosition, sDelimiter );
    int iTotalLength = GetStringLength(sIn);

    // try to just do one string concatanation since the string involved could be larger
    if ( iOccurance == 1 ) // first element
    {
        return GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
    }
    else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
    {
        return GetStringLeft(sIn, iPosition-1);
    }
    // else in the middle
    return GetStringLeft(sIn, iPosition-1) + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
}



/**
* Replaces the Nth item in the given string using a comma or another provided parameter
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sIn The delimited string from which the value will be extracted
* @param sReplace The string to replace the string found at the given occurance
* @param iOccurance One based index to determine which element gets removed
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces XXXDRKGetNthReplace
* @todo Need to do QA checks, see if they compile and if they replace things as advertised
* @return
*/
string DRKNth_ReplaceElement(string sIn, string sReplace, int iOccurance, string sDelimiter=",")
{
    if ( FindSubString( sIn, sDelimiter ) == -1 ) // only one element since no delimiters, very easy to change it
    {
        if ( iOccurance == 1 )
        {
            return sReplace;
        }
        else
        {
            return sIn;
        }
    }

    int iPosition = DRKNth_GetPosition( sIn, iOccurance, sDelimiter );
    int iLength = DRKNth_GetElementLength( sIn, iPosition, sDelimiter );
    int iTotalLength = GetStringLength(sIn);

    // try to just do one string concatanation since the string involved could be larger
    if ( iOccurance == 1 ) // first element
    {
        return sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
    }
    else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
    {
        return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace;
    }
    // else in the middle
    return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
}

// finds position of first occurance of said string
int DRKNth_Find(string sArray, string sValue, string sDelimiter="," )
{
    if ( sArray == "" )
    {
        return -1;
    }

    int iPosition = FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sValue+sDelimiter );
    if ( iPosition == -1)
    {
        return -1;
    }
    sArray = GetStringLeft(sArray, iPosition-1);
    return DRKNth_GetCount(sArray,sDelimiter)+1;
}

// finds and replaces a single element in the array
string DRKNth_Replace(string sArray, string sNeedle, string sReplace, string sDelimiter="," )
{
    if ( sArray == "" )
    {
        return "";
    }

    int iPosition = FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNeedle+sDelimiter );
    if ( iPosition == -1)
    {
        return sArray;
    }
    //sArray = GetStringLeft(sArray, iPosition-1);
    //return DRKNth_GetCount(sArray,sDelimiter)+1;
    int iLength = GetStringLength(sNeedle);
    int iTotalLength = GetStringLength(sArray);
    if ( sReplace == "" )
    {
        return GetStringLeft(sArray, iPosition-1) + sDelimiter + GetStringRight(sArray, iTotalLength-iLength-iPosition-1);
    }
    string sReturn = GetStringLeft(sArray, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sArray, iTotalLength-iLength-iPosition-1);
    if(sReturn == sDelimiter)
     sReturn = "";
    return sReturn;

    /*
    int iPosition = DRKNth_GetPosition( sIn, iOccurance, sDelimiter );
    int iLength = DRKNth_GetElementLength( sIn, iPosition, sDelimiter );
    int iTotalLength = GetStringLength(sIn);

    // try to just do one string concatanation since the string involved could be larger
    if ( iOccurance == 1 ) // first element
    {
        return sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
    }
    else if ( ( iPosition + iLength ) >= iTotalLength ) // last element
    {
        return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace;
    }
    // else in the middle
    return GetStringLeft(sIn, iPosition-1) + sDelimiter + sReplace + sDelimiter + GetStringRight(sIn, iTotalLength-iLength-iPosition-1);
    */

}

/**
* Appends sNew to the end of the given Nth array string using a comma or another provided parameter if it's not the only item
*
* This is the Nth Function Pseudo array that uses a simple delmited string as if it was an array, but is also useful for parsing other raw data as well. This is one of the Pseudo Array Systems, with DRKStringArray, Nth functions for simple strings, and DataObjects.
* @author Brian Meyer based on RealBasics NthString function
* @param sArray The delimited string from which the value will be appended
* @param sNew The string to append to the end of the string
* @param sDelimiter Default delmiter is a comma, but can be changed as usage requires
* @see DRKNth_GetNthElement
* @see DRKNth_GetCount
* @see DRKNth_GetElementLength
* @see DRKNth_GetPosition
* @replaces XXXDRKNthPush
* @todo Need to do QA checks, see if they compile and if they replace things as advertised
* @return a new Array
*/
string DRKNth_Push(string sArray, string sNew, string sDelimiter=",", int bUnique = FALSE )
{
    if ( sArray == "" )
    {
        return sNew;
    }

    if ( bUnique == TRUE && FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNew+sDelimiter ) != -1 )
    {
        return sArray;
    }

    return sArray+sDelimiter+sNew;
}

/**
* Joins two arrays together, appending any unique elements from the second array to the first array.
*/
string DRKNth_JoinUnique( string sArray, string sNew, string sDelimiter=","  )
{
    if ( sArray == "" )
    {
        return sNew;
    }

    if ( sNew != "" ) // nothing to do, lets just end this
    {
        string sNewItem;

        int iNewArrayCount = DRKNth_GetCount( sNew, sDelimiter );
        int i;
        for ( i=1; i <= iNewArrayCount; i++ )
        {
            sNewItem = DRKNth_GetNthElement(sNew, i, sDelimiter);
            if ( FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNewItem+sDelimiter ) == -1 )
            {
                sArray += sDelimiter+sNewItem;
            }
        }
    }
    ///SendMessageToPC(GetFirstPC(), sArray+" merging with "+sNew+" = "+sArray);
    return sArray;
}

/**
* Adds an item to the front of an array
* @replaces XXXDRKNthUnShift
*/
string DRKNth_UnShift(string sArray, string sNew, string sDelimiter=",", int bUnique = FALSE )
{
    if ( sArray == "" )
    {
        return sNew;
    }

    if ( bUnique == TRUE && FindSubString( sDelimiter+sArray+sDelimiter, sDelimiter+sNew+sDelimiter ) != -1 )
    {
        return sArray;
    }

    return sNew+sDelimiter+sArray;
}




/************************************************************/
/** @name String_Reordering functions
* Description
********************************************************* @{ */

/**
* Randomly sorts the letters in the string
* @param sIn Input String
* @return
*/
string DRKStringShuffle ( string sIn )
{
    if (sIn == "")
    {
        return "";
    }

    string sOut = "";
    int iRand = 0;

    while ( GetStringLength( sIn ) )
    {
        iRand = Random( GetStringLength( sIn ) );
        sOut += GetSubString( sIn, iRand, 1);

        sIn =  GetStringLeft( sIn, iRand )+ GetStringRight( sIn, GetStringLength( sIn )-(iRand+1) );
    }

    return sOut;
}

/**
* Reverses the letters in the string
* @param sIn Input String
* @return
*/
string DRKStringReverse( string sIn )
{
    string sOut = "";
    int iCounter;

    for ( iCounter = GetStringLength( sIn ); iCounter >= 0; iCounter-- )
    {
       sOut += GetSubString(sIn, iCounter, 1);
    }

    return sOut;
}

//@}

/************************************************************/
/** @name Random String functions
* Description
********************************************************* @{ */

/**
* Description
* @author
* @param
* @see
* @return
*/
string DRKPickOne(string s1="", string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="")
{
    int i=(s1!="")+(s2!="")+(s3!="")+(s4!="")+(s5!="")+(s6!="")+(s7!="")+(s8!="")+(s9!=""); // count strings not null
    i=Random(i)+1;
    if (i==1) return s1;
    if (i==2) return s2;
    if (i==3) return s3;
    if (i==4) return s4;
    if (i==5) return s5;
    if (i==6) return s6;
    if (i==7) return s7;
    if (i==8) return s8;
    if (i==9) return s9;
    return "";
}


/**
* Description
* @author
* @param
* @see
* @return
*/
string DRKRandomLetter(string sAlpha="abcdefghijklmnopqrstuvwxyz")
{
    return GetSubString(sAlpha, Random(GetStringLength(sAlpha)), 1);
}