#include "YSI_Coding/y_hooks"
#define MAX_GANJA 50

enum    E_GANJA
{
	// loaded from db
	Float: ganjaX,
	Float: ganjaY,
	Float: ganjaZ,
	Float: ganjaRX,
	Float: ganjaRY,
	Float: ganjaRZ,
	ganjaint,
	ganjaWorld,
	ganjaDelay,
	// temp
	ganjaObjID,
	Text3D: ganjaLabel
}

new GanjaData[MAX_GANJA][E_GANJA],
	Iterator:GANJAS<MAX_GANJA>;


new ganjaarea;
new nukarganjaarea;

CreateNukarGanjaArea()
{
	nukarganjaarea = CreateDynamicSphere(-2816.0706, -1529.9735, 140.8438, 2.0, -1, -1);
}

GetClosestGANJA(playerid, Float: range = 3.0)
{
 	new id = -1, Float: dist = range, Float: tempdist;
 	foreach(new i : GANJAS)
 	{
 	    tempdist = GetPlayerDistanceFromPoint(playerid, GanjaData[i][ganjaX], GanjaData[i][ganjaY], GanjaData[i][ganjaZ]);
 	    if(tempdist > range) continue;
 		if(tempdist <= dist && GetPlayerInterior(playerid) == GanjaData[i][ganjaint] && GetPlayerVirtualWorld(playerid) == GanjaData[i][ganjaWorld])
 		{
 			dist = tempdist;
 			id = i;
 		}
 	}
 	return id;
}

function LoadGanja()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0;
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", GanjaData[id][ganjaX]);
			cache_get_value_name_float(i, "posy", GanjaData[id][ganjaY]);
			cache_get_value_name_float(i, "posz", GanjaData[id][ganjaZ]);
			cache_get_value_name_float(i, "posrx", GanjaData[id][ganjaRX]);
			cache_get_value_name_float(i, "posry", GanjaData[id][ganjaRY]);
			cache_get_value_name_float(i, "posrz", GanjaData[id][ganjaRZ]);
			cache_get_value_name_int(i, "interior", GanjaData[id][ganjaint]);
			cache_get_value_name_int(i, "world", GanjaData[id][ganjaWorld]);
			GanjaData[id][ganjaObjID] = CreateDynamicObject(949, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], GanjaData[id][ganjaRX], GanjaData[id][ganjaRY], GanjaData[id][ganjaRZ], GanjaData[id][ganjaWorld], GanjaData[id][ganjaint], -1, 50.0, 50.0);
			ganjaarea = CreateDynamicSphere(GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], 2.0, -1, -1);
            //format(str, sizeof(str), "[ID: %d]\n"YELLOW_E"/ATM", id);
			//GanjaData[id][ganjaLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTGREEN, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ]+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GanjaData[id][ganjaWorld], GanjaData[id][ganjaint], -1, 10.0);
			//GanjaData[id][atmMap] = CreateDynamicMapIcon(ATMIslem[id][atmPos][0], ATMIslem[id][atmPos][1], ATMIslem[id][atmPos][2], 52, -1, -1, -1, -1, 100.0, 1);
			//GanjaData[id][atmCP] = CreateDynamicCP(ATMIslem[id][atmPos][0], ATMIslem[id][atmPos][1], ATMIslem[id][atmPos][2], 1.5, -1, -1, -1, 3.0);
			Iter_Add(GANJAS, id);
	    	i++;
		}
		printf("[GANJA]: %d Loaded.", i);
	}
}

Ganja_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE ganjas SET posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d' WHERE id='%d'",
	GanjaData[id][ganjaX],
	GanjaData[id][ganjaY],
	GanjaData[id][ganjaZ],
	GanjaData[id][ganjaRX],
	GanjaData[id][ganjaRY],
	GanjaData[id][ganjaRZ],
	GanjaData[id][ganjaint],
	GanjaData[id][ganjaWorld],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

Ganja_BeingEdited(id)
{
	if(!Iter_Contains(GANJAS, id)) return 0;
	foreach(new i : Player) if(pData[i][EditingATMID] == id) return 1;
	return 0;
}

function RespawnGanja(playerid)
{
	if(pData[playerid][CuttingTreeID] != -1)
	{
	    new id = pData[playerid][CuttingGanjaID];
		new asu = pData[playerid][pAsu];
		if(GanjaData[id][ganjaDelay] < 5)
		{
			Error(playerid, "Gak ada ganja");
		}
		else if(GanjaData[id][ganjaDelay] >= 5)
		{
			GanjaData[id][ganjaDelay] = 0;
			pData[playerid][pBorax] += 1;
			pData[playerid][pAsu] ++;
			GanjaData[id][ganjaDelay] = asu;
		}
	}
	return 1;
}
// GetAnyGanja()
// {
// 	new tmpcount;
// 	foreach(new id : GANJAS)
// 	{
//      	tmpcount++;
// 	}
// 	return tmpcount;
// }

// ReturnGanjaID(slot)
// {
// 	new tmpcount;
// 	if(slot < 1 && slot > MAX_GANJA) return -1;
// 	foreach(new id : GANJAS)
// 	{
//         tmpcount++;
//         if(tmpcount == slot)
//         {
//             return id;
//         }
// 	}
// 	return -1;
// }

hook OnPlayerEditDynObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(pData[playerid][EditingGANJAID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingGANJAID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingGANJAID];
	        GanjaData[etid][ganjaX] = x;
	        GanjaData[etid][ganjaY] = y;
	        GanjaData[etid][ganjaZ] = z;
	        GanjaData[etid][ganjaRX] = rx;
	        GanjaData[etid][ganjaRY] = ry;
	        GanjaData[etid][ganjaRZ] = rz;

	        SetDynamicObjectPos(objectid, GanjaData[etid][ganjaX], GanjaData[etid][ganjaY], GanjaData[etid][ganjaZ]);
	        SetDynamicObjectRot(objectid, GanjaData[etid][ganjaRX], GanjaData[etid][ganjaRY], GanjaData[etid][ganjaRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GanjaData[etid][ganjaLabel], E_STREAMER_X, GanjaData[etid][ganjaX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GanjaData[etid][ganjaLabel], E_STREAMER_Y, GanjaData[etid][ganjaY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, GanjaData[etid][ganjaLabel], E_STREAMER_Z, GanjaData[etid][ganjaZ] + 0.3);
			//Streamer_SetFloatData(STREAMER_TAG_AREA, ganjaarea, E_STREAMER_Z, GanjaData[etid][ganjaZ] + 0.3);

		    Ganja_Save(etid);
	        pData[playerid][EditingGANJAID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingGANJAID];
	        SetDynamicObjectPos(objectid, GanjaData[etid][ganjaX], GanjaData[etid][ganjaY], GanjaData[etid][ganjaZ]);
	        SetDynamicObjectRot(objectid, GanjaData[etid][ganjaRX], GanjaData[etid][ganjaRY], GanjaData[etid][ganjaRZ]);
	        pData[playerid][EditingGANJAID] = -1;
	    }
	}
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if(areaid == ganjaarea)
    {
        Info(playerid, "Gunakan `Y` Untuk Mengambil Ganja");
    }
	/*if(areaid == nukarganjaarea)
	{
		ShowKey(playerid, "Gunakan `Y` untuk melakukan transaksi tukar ganja");
	}*/
    return 1;
}

/*hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if(areaid == ganjaarea)
    {
        HideShortKey(playerid);
    }
	if(areaid == nukarganjaarea)
	{
		HideShortKey(playerid);
	}
    return 1;
}*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_YES))
    {
		if(pData[playerid][CuttingGanjaID] != -1)
		{
			new tid = GetClosestGANJA(playerid);
			
			if(tid != -1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
				{
				    pData[playerid][CuttingGanjaID] = tid;
					RespawnGanja(playerid);
				}
				else
				{
					Error(playerid, "Jangan Gunakan Mobil Ketika ingin mencabut ganja");
				}
			}
		}
    }
	/*if((newkeys & KEY_YES))
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2816.0706, -1529.9735, 140.8438))
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			{
				if(pData[playerid][pLintingGanja] < 10)
					return ErrorTD(playerid, "Anda Butuh Minimal 10 Ganja untuk menukarkan nya");

				if(GetPVarInt(playerid, "nukarganja") > gettime())
					return ErrorTD(playerid, "Anda Harus Menunggu 10 detik untuk menukar nya kembali");

				ShowOlahGanja(playerid, "Menukar Ganja..", 7);
				SetPVarInt(playerid, "nukarganja", gettime() + 10);
			}
			else
			{
			 	Error(playerid, "Anda Tidak Dapat Menukar Ganja Sambil Mengendarai Kendaraan");
			}
		}
	}*/
    return 1;
}

CMD:createganja(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
		return PermissionError(playerid);

	new id = Iter_Free(GANJAS), query[512];
	if(id == -1) return Error(playerid, "Can't add any more Ganja.");
 	new Float: x, Float: y, Float: z;
 	GetPlayerPos(playerid, x, y, z);
 	/*GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;*/
	if(pData[playerid][CuttingGanjaID] != -1)
	{
		new tid = GetClosestGANJA(playerid);

		if(tid != -1)
		{
		    pData[playerid][CuttingGanjaID] = tid;
			OnGanjaCreate(playerid);
		}
	}
    
	GanjaData[id][ganjaX] = x;
	GanjaData[id][ganjaY] = y;
	GanjaData[id][ganjaZ] = z;
	GanjaData[id][ganjaRX] = GanjaData[id][ganjaRY] = GanjaData[id][ganjaRZ] = 0.0;
	GanjaData[id][ganjaint] = GetPlayerInterior(playerid);
	GanjaData[id][ganjaWorld] = GetPlayerVirtualWorld(playerid);

	//new str[128];
	GanjaData[id][ganjaObjID] = CreateDynamicObject(949, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], GanjaData[id][ganjaRX], GanjaData[id][ganjaRY], GanjaData[id][ganjaRZ], GanjaData[id][ganjaWorld], GanjaData[id][ganjaint], -1, 10.0, 10.0);
	ganjaarea = CreateDynamicSphere(GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], 2.0, -1, -1);
    //format(str, sizeof(str), "[ID: %d]\n"YELLOW_E"/ATM", id);
	//GanjaData[id][ganjaLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTGREEN, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ] + 0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GanjaData[id][ganjaWorld], GanjaData[id][ganjaint], -1, 10.0);
	Iter_Add(GANJAS, id);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO ganjas SET id='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f', interior='%d', world='%d'", id, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], GanjaData[id][ganjaRX], GanjaData[id][ganjaRY], GanjaData[id][ganjaRZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	mysql_tquery(g_SQL, query, "OnAtmCreated", "ii", playerid, id);
	return 1;
}
function OnGanjaCreate(playerid)
{
	if(pData[playerid][CuttingGanjaID] != -1)
	{
		new asu = pData[playerid][CuttingGanjaID];
		GanjaData[asu][ganjaDelay] = 5;
	}
}
function OnGanjaEdited(playerid, id)
{
	Ganja_Save(id);
	Servers(playerid, "Ganja [%d] berhasil di buat!", id);
	new str[150];
	format(str,sizeof(str),"[Ganja]: %s membuat atm id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:editganja(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
		return PermissionError(playerid);

	if(pData[playerid][EditingATMID] != -1) return Error(playerid, "You're already editing.");

	new id;
	if(sscanf(params, "i", id)) return Usage(playerid, "/editganja [id]");
	if(!Iter_Contains(GANJAS, id)) return Error(playerid, "Invalid ID.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ])) return Error(playerid, "You're not near the atm you want to edit.");
	pData[playerid][EditingATMID] = id;
	EditDynamicObject(playerid, GanjaData[id][ganjaObjID]);
	return 1;
}

CMD:removeganja(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
		return PermissionError(playerid);

	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/removeganja [id]");
	if(!Iter_Contains(GANJAS, id)) return Error(playerid, "Invalid ID.");

	if(Ganja_BeingEdited(id)) return Error(playerid, "Can't remove specified atm because its being edited.");
	DestroyDynamicObject(GanjaData[id][ganjaObjID]);
	DestroyDynamic3DTextLabel(GanjaData[id][ganjaLabel]);

	GanjaData[id][ganjaX] = GanjaData[id][ganjaY] = GanjaData[id][ganjaZ] = GanjaData[id][ganjaRX] = GanjaData[id][ganjaRY] = GanjaData[id][ganjaRZ] = 0.0;
	GanjaData[id][ganjaint] = GanjaData[id][ganjaWorld] = 0;
	GanjaData[id][ganjaObjID] = -1;
	GanjaData[id][ganjaLabel] = Text3D: -1;
	Iter_Remove(GANJAS, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM ganjas WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID ganja %d.", id);
	new str[150];
	format(str,sizeof(str),"[GANJA]: %s menghapus ganja id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:gotoganja(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoganja [id]");
	if(!Iter_Contains(GANJAS, id)) return Error(playerid, "GANJA ID tidak ada.");

	SetPlayerPosition(playerid, GanjaData[id][ganjaX], GanjaData[id][ganjaY], GanjaData[id][ganjaZ], 2.0);
    SetPlayerInterior(playerid, GanjaData[id][ganjaint]);
    SetPlayerVirtualWorld(playerid, GanjaData[id][ganjaWorld]);
	Servers(playerid, "Teleport ke ID GANJA %d", id);
	return 1;
}
