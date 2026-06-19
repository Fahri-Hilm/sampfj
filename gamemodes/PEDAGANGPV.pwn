CMD:siapin(playerid, params[])
{
    if(pData[playerid][pFaction] != 5)
        return Error(playerid, "Anda Bukan Pedagang.");
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1183.622070, -891.751525, 43.295574))
	{
	    ShowPlayerDialog(playerid, MENU_PED, DIALOG_STYLE_LIST, "Menu Pedagang", "Es Susu\nJus Jeruk\nNasi Bungkus\nSiomay", "bikin", "Jangan");
	    return 1;
	}
	else
	{
 		SendClientMessage(playerid,COLOR_RED,"[WARNING] Kamu tidak ada di dapur!");
	}
	return 1;
}

stock HideProgressBarV(playerid)
{
    for(new i = 0; i < 7; i++)
	{
		PlayerTextDrawDestroy(playerid, PROGRESSBAR[playerid][i]);
	}
}

stock UpdateLoading(playerid)
{
	new Float:Value = LoadingPlayerBar[playerid]*101.0/100;
	PlayerTextDrawTextSize(playerid, PROGRESSBAR[playerid][1], Value, 23.4);
	PlayerTextDrawShow(playerid, PROGRESSBAR[playerid][1]);
	return 1;
}

CMD:spawnpg(playerid, params[])
{
    // Pedagang Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 1185.0110, -885.9691, 43.1506))
	{
		if(pData[playerid][pFaction] != 5)
	        return Error(playerid, "You must be at pedagang officer faction!.");

		if(pData[playerid][pSpawnPg] == 1) return Error(playerid,"Anda sudah mengeluarkan 1 kendaraan.!");

	    new Zan[10000], String[10000];
	    strcat(Zan, "Vehicles Name\tType\n");
		format(String, sizeof(String), "Pedagang\tCars\n");// 596
		strcat(Zan, String);
		format(String, sizeof(String), "Pizza Boys\tCars\n");// 597
		strcat(Zan, String);/*
		format(String, sizeof(String), "Helicopter\tCars\n");// 598
		strcat(Zann, String);
		format(String, sizeof(String), "Helicopter 2\tCars\n"); // 599
		strcat(Zann, String);
		format(String, sizeof(String), "Premier\tSport Cars\n"); // 599
		strcat(Zann, String);*/
		ShowPlayerDialog(playerid,DIALOG_PEDAGANG_GARAGE, DIALOG_STYLE_TABLIST_HEADERS,"Static Vehicles Pedagang", Zan, "Spawn","Cancel");
	}
	return 1;
}

// STATISTIC VEHICLE SAMD //
#include <YSI_Coding/y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PEDAGANG_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1185.0110, -885.9691, 43.1506))
				{
					PDGVeh[playerid] = CreateVehicle(423, 1179.4480, -876.8039, 43.4117, 99.9119, 0, 1, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned PEDAGANG Vehicles '"YELLOW_E"/despawnpg"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1185.0110, -885.9691, 43.1506))
				{
					PDGVeh[playerid] = CreateVehicle(448, 1179.4480, -876.8039, 43.4117, 99.9119, 0, 3, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned PEDAGANG Vehicles '"YELLOW_E"/despawnpg"WHITE_E"' to despawn vehicles");
			}/*
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(563, 1162.8176, -1313.8239, 32.2215, 270.7216, 0, 1,120000, 0);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(487, 1162.8176, -1313.8239, 32.2215, 270.7216,0,1,120000,0);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 4:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(426, 1120.0265, -1317.1208, 13.8679, 271.4225,0,1,120000,0);
					AddVehicleComponent(SAMDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}*/
		}
		pData[playerid][pSpawnPg] = 1;
		PutPlayerInVehicle(playerid, PDGVeh[playerid], 0);
	}
    return 1;
}

function JusJembut(playerid) {
	if(!IsPlayerConnected(playerid)) return 0;
	{
		pData[playerid][pSmineral] += 20;
		Info(playerid, "Anda telah membuat jus jembut sebanyak 20");
		KillTimer(pData[playerid][pActivity]);
		ClearAnimations(playerid);
	}
	return 1;
}

function AyanTiren(playerid) {
	if(!IsPlayerConnected(playerid)) return 0;
	{
		pData[playerid][pSayam] += 20;
		Info(playerid, "Anda telah membuat ayam tiren sebanyak 20");
		KillTimer(pData[playerid][pActivity]);
		ClearAnimations(playerid);
	}
	return 1;
}

function NasiBasi(playerid) {
	if(!IsPlayerConnected(playerid)) return 0;
	{
		pData[playerid][pSnasi] += 20;
		Info(playerid, "Anda telah membuat nasi basi sebanyak 20");
		KillTimer(pData[playerid][pActivity]);
		ClearAnimations(playerid);
	}
	return 1;
}

function BurgerPig(playerid) {
	if(!IsPlayerConnected(playerid)) return 0;
	{
		pData[playerid][pSburger] += 20;
		Info(playerid, "Anda telah membuat burger daging babi sebanyak 20");
		KillTimer(pData[playerid][pActivity]);
		ClearAnimations(playerid);
	}
	return 1;
}