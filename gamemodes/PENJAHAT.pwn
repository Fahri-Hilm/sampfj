CMD:bad(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
        return Error(playerid, "Kamu Gak punya akses .");
    //if(LoadingPlayerBar[playerid] >= 1) return Error(playerid, "Loading belum selesai!");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/bad [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");
	pData[playerid][pGeledah] = otherid;
	//format(string, sizeof(string), "Jus Jeruk (%d)\nEs Susu (%d)\nNasi Bungkus(%d)\nSiomay(%d)\nSprunk\nSnack", pData[playerid][pSmineral], pData[playerid][pSayam], pData[playerid][pSnasi], pData[playerid][pSburger]);
	ShowPlayerDialog(playerid, DIALOG_PENJAHAT, DIALOG_STYLE_LIST, "PEDAGANG", "Memborgol \nMelepas Borgol \nMemasukan/Mengularkan dari kendaraan \nGeledah", "Pilih", "Batal");
    return 1;
}

#include <YSI_Coding/y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PENJAHAT)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
			    new otherid = pData[playerid][pGeledah];
			    if(otherid == INVALID_PLAYER_ID)
					return Error(playerid, "That player is disconnected.");

				if(otherid == playerid)
					return Error(playerid, "You cannot handcuff yourself.");

				if(!NearPlayer(playerid, otherid, 5.0))
					return Error(playerid, "You must be near this player.");

				if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
					return Error(playerid, "The player must be onfoot before you can cuff them.");

				if(pData[otherid][pCuffed])
					return Error(playerid, "The player is already cuffed at the moment.");

				pData[otherid][pCuffed] = 1;
				SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);
				//TogglePlayerControllable(otherid, 0);

				new mstr[128];
				format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", ReturnName(playerid));
				InfoTD_MSG(otherid, 3500, mstr);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s Telah memborgol %s.", ReturnName(playerid), ReturnName(otherid));
			}
			case 1:
			{
			    new otherid = pData[playerid][pGeledah];
			    if(otherid == INVALID_PLAYER_ID)
					return Error(playerid, "That player is disconnected.");

				if(otherid == playerid)
					return Error(playerid, "You cannot uncuff yourself.");

				if(!NearPlayer(playerid, otherid, 5.0))
					return Error(playerid, "You must be near this player.");

				if(!pData[otherid][pCuffed])
					return Error(playerid, "The player is not cuffed at the moment.");

				static
					string[64];

				pData[otherid][pCuffed] = 0;
				SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
				TogglePlayerControllable(otherid, true);

				format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", ReturnName(playerid));
				InfoTD_MSG(otherid, 3500, string);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s Telah membuka borgol %s.", ReturnName(playerid), ReturnName(otherid));
			}
			case 2:
			{
			    new otherid = pData[playerid][pGeledah];
   				new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false);
			    if(otherid == INVALID_PLAYER_ID)
			        return Error(playerid, "That player is disconnected.");

			    if(otherid == playerid)
			        return Error(playerid, "You cannot detained yourself.");

			    if(!NearPlayer(playerid, otherid, 5.0))
			        return Error(playerid, "You must be near this player.");

			    if(!pData[otherid][pCuffed])
			        return Error(playerid, "The player is not cuffed at the moment.");

			    if(vehicleid == INVALID_VEHICLE_ID)
			        return Error(playerid, "You are not near any vehicle.");

			    if(GetVehicleMaxSeats(vehicleid) < 2)
			        return Error(playerid, "You can't detain that player in this vehicle.");

			    if(IsPlayerInVehicle(otherid, vehicleid))
			    {
			        TogglePlayerControllable(otherid, 1);

			        RemoveFromVehicle(otherid);
			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and pulls %s out the vehicle.", ReturnName(playerid), ReturnName(otherid));
			    }
			    else
			    {
			        new seatid = GetAvailableSeat(vehicleid, 2);

			        if(seatid == -1)
			            return Error(playerid, "There are no more seats remaining.");

			        new
			            string[64];

			        format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid));
			        TogglePlayerControllable(otherid, 0);

			        //StopDragging(otherid);
			        PutPlayerInVehicle(otherid, vehicleid, seatid);

			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and places %s into the vehicle.", ReturnName(playerid), ReturnName(otherid));
			        InfoTD_MSG(otherid, 3500, string);
			    }
			}
			case 3:
			{
			    new otherid = pData[playerid][pGeledah];
   				if(pData[playerid][pFamily] == -1)
			        return Error(playerid, "Kamu Gak punya akses .");
				{
				    new string[320];
					format(string, sizeof(string), "Jus Jeruk (%d)\nEs Susu (%d)\nNasi Bungkus(%d)\nSiomay(%d)\nSprunk(%d)\nSnack(%d)\nBandage(%d)\n"RED_E"Borax(%d)\n"RED_E"Paket Borax(%d)\n"RED_E"Marijuana(%d)\n"RED_E"Uang Merah(%d)",
					pData[otherid][pMineral],
				 	pData[otherid][pAyam],
				 	pData[otherid][pNasi],
				 	pData[otherid][pBurger],
				 	pData[otherid][pSprunk],
				 	pData[otherid][pSnack],
				 	pData[otherid][pBandage],
				 	pData[otherid][pBorax],
				 	pData[otherid][pPaketBorax],
				 	pData[otherid][pMarijuana],
				 	pData[otherid][pRedMoney]);
					ShowPlayerDialog(playerid, DIALOG_RAMPAS, DIALOG_STYLE_LIST, "PEDAGANG", string, "Pilih", "Batal");
				    return 1;
				}
			}
		}
	}
    if(dialogid == DIALOG_RAMPAS)
	{
		if(response)
		{
		    switch(listitem)
			{
				case 0:
				{
				    new otherid = pData[playerid][pGeledah];
				    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILJUS, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 1:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILSUSU, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 2:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILNASI, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 3:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILSIOMAY, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 4:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILSPRUNK, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 5:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILSNACK, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 6:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILBANDAGE, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 7:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILBORAX, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 8:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILPABOR, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 9:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILMARI, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
				case 10:
				{
				    new otherid = pData[playerid][pGeledah];
					if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        				return Error(playerid, "Player tidak berada didekat mu.");
					{
						ShowPlayerDialog(playerid, DIALOG_AMBILREDMO, DIALOG_STYLE_INPUT, ""RED_E"RAMPAS", "Masukan jumlah:", "ambil", "Cancel");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_AMBILJUS)
	{
        new otherid = pData[playerid][pGeledah];
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 3.0))
        	return Error(playerid, "Player tidak berada didekat mu.");
		if(amount > pData[otherid][pMineral]) return Error(playerid, " jus jeruk dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		
		
		pData[otherid][pMineral] -= amount;
		pData[playerid][pMineral] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILSUSU)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pAyam]) return Error(playerid, " Es Susu dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pAyam] -= amount;
		pData[playerid][pAyam] += amount;
		Info(otherid, "%s telah  merampas Es Susu anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Es susu sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILNASI)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pNasi]) return Error(playerid, " snack dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pNasi] -= amount;
		pData[playerid][pNasi] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILSIOMAY)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pBurger]) return Error(playerid, " sprunk dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pBurger] -= amount;
		pData[playerid][pBurger] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILSNACK)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pSnack]) return Error(playerid, " Es Teh dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pSnack] -= amount;
		pData[playerid][pSnack] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILSPRUNK)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pSprunk]) return Error(playerid, " Jus Jeruk dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pSprunk] -= amount;
		pData[playerid][pSprunk] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILBANDAGE)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pBandage]) return Error(playerid, " sprunk dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pBandage] -= amount;
		pData[playerid][pBandage] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILBORAX)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pBorax]) return Error(playerid, " Nasi Padang dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pBorax] -= amount;
		pData[playerid][pBorax] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILPABOR)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pPaketBorax]) return Error(playerid, " nasi kucing dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pPaketBorax] -= amount;
		pData[playerid][pPaketBorax] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILMARI)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pMarijuana]) return Error(playerid, " Es Teh dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pMarijuana] -= amount;
		pData[playerid][pMarijuana] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	if(dialogid == DIALOG_AMBILREDMO)
	{
	    if(!response) return true;
		new  amount = floatround(strval(inputtext));
		new otherid = pData[playerid][pGeledah];
		if(amount > pData[otherid][pRedMoney]) return Error(playerid, " Jus Jeruk dia kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		

		pData[otherid][pRedMoney] -= amount;
		pData[playerid][pRedMoney] += amount;
		Info(otherid, "%s telah  merampas Jus Jeruk anda sejumlah %d.", ReturnName(playerid), pData[playerid][pSend]);
		Info(playerid, "Anda telah berhasil Jus Jeruk sprunk %s sejumlah %d.", ReturnName(otherid), pData[playerid][pSend]);
		ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	return 1;
}
