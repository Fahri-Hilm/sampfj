DCMD:setcs(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1032649509047648307"))
		return 1;
		
/*	new player[24], type;
	if(sscanf(params, "s[24]d", player, type))
        return DCC_SendChannelMessage(channel, "!setcs <Nama IC>  <1 = Kasih dan 0 = Hapus>");*/
    if(isnull(params))
        return DCC_SendChannelMessage(channel, "!setcs <Nama IC>  <1 = Kasih dan 0 = Hapus>");

	new query[512], str1[256];
    format(query, sizeof(query), "UPDATE players SET playercs='%d' WHERE username=%e", params, params);
	format(str1, sizeof str1, "kamu telah mengset cs %s.", params);
    DCC_SendChannelMessage(channel, str1);

	/*mysql_format(g_SQL, query, sizeof(query), "SELECT playercs FROM players WHERE playercs='%d'", params);
	mysql_tquery(g_SQL, query, "OnCsQueryData", "si", player, type);*/
	return 1;
}
forward OnCsQueryData(player[], type);
public OnCsQueryData(player[], type)
{
    new DCC_Channel:ASU;
    ASU = DCC_FindChannelById("1032649509047648307");
	new query[512], str1[256];
    format(query, sizeof(query), "UPDATE players SET playercs='%d' WHERE username=%e", type, player);
	mysql_tquery(g_SQL, query);
	format(str1, sizeof str1, "kamu telah mengset cs %s.", player);
    DCC_SendChannelMessage(ASU, str1);
	return 1;
}
forward ReffCheckDiscordUCP(DiscordID[], Nama_UCP[]);
public ReffCheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role:WARGA, DCC_Guild:guild, DCC_User: user, dc[1000];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(12, "**[INFO]:** ```Nama UCP account tersebut sudah terdaftar```");
	}
	else
	{
		guild = DCC_FindGuildById("1032649508187799562");
		WARGA = DCC_FindRoleById("1032649508187799565");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, Nama_UCP);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "__***HOPIXEL ROLEPLAY***__\n:white_check_mark: Selamat UCP **%s** berhasil terverifikasi kembali", Nama_UCP);
		SendDiscordMessage(12, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward ReffCheckDiscordID(DiscordID[], Nama_UCP[]);
public ReffCheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[200], dc[1000], DCC_User:user, DCC_Guild:guild, DCC_Role:WARGA;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		format(dc, sizeof(dc),  "**[INFO]:** Kamu sudah mendaftar UCP sebelumnya dengan nama **%s**", ucp);
		guild = DCC_FindGuildById("1032649508187799562");
		WARGA = DCC_FindRoleById("1032649508187799565");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, ucp);
		DCC_AddGuildMemberRole(guild, user, WARGA);
		return SendDiscordMessage(12, dc);
	}
	else
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "ReffCheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}

forward CheckPIN(Nama_UCP[]);
public CheckPIN(Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[20], dc[1000], pin, ID[210];
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "verifycode", pin);
		cache_get_value_name(0, "DiscordID", ID);

		format(dc, sizeof(dc),  "**USER PIN:**\n**UCP: %s\nPIN: %d\nID Discord: <@%s>**", ucp, pin, ID);
		return SendDiscordMessage(8, dc);
	}
	else
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

/*forward Delete(Nama_UCP[]);
public Delete(Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[2000], dc[2000];
	if(rows > 0)
	{
		format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Hapus.**", ucp);
		new characterQuery[178];
	    mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "DELETE * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		return SendDiscordMessage(8, dc);
	}
	else
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}*/

DCMD:setpin(user, channel, params[])
{
 	if(channel != DCC_FindChannelById("1034139492799483964"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !setpin [namaUCP] [PIN]");

	/*new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT password FROM playerucp WHERE ucp='%s'", params);
	mysql_tquery(g_SQL, characterQuery, "ChangeUCPpin", "ss", params, params);*/
	new rows = cache_num_rows(), dc[2000];
	if(rows > 0)
	{
	    new characterQuery[178];
	    format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Ganti PIN.**", params);
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "UPDATE playerucp SET verifycode='%s', WHERE ucp='%s'", params, params);
		return SendDiscordMessage(8, dc);
	}
	else
	{
	    SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

/*forward ChangeUCPpin(Nama_UCP[], PIN[]);
public ChangeUCPpin(Nama_UCP[], PIN[])
{
	if(cache_num_rows() > 0)
	{
	    new characterQuery[178], dc[2000];
	    format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Ganti PIN.**", Nama_UCP);
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "UPDATE playerucp SET verifycode='%s', WHERE ucp='%s'", PIN, Nama_UCP);
		return SendDiscordMessage(8, dc);
	}
	else
	{
	    SendDiscordMessage(8, "UCP not registered goblok");
	}
    return 1;
}*/
DCMD:ann(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1032649509047648307"))
		return 1;
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !ann pesan");
    foreach (new i : Player)
    {
		Servers(i, "(( {6F00FF}[DISCORD] {FFFFFF}: %s ))", params);
	}
	return 1;
}

DCMD:reffucp(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1032649509047648313"))
		return 1;
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !reffucp NamaUCP");
	if(!CheckNamaICRegister(params))
		return DCC_SendChannelMessage(channel, "**Gunakan nama UCP bukan nama IC!**");

	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];

	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "ReffCheckDiscordID", "ss", id, params);
	return 1;
}
function OnUserVerif(strr[])
{
	new DCC_Channel:channel, DCC_Embed:ucp;
	new y, m, d, timestamp[20];
	getdate(y, m , d);
	format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	channel = DCC_GetCreatedPrivateChannel();
	ucp = DCC_CreateEmbed("Hopixel Roleplay");
	DCC_SetEmbedTitle(ucp, "Hopixel");
	DCC_SetEmbedTimestamp(ucp, timestamp);
	DCC_SetEmbedColor(ucp, 0xff0000);
	DCC_SetEmbedUrl(ucp, "https://connect.hopixel.site");
	//DCC_SetEmbedThumbnail(ucp, "https://i.postimg.cc/X7xv22Dd/IMG-20211025-183319-5873.jpg");
	DCC_SetEmbedFooter(ucp, "Hopixel Roleplay", "");
	DCC_SetEmbedDescription(ucp, strr);
	DCC_SetEmbedImage(ucp, "https://cdn.discordapp.com/icons/1032649508187799562/adf7df9611b4012ff7d84eede907e2c0.jpg");  //ini embed profil nya
	DCC_SendChannelEmbedMessage(channel, ucp);
	return 1;
}

/*
DCMD:register(user, channel, params[])
{
	new DCC_Channel:bangrell;
	bangrell = DCC_FindChannelById("1003622206129057792");

	if(channel != bangrell) return DCC_SendChannelMessage(channel, "**ERROR** : Akses anda di tolak, penggunaan channel tidak sah!");
	if(isnull(params)) return DCC_SendChannelMessage(channel, "**USAGE** : !register [Nama]");
	if(!CheckNamaICRegister(params)) return DCC_SendChannelMessage(channel, "**Gunakan nama UCP bukan nama IC!**");
	new file[2000], query[2000];
	format(file, sizeof(file), "Ucp/%s.txt", params);
	if(!dini_Exists(file))
	{
		dini_Create(file);
		new str[250], rani = random(10000);
		if(rani == 0 || rani < 1000)
		{
	 		rani = random(9999);
		}
		new hu[200], rini[64];
		format(rini, 64, "%d", rani);
		format(hu, 200, "%s", rini);
		new useri[DCC_ID_SIZE], DCC_User:userid;
		DCC_GetUserId(user, useri);
		userid = DCC_FindUserById(useri);
		mysql_format(g_SQL, query, sizeof query, "INSERT INTO `playerucp` (`ucp`, `verifycode`, `DiscordID`) VALUES ('%s', '%s', '0')", params, rini);
		mysql_tquery(g_SQL, query);
		format(str, 250, "**Relfiya Realita Roleplay**\n```Hallo! Selamat UCP anda berhasil terverifikasi, Gunakan PIN di bawah ini Untuk Register InGame\n```\n\n**UCP**\n```\n%s\n```\n**PIN**\n```\n%s\n```", params, hu);
		DCC_CreatePrivateChannel(userid, "OnUserVerif", "s", str);
		new DCC_Embed:acc, stri[2800];
		acc = DCC_CreateEmbed("RELFIYA REALITA ROLEPLAY");
		format(stri, 280, "**RELFIYA REALITA ROLEPLAY**\nSelamat UCP ***%s*** berhasil terverifikasi, Silahkan Cek Dm Kak<3", params);
		new y, m, d, timestamp[200];
		getdate(y, m , d);
		format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
		DCC_SetEmbedTitle(acc, "RELFIYA REALITA");
		DCC_SetEmbedTimestamp(acc, timestamp);
		DCC_SetEmbedColor(acc, 0x00ff00);
		DCC_SetEmbedThumbnail(acc, "https://cdn.discordapp.com/attachments/1003182272356298802/1003231993431072878/IMG-20220731-WA0097.jpg");
		DCC_SetEmbedFooter(acc, "RELFIYA REALITA ROLEPLAY", "");
		DCC_SetEmbedDescription(acc, stri);
		DCC_SendChannelEmbedMessage(channel, acc);
		new DCC_Guild:guild, DCC_Role:verified;
		verified = DCC_FindRoleById("1003182182413647913");
		DCC_GetChannelGuild(channel, guild);
		DCC_SetGuildMemberNickname(guild, user, params);
		DCC_AddGuildMemberRole(guild, user, verified);
	}
	else
	{
		new gs[80];
		format(gs, 80, "**ERROR** : Nama **%s** sudah terdaftar sebelumnya!", params);
		DCC_SendChannelMessage(channel, gs);
	}
	return 1;
}*/
DCMD:checkpin(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1034139492799483964"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !checkpin NamaUCP");

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "CheckPIN", "s", params);
	return 1;
}

DCMD:deleteucp(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1034139492799483964"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !deleteucp NamaUCP");

	/*new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "Delete", "s", params);*/
	new rows = cache_num_rows(), dc[2000];
	if(rows > 0)
	{
		format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Hapus.**", params);
		new characterQuery[178];
	    mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "DELETE * FROM `playerucp` WHERE `ucp` = '%s'", params);
		return SendDiscordMessage(8, dc);
	}
	else
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

DCMD:checkp(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1034141460620115968"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**USAGE**: !checkp NAMA CHARACTER");

	new characterQuery[1780];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "CheckPlayer", "s", params);
	return 1;
}

forward CheckPlayer(Username[]);
public CheckPlayer(Username[])
{
	new rows = cache_num_rows(), ucp[2000], level, uid, duek, bmoney, redm, skin, comp, mat, band, marju, vip, vipt, boost, boostt, reg[1000], lastlogin[1000], j1, j2, fac;
	if(rows > 0)
	{
		new DCC_Channel:CH, str1[10000], str2[10000];

		CH = DCC_FindChannelById("1034141460620115968");

		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "level", level);
		cache_get_value_name_int(0, "reg_id", uid);
		cache_get_value_name_int(0, "money", duek);
		cache_get_value_name_int(0, "redmoney", redm);
		cache_get_value_name_int(0, "skin", skin);
		cache_get_value_name_int(0, "bmoney", bmoney);
		cache_get_value_name_int(0, "vip", vip);
		cache_get_value_name_int(0, "vip_time", vipt);
		cache_get_value_name_int(0, "boost", boost);
		cache_get_value_name_int(0, "boost_time", boostt);
		cache_get_value_name(0, "reg_date", reg);
		cache_get_value_name(0, "last_login", lastlogin);
		cache_get_value_name_int(0, "job", j1);
    	cache_get_value_name_int(0, "job2", j2);
    	cache_get_value_name_int(0, "faction", fac);
    	cache_get_value_name_int(0, "component", comp);
    	cache_get_value_name_int(0, "material", mat);
    	cache_get_value_name_int(0, "marijuana", marju);
    	cache_get_value_name_int(0, "bandage", band);

		new DCC_Embed:embed = DCC_CreateEmbed(.title = "Account Players");

		format(str1, sizeof str1, "**__Name UCP:__**");
		format(str2, sizeof str2, "```\n%s```", ucp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "__Name Character:__");
		format(str2, sizeof str2, "```\n%s```", Username);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__UID:__**");
		format(str2, sizeof str2, "```\n%d```", uid);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**__Level:__**");
		format(str2, sizeof str2, "```\n%d```", level);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**__Vip:__**");
		format(str2, sizeof str2, "```\n%s```", GetVipName(vip));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Vip Time:__**");
		format(str2, sizeof str2, "```\n%d```", vipt);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Roleplay Booster:__**");
		format(str2, sizeof str2, "```\n%s```", GetBoost(boost));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Booster Time:__**");
		format(str2, sizeof str2, "```\n%d```", boostt);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Money:__**");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(duek));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Bank Money:__**");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(bmoney));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Red Money:__**");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(redm));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Register Date:__**");
		format(str2, sizeof str2, "```\n%s```", reg);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Last Login:__**");
		format(str2, sizeof str2, "```\n%s```", lastlogin);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Faction:__**");
		format(str2, sizeof str2, "```\n%s```", GetFacName(fac));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Job:__**");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j1));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Job 2:__**");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j2));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Bandage:__**");
		format(str2, sizeof str2, "```\n%d```", band);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Component:__**");
		format(str2, sizeof str2, "```\n%d```", comp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Material:__**");
		format(str2, sizeof str2, "```\n%d```", mat);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**__Marijuana:__**");
		format(str2, sizeof str2, "```\n%d```", marju);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "https://assets.open.mp/assets/images/skins/%s.png", skin);
		DCC_SetEmbedImage(embed, str1);
		DCC_SetEmbedColor(embed, 0x004BFFFF);
		new y, m, d, timestamp[200];
    	getdate(y, m , d);
	    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	    DCC_SetEmbedTimestamp(embed, timestamp);
	    DCC_SetEmbedFooter(embed, "HOPIXEL ROLEPLAY");

		DCC_SendChannelEmbedMessage(CH, embed);
	}
	else
	{
		new DCC_Channel:CH;
		CH = DCC_FindChannelById("1034141460620115968");
		DCC_SendChannelMessage(CH, "<!> Username tersebut tidak ada di database");
	}
	return 1;
}
