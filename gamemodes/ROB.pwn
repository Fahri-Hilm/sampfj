function Robb(playerid)
{
	    	InfoTD_MSG(playerid, 8000, "Robbing done!");
	    	TogglePlayerControllable(playerid, 1);
	    	
			
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pEnergy] -= 15;
			pData[playerid][pRobSystem] = 0;
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
	    	InRob[playerid] = 0;
	    	GiveMoneyRob(playerid, 1, 28500);
	    	SetPVarInt(playerid, "Robb", gettime() + 3600);
			return 1;
}

CMD:robbery(playerid, params[])
{
    new id = -1;
	id = GetClosestATM(playerid);
	new bid = -1;
	bid = GetClosestBiz(playerid);
	new Float:x, Float:y, Float:z, String[100];
	GetPlayerPos(playerid, x, y, z);
	
	if(pData[playerid][pLevel] < 10)
			return Error(playerid, "You must level 10 to use this!");

	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "USAGE: /robbery [name]");
            Info(playerid, "Names: atm, biz, bank");
            return 1;
        }
		if(strcmp(params,"biz",true) == 0)
		{
            if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return Error(playerid, "You Need Shotgun.");
                 
                if(pData[playerid][pFamily] <= 0) return Error(playerid, "You Must Join Family!");
				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bisnis Pliss Admin Spec", pData[playerid][pName]);
				foreach(new i : Player)
				{
					if(pData[i][pPhone] == bData[pData[playerid][pInBiz]][bPh])
					{
						SCM(i, COLOR_RED, "[WARNING]"WHITE_E" Alarm Berbunyi Di bisnis anda!");
					}
				}
                SendFactionMessage(1, COLOR_RED, "**[Warning]{FFFFFF} Alarm Berbunyi Di bisnis [LOCATION: %s, BIZ ID: %d]", GetLocation(x, y, z), bid);
				
				pData[playerid][pActivity] = SetTimerEx("Robb", 8000, false, "i", playerid);
				pData[playerid][pRobSystem] = 1;
    			
				ShowProgressbar(playerid, "Robbing", 8);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
		else if(strcmp(params,"atm",true) == 0)
		{
			if(id > -1)
			{
				if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_BAT) return Error(playerid, "You Need baseball.");
                if(pData[playerid][pFamily] <= 0) return Error(playerid, "You Must Join Family!");
				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Atm Pliss Admin Spec", pData[playerid][pName]);
				SendFactionMessage(playerid, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Pembobolan Atm di [Location: %s, ATMID: %d]", GetLocation(x, y, z), id);
				SendFactionMessage(playerid, COLOR_RED, String);

				pData[playerid][pActivity] = SetTimerEx("Robb", 8000, false, "i", playerid);
				pData[playerid][pRobSystem] = 1;
    			
				ShowProgressbar(playerid, "Robbing", 8);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid,"SWORD", "sword_4", 4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
		}
		if(strcmp(params,"bank",true) == 0)
		{
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 997.4766,-1457.2667,13.8060))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return Error(playerid, "You Need Shotgun.");
                if(pData[playerid][pFamily] <= 0) return Error(playerid, "You Must Join Family!");

				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bank Pliss Admin Spec", pData[playerid][pName]);
				
                SendFactionMessage(playerid, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan diBank!");
                SendClientMessageToAll(COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan Di Bank Harap Menjauh!");

				pData[playerid][pActivity] = SetTimerEx("Robb", 8000, false, "i", playerid);
				pData[playerid][pRobSystem] = 1;
				Server_MinMoney(1000000);

				ShowProgressbar(playerid, "Robbing", 8);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
	}
	return 1;
}
