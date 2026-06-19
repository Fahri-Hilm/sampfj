CMD:washmoney(playerid, params[])
{
	new count;
    if(LoadingPlayerBar[playerid] >= 1) return Error(playerid, "Loading belum selesai!");
	if(pData[playerid][pRedMoney] < 1000)
	{
		return Error(playerid, "Kamu tidak memiliki uang merah.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2161.042480, -102.180000, 2.750000))
		return Error(playerid, "Kamu harus berada di penukaran uang.");
	{
 		foreach(new i:Player)
		{
			if(pData[i][pFaction] == 1)
			{
				count++;
			}
		}
		if(count >= 4)
		{
			if(pData[playerid][pFamily] == 6)
			{
			    pData[playerid][pActivity] = SetTimerEx("WashMoney", 4000, false, "d", playerid);
				ShowProgressbar(playerid, "Proses", 4);
			}
			else
			{
			    Error(playerid, "JACK : MR.G Tidak mengizinkan ku menerima transaksi dari orang lain.");
			}
		}
		else
		{
			Error(playerid, "Polisi kurang dari 4.");
		}
	}
	return 1;
}

CMD:prosesborax(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
	{
	    new count;
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
		if(pData[playerid][pBorax] < 12) return Error(playerid, "Anda Tidak Memiliki Borax!.");
	 	{
	 		foreach(new i:Player)
			{
				if(pData[i][pFaction] == 1)
				{
					count++;
				}
			}
			if(count > 2)
			{
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				
				pData[playerid][pGetBorax] = SetTimerEx("Borax", 5000, false, "id", playerid, 3);
				ShowProgressbar(playerid, "Proses", 5);
			}
			else
			{
				Error(playerid, "Polisi kurang dari 2.");
			}
		}
	}
	else return Error(playerid, "Anda tidak ditempat proses borax");
	return 1;
}

CMD:jualborax(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
        return Error(playerid, "You must in family to use this command!");
 	    
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1513.2206,21.2324,24.1406))
		return Error(playerid, "Anda harus di tempat penjualan borax");
	new count;
	if(pData[playerid][pPaketBorax] < 1)
		return Error(playerid, "Anda tidak memiliki paket Borax");
    {
 		foreach(new i:Player)
		{
			if(pData[i][pFaction] == 1)
			{
				count++;
			}
		}
		if(count > 4)
		{
			pData[playerid][pRedMoney] += 1000;
			pData[playerid][pPaketBorax] -= 1;
			SendClientMessage(playerid, COLOR_LBLUE, "INFO: "WHITE_E"Anda telah menjual Borax dan mendapatkan "GREEN_E"$1000");

		    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else
		{
			Error(playerid, "Polisi kurang dari 4.");
		}
	}
	return 1;
}


CMD:borax(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 10,-1079.7341,-973.8702,129.2188))
	{
	    if(pData[playerid][pBorax] >= 120) return Error(playerid, "Anda sudah membawa 120 borax!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
		
	    TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pGetBorax] = SetTimerEx("Borax", 5000, false, "id", playerid, 3);
		ShowProgressbar(playerid, "Cut", 5);
	}
	else return Error(playerid, "Anda tidak ditempat ladang borax");
	return 1;
}

function Borax(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	{
		{
			if(IsPlayerInRangeOfPoint(playerid, 10,-1079.7341,-973.8702,129.2188))
			{
			    if(pData[playerid][pBorax] <= 120)
				{
					Info(playerid, "Anda berhasil mengambil borax");
					pData[playerid][pBorax] +=1;
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
				}
				else
				{
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					return 1;
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
			{
				if(pData[playerid][pBorax] >= 10)
				{
					Info(playerid, "Anda berhasil memproses Borax");
					pData[playerid][pBorax] -=10;
					pData[playerid][pPaketBorax] +=1;
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
				}
				else
				{
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					return 1;
				}
			}
		}
	}
	return 1;
}

function WashMoney(playerid) {
	if(!IsPlayerConnected(playerid)) return 0;
	if(!pData[playerid][pRedMoney]) return 0;
	{
		new redmoney = pData[playerid][pRedMoney], total;
		total = redmoney / 3;
		GivePlayerMoney(playerid, total);
		Info(playerid, "Berhasil mencuci uang dan mendapatkan uang sebanyak %s", total);
		KillTimer(pData[playerid][pActivity]);
		ClearAnimations(playerid);
	}
	return 1;
}