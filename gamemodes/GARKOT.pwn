// ============================================================
// GARKOT.pwn — Garasi Umum / Garasi Kota (Public Parking)
// ------------------------------------------------------------
// Titik parkir publik. Pemain menekan [Y] di titik park untuk
// menyimpan (Store) atau mengambil (Take) kendaraan pribadinya.
//
// Berbeda dari GARAGE.pwn (garasi pribadi yang dibeli).
// Penanda kendaraan tersimpan di titik umum: pvData[veh][cParkPoint] = parkid.
// (garasi pribadi memakai cGaraged — keduanya terpisah, tidak bentrok)
//
// Command admin: /createpark /setparkpos /removepark /gotopark /parkhelp
// ============================================================

// ParkVeh
#define MAX_PARKPOINT 300

enum    E_PARK
{
	// loaded from db
	Float: parkX,
	Float: parkY,
	Float: parkZ,
	parkInt,
	parkWorld,
	// temp
	bool: parkExists,
	parkPickup,
	Text3D: parkLabel
}

new ppData[MAX_PARKPOINT][E_PARK],
	Iterator:Parks<MAX_PARKPOINT>;

GetNearbyGarage(playerid)
{
	for(new i = 0; i < MAX_PARKPOINT; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, ppData[i][parkX], ppData[i][parkY], ppData[i][parkZ]))
	    {
	        return i;
	    }
	}
	return -1;
}

GetClosestParks(playerid, Float: range = 4.3)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Parks)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, ppData[i][parkX], ppData[i][parkY], ppData[i][parkZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist && GetPlayerInterior(playerid) == ppData[i][parkInt] && GetPlayerVirtualWorld(playerid) == ppData[i][parkWorld])
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

ReturnAnyPark(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_PARKPOINT) return -1;
	foreach(new id : Parks)
	{
		tmpcount++;
		if(tmpcount == slot)
		{
			return id;
		}
	}
	return -1;
}

GetAnyPark()
{
	new tmpcount;
	foreach(new id : Parks)
	{
		tmpcount++;
	}
	return tmpcount;
}

// Buat/segarkan pickup + label 3D sebuah titik park (tiru Garage_Refresh)
Park_Refresh(id)
{
	if(id == -1 || !ppData[id][parkExists])
		return 0;

	if(IsValidDynamicPickup(ppData[id][parkPickup]))
		DestroyDynamicPickup(ppData[id][parkPickup]);

	if(IsValidDynamic3DTextLabel(ppData[id][parkLabel]))
		DestroyDynamic3DTextLabel(ppData[id][parkLabel]);

	new str[160];
	format(str, sizeof(str), "[Garasi Umum - ID: %d]\n"AQUA"%s"YELLOW_E"\nTekan [Y] untuk Simpan/Ambil Kendaraan",
		id, GetLocation(ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ]));

	ppData[id][parkPickup] = CreateDynamicPickup(19134, 23, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ], ppData[id][parkWorld], ppData[id][parkInt]);
	ppData[id][parkLabel] = CreateDynamic3DTextLabel(str, ARWIN, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ] + 0.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ppData[id][parkWorld], ppData[id][parkInt], -1, 10.0);
	return 1;
}

function LoadPark()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0;
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", ppData[id][parkX]);
			cache_get_value_name_float(i, "posy", ppData[id][parkY]);
			cache_get_value_name_float(i, "posz", ppData[id][parkZ]);
			cache_get_value_name_int(i, "interior", ppData[id][parkInt]);
			cache_get_value_name_int(i, "world", ppData[id][parkWorld]);
			ppData[id][parkExists] = true;
			Iter_Add(Parks, id);
			Park_Refresh(id);
	    	i++;
		}
		printf("[Dynamic Park Point] Number of Loaded: %d.", i);
	}
}

Park_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE parks SET posx='%f', posy='%f', posz='%f', interior=%d, world=%d WHERE id=%d",
	ppData[id][parkX],
	ppData[id][parkY],
	ppData[id][parkZ],
	ppData[id][parkInt],
	ppData[id][parkWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

// Tampilkan daftar kendaraan pemain yang tersimpan di titik park ini -> DIALOG_PARKTAKE
ShowParkedVehicle(playerid, parkid)
{
	new bool:found = false, msg[5120];
	format(msg, sizeof(msg), "Model\tPlat\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cParkPoint] == parkid && pvData[i][cOwner] == pData[playerid][pID])
		{
			format(msg, sizeof(msg), "%s%s\t%s\n", msg, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate]);
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_PARKTAKE, DIALOG_STYLE_TABLIST_HEADERS, "Garasi Umum - Ambil Kendaraan", msg, "Ambil", "Tutup");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Garasi Umum", "Tidak ada kendaraanmu di garasi umum ini.", "Tutup", "");
	return 1;
}

CMD:parkhelp(playerid, params[])
{
	Info(playerid, "/createpark, /setparkpos, /removepark, /gotopark");
	return 1;
}

CMD:createpark(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new id = Iter_Free(Parks), query[512];
	if(id == -1) return Error(playerid, "Can't add any more Park Point.");
 	new Float: x, Float: y, Float: z;
 	GetPlayerPos(playerid, x, y, z);

	ppData[id][parkX] = x;
	ppData[id][parkY] = y;
	ppData[id][parkZ] = z;
	ppData[id][parkInt] = GetPlayerInterior(playerid);
	ppData[id][parkWorld] = GetPlayerVirtualWorld(playerid);
	ppData[id][parkExists] = true;
	Iter_Add(Parks, id);
	Park_Refresh(id);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO parks SET id=%d, posx='%f', posy='%f', posz='%f', interior=%d, world=%d", id, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	mysql_tquery(g_SQL, query, "OnParkCreated", "ii", playerid, id);
	return 1;
}

function OnParkCreated(playerid, id)
{
	Park_Save(id);
	Servers(playerid, "You has created Park Point id: %d.", id);
	return 1;
}

CMD:setparkpos(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new id;
	if(sscanf(params, "i", id)) return Usage(playerid, "/setparkpos [id]");
	if(!Iter_Contains(Parks, id)) return Error(playerid, "Invalid ID.");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	ppData[id][parkX] = x;
	ppData[id][parkY] = y;
	ppData[id][parkZ] = z;
	ppData[id][parkInt] = GetPlayerInterior(playerid);
	ppData[id][parkWorld] = GetPlayerVirtualWorld(playerid);

	Park_Refresh(id);
	Park_Save(id);
	return 1;
}

CMD:removepark(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/removepark [id]");
	if(!Iter_Contains(Parks, id)) return Error(playerid, "Invalid ID.");

	if(IsValidDynamic3DTextLabel(ppData[id][parkLabel]))
		DestroyDynamic3DTextLabel(ppData[id][parkLabel]);
	if(IsValidDynamicPickup(ppData[id][parkPickup]))
		DestroyDynamicPickup(ppData[id][parkPickup]);

	ppData[id][parkX] = ppData[id][parkY] = ppData[id][parkZ] = 0.0;
	ppData[id][parkInt] = ppData[id][parkWorld] = 0;
	ppData[id][parkExists] = false;
	ppData[id][parkPickup] = -1;
	ppData[id][parkLabel] = Text3D: -1;
	Iter_Remove(Parks, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM parks WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "You has deleted park point ID %d.", id);
	return 1;
}

CMD:gotopark(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotopark [id]");
	if(!Iter_Contains(Parks, id)) return Error(playerid, "No have park point exist");

	SetPlayerPosition(playerid, ppData[id][parkX], ppData[id][parkY], ppData[id][parkZ], 2.0);
    SetPlayerInterior(playerid, ppData[id][parkInt]);
    SetPlayerVirtualWorld(playerid, ppData[id][parkWorld]);
	Servers(playerid, "You has Teleport to Park point ID %d", id);
	return 1;
}
