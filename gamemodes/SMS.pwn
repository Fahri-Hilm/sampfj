#define MAX_SMS (50)

enum smsData {
    bool:smsExists,
    smsType,
    smsPlayer,
    smsText[128 char]
};
new SmsData[MAX_PLAYERS][MAX_SMS][smsData];

/*
Sms_GetCount(playerid)
{
    new count;

    for (new i = 0; i != MAX_SMS; i ++)
    {
        if(SmsData[i][smsExists] && SmsData[i][smsPlayer] == playerid)
        {
			count++;
        }
    }
    return count;
}

Sms_Clear(playerid)
{
    for (new i = 0; i != MAX_SMS; i ++)
    {
        if(SmsData[i][smsExists] && SmsData[i][smsPlayer] == playerid)
        {
            Sms_Remove(i);
        }
    }
}*/
#include <YSI_Coding/y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_SMSS)
	{
		if(response)
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, SmsData[i][smsText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Pesan Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Pesan: "GREEN_E"%s\n"WHITE_E"Isi Pesan: "RED_E"%s.", pData[SmsData[playerid][i][smsPlayer]][pPhone], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	return 1;
}
Sms_Show(playerid)
{
	new mstr[320], lstr[320], gstr[320];
    for (new i = 0; i != MAX_SMS; i ++)
    {
        if(!SmsData[playerid][i][smsExists]) return Error(playerid, "Tidak ada pesan masuk");
		{
  			strunpack(mstr, SmsData[playerid][i][smsText]);

	        if(strlen(mstr) > 32)
	            format(lstr,sizeof(lstr), "#%d\t%s \t%.32s ...\n", i, pData[SmsData[playerid][i][smsPlayer]][pPhone], mstr);
	        else
	            format(lstr,sizeof(lstr), "#%d\t%s \t%s\n", i, pData[SmsData[playerid][i][smsPlayer]][pPhone], mstr);

	        strcat(gstr,lstr,sizeof(gstr));
	        ShowPlayerDialog(playerid, DIALOG_SMSS, DIALOG_STYLE_TABLIST_HEADERS,"sms's",gstr,"Next","Cancel");
		}
	}
	return 1;
}
Sms_Add(playerid, const text[])
{
    for (new i = 0; i != MAX_SMS; i ++)
    {
        if(!SmsData[playerid][i][smsExists])
        {
            SmsData[playerid][i][smsExists] = true;
            //SmsData[playerid][i][smsPlayer] = playerid;

            strpack(SmsData[playerid][i][smsText], text, 128 char);
            return i;
        }
    }
    return 1;
}
/*
Sms_Remove(reportid)
{
    if(reportid != -1 && SmsData[reportid][smsExists] == true)
    {
        SmsData[reportid][smsExists] = false;
        SmsData[reportid][smsPlayer] = INVALID_PLAYER_ID;
    }
    return 1;
}
*/

CMD:wa(playerid, params[])
{
    new reportid = -1;
	new ph, text[50];
	
	if(pData[playerid][pPhone] == 0) return Error(playerid, "Anda tidak memiliki Ponsel!");
	if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "Anda tidak memiliki Ponsel credits!");
	if(pData[playerid][pInjured] != 0) return Error(playerid, "You cant do at this time.");

	if(sscanf(params, "ds[50]", ph, text))
        return Usage(playerid, "/wa [phone number] [message max 50 text]");

	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][pPhoneStatus] == 0) return Error(playerid, "Tidak dapat SMS, Ponsel tersebut yang dituju sedang Offline");
			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");
            //new userid = pData[playerid][p];
			if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
			if(reportid == pData[ii][pPhone])
            //if(pData[ii][pWa] == INVALID_PLAYER_ID)
		    {
		        //pData[playerid][pWa] = ii
		        //pData[playerid[pWa] = ph;
		        Sms_Add(reportid, text);
		        Servers(playerid, "PESAN TERKIRIM");
		        SendClientMessageEx(playerid, COLOR_YELLOW, "Pesan Terkirim ke No %d", ph);
				SendClientMessageEx(ii, COLOR_YELLOW, "(%) Pesan Masuk dari No %d", reportid, pData[playerid][pPhone]);
		    }
		}
	}
    return 1;
}
CMD:walist(playerid, params[])
{
	Sms_Show(playerid);
	return 1;
}
