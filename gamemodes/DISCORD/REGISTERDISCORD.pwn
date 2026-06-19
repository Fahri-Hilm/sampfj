DCMD:on(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1032649509047648307"))
		return 1;

    new DCC_Channel:ASU;
    ASU = DCC_FindChannelById("1038962089613594695");
    new DCC_Embed:embed = DCC_CreateEmbed(.title="ANNOUNCEMENT", .image_url="https://media.discordapp.net/attachments/1032649509047648308/1039085675829547048/20221107_145504_0000.png");
	new str1[1000];

	format(str1, sizeof str1, "```\nBADAI TELAH BERLALU...\nUNTUK WARGA YANG INGIN MEMASUKI KOTA \nHARAP BERHATI HATI. DAN JUGA ADA BUG \nSILAHKAN LAPORKAN KEPADA PIHAK ADMINISTRATOR .\nTERIMA KASIH!```");
	DCC_SetEmbedDescription(embed, str1);
	DCC_SetEmbedColor(embed, 0x004BFFFF);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "Hopixel Roleplay");
	DCC_SendChannelEmbedMessage(ASU, embed, "@everyone");
	
	return 1;
}
DCMD:off(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1032649509047648307"))
		return 1;

    new DCC_Channel:ASU;
    ASU = DCC_FindChannelById("1038962089613594695");
    new DCC_Embed:embed = DCC_CreateEmbed(.title="ANNOUNCEMENT", .image_url="https://media.discordapp.net/attachments/1032649509047648308/1039085675829547048/20221107_145504_0000.png");
	new str1[1000];

	format(str1, sizeof str1, "```\nKOTA SEDANG TERJADI BADAI HARIAN, UNTUK SELURUH WARGA HOPIXEL DISARANKAN MENCARI TEMPAT BERTEDUH SAMPAI BADAI MEREDA...!```");
	DCC_SetEmbedDescription(embed, str1);
	DCC_SetEmbedColor(embed, 0x004BFFFF);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "Hopixel Roleplay");
	DCC_SendChannelEmbedMessage(ASU, embed, "@everyone");

	return 1;
}
DCMD:hverif(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1032649509047648313"))
		return 1;
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "```\n[USAGE]: !hverif [UCP NAME]```");
	if(!CheckNamaICRegister(params))
		return DCC_SendChannelMessage(channel, "```\nGunakan nama UCP bukan nama IC!```");
//	DCC_SendChannelMessage(channel, "**Accept Silahkan Cek PM Bot Discord HamZyy!**);

	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
	return 1;
}

forward DCC_DM(str[]);
public DCC_DM(str[])
{
    new DCC_Channel:PM;
	PM = DCC_GetCreatedPrivateChannel();
	DCC_SendChannelMessage(PM, str);
	return 1;
}
forward DCC_DM_EMBED(str[], pin, id[]);
public DCC_DM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[2000];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="HOPIXEL ROLEPLAY", .image_url="https://media.discordapp.net/attachments/1032649509047648308/1034161378992345158/Picsart_22-10-25_01-47-46-832.jpg");
	new str1[1000], str2[1000];

	format(str1, sizeof str1, "```\nHallo!\nSelamat UCP anda berhasil terverifikasi,\nGunakan PIN di bawah ini Untuk Register InGame!```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	DCC_SetEmbedColor(embed, 0x004BFFFF);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "Hopixel Roleplay");
	DCC_SendChannelEmbedMessage(PM, embed);

	mysql_format(g_SQL, query, sizeof query, "INSERT INTO `playerucp` (`ucp`, `verifycode`, `DiscordID`) VALUES ('%e', '%d', '%e')", str, pin, id);
	mysql_tquery(g_SQL, query);
	return 1;
}

forward CheckDiscordUCP(DiscordID[], Nama_UCP[]);
public CheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role:WARGA, DCC_Guild:guild, DCC_User: user, dc[1000];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(7, "```\n[ERROR]: Nama UCP account tersebut sudah terdaftar```");
	}
	else
	{
		guild = DCC_FindGuildById("1032649508187799562");
		WARGA = DCC_FindRoleById("1032649508187799565");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, Nama_UCP);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "```\n[INFO]UCP %s berhasil terverifikasi```", Nama_UCP);
		SendDiscordMessage(7, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward CheckDiscordID(DiscordID[], Nama_UCP[]);
public CheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[200], dc[1000], DCC_User:user, DCC_Guild:guild, DCC_Role:WARGA;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		format(dc, sizeof(dc),  "```\n[ERROR]: Kamu sudah mendaftar UCP dengan nama %s```", ucp);
		guild = DCC_FindGuildById("1032649508187799562");
		WARGA = DCC_FindRoleById("1032649508187799565");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, ucp);
		DCC_AddGuildMemberRole(guild, user, WARGA);
		return SendDiscordMessage(7, dc);
	}
	else
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}
