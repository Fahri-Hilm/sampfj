//--- Vehicle Trunk
enum StorageData
{
	tMoney,
	tComp,
	tMats,
	tBor,
	tObor,
	tSeed,
	tNaskuc,
	tJusjer,
	tClipA,
	tClipB,
	tClipC,
	tBatu,
	tCubat,
	tBesi,
	tEmas,
	tBerlian,
	tWeapon[5],
	tAmmo[5]
};
new vsData[MAX_PRIVATE_VEHICLE][StorageData];

Trunk_WeaponStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 5; i ++)
    {
    	if(!vsData[vehicleid][tWeapon][i])
    		format(string, sizeof(string), "%sEmpty Slot\n", string);

		else
        	format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(vsData[vehicleid][tWeapon][i]), vsData[vehicleid][tAmmo][i]);
    }
    ShowPlayerDialog(playerid, TRUNK_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Trunk_OpenStorage(playerid, vehicleid)
{
    if(vehicleid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 5; i ++) if(vsData[vehicleid][tWeapon][i])
	{
        items[0]++;
    }
	format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s)\nComponent (%d/1000)\nMaterial (%d/1000)\nBorax (%d/600)\nOlahan Borax (%d/100)\nSeed (%d/500)\nBatu (%d/7)\nCucian Batu (%d/7)\nBesi (%d/42)\nEmas (%d/21)\nBerlian (%d/5)", items[0], FormatMoney(vsData[vehicleid][tMoney]), vsData[vehicleid][tComp], vsData[vehicleid][tMats], vsData[vehicleid][tBor], vsData[vehicleid][tObor], vsData[vehicleid][tSeed], vsData[vehicleid][tBatu], vsData[vehicleid][tCubat], vsData[vehicleid][tBesi], vsData[vehicleid][tEmas], vsData[vehicleid][tBerlian]);

    ShowPlayerDialog(playerid, TRUNK_STORAGE, DIALOG_STYLE_LIST, "Trunk Storage", string, "Select", "Cancel");
    return 1;
}

MySQL_LoadVehicleStorage(vehicleid)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `trunk` WHERE Owner='%d' LIMIT 1", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, query, "LoadVehicleTrunk", "i", vehicleid);
}

function LoadVehicleTrunk(vehicleid)
{
	new rows = cache_num_rows(), vehid = pvData[vehicleid][cVeh];
 	if(rows)
  	{
		for(new z = 0; z < rows; z++)
		{
			pvData[vehid][LoadedStorage] = true;
			cache_get_value_name_int(z, "money", vsData[vehid][tMoney]);
			cache_get_value_name_int(z, "component", vsData[vehid][tComp]);
			cache_get_value_name_int(z, "material", vsData[vehid][tMats]);
			cache_get_value_name_int(z, "borax", vsData[vehid][tBor]);
			cache_get_value_name_int(z, "olahanborax", vsData[vehid][tObor]);
			cache_get_value_name_int(z, "seed", vsData[vehid][tSeed]);
			cache_get_value_name_int(z, "batu", vsData[vehid][tBatu]);
			cache_get_value_name_int(z, "cubat", vsData[vehid][tCubat]);
			cache_get_value_name_int(z, "besi", vsData[vehid][tBesi]);
			cache_get_value_name_int(z, "emas", vsData[vehid][tEmas]);
			cache_get_value_name_int(z, "berlian", vsData[vehid][tBerlian]);
			cache_get_value_name_int(z, "weapon1", vsData[vehid][tWeapon][0]);
			cache_get_value_name_int(z, "ammo1", vsData[vehid][tAmmo][0]);
			cache_get_value_name_int(z, "weapon2", vsData[vehid][tWeapon][1]);
			cache_get_value_name_int(z, "ammo2", vsData[vehid][tAmmo][1]);
			cache_get_value_name_int(z, "weapon3", vsData[vehid][tWeapon][2]);
			cache_get_value_name_int(z, "ammo3", vsData[vehid][tAmmo][2]);
			cache_get_value_name_int(z, "weapon4", vsData[vehid][tWeapon][3]);
			cache_get_value_name_int(z, "ammo4", vsData[vehid][tAmmo][3]);
			cache_get_value_name_int(z, "weapon5", vsData[vehid][tWeapon][4]);
			cache_get_value_name_int(z, "ammo5", vsData[vehid][tAmmo][4]);
		}
	}
}

Trunk_Save(vehicleid)
{
	new cQuery[1536], x = pvData[vehicleid][cVeh];
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `trunk` SET ");
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`money`= %d,", cQuery, vsData[x][tMoney]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`component`= %d,", cQuery, vsData[x][tComp]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`material`= %d,", cQuery, vsData[x][tMats]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`borax`= %d,", cQuery, vsData[x][tBor]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`olahanborax`= %d,", cQuery, vsData[x][tObor]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`seed`= %d,", cQuery, vsData[x][tSeed]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`batu`= %d,", cQuery, vsData[x][tBatu]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`cubat`= %d,", cQuery, vsData[x][tCubat]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`besi`= %d,", cQuery, vsData[x][tBesi]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`emas`= %d,", cQuery, vsData[x][tEmas]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`berlian`= %d,", cQuery, vsData[x][tBerlian]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon1` = %d, `ammo1` = %d,", cQuery, vsData[x][tWeapon][0], vsData[x][tAmmo][0]);		
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon2` = %d, `ammo2` = %d,", cQuery, vsData[x][tWeapon][1], vsData[x][tAmmo][1]);		
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon3` = %d, `ammo3` = %d,", cQuery, vsData[x][tWeapon][2], vsData[x][tAmmo][2]);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon4` = %d, `ammo4` = %d,", cQuery, vsData[x][tWeapon][3], vsData[x][tAmmo][3]);				
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`weapon5` = %d, `ammo5` = %d ", cQuery, vsData[x][tWeapon][4], vsData[x][tAmmo][4]);				
    mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `Owner` = %d", cQuery, pvData[vehicleid][cID]);
	mysql_query(g_SQL, cQuery);
	return 1;
}

function MySQL_CreateVehicleStorage(vehicleid)
{
	new query[512];

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `trunk` (`Owner`) VALUES ('%d')", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, query);

	vsData[vehicleid][tMoney] = 0;
	vsData[vehicleid][tComp] = 0;
	vsData[vehicleid][tMats] = 0;
	vsData[vehicleid][tBor] = 0;
	vsData[vehicleid][tObor] = 0;
	vsData[vehicleid][tSeed] = 0;
	vsData[vehicleid][tBatu] = 0;
	vsData[vehicleid][tCubat] = 0;
	vsData[vehicleid][tBesi] = 0;
	vsData[vehicleid][tEmas] = 0;
	vsData[vehicleid][tBerlian] = 0;
	for (new h4n = 0; h4n < 5; h4n ++)
    {
        vsData[vehicleid][tWeapon][h4n] = 0;

		vsData[vehicleid][tAmmo][h4n] = 0;
    }
}
