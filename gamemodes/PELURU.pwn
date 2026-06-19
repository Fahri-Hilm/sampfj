CMD:clip(playerid,params[])
{
	ShowPlayerDialog(playerid, DIALOG_CLIP, DIALOG_STYLE_LIST, "Jenis CLIP", "Clip DE\nClip SG\nClip AK47", "Reload", "Tutup");
	return 1;
}

function UseClip(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(gunid == 0 || ammo == 0) return 0;
	GivePlayerWeaponEx(playerid, gunid, ammo);
    ClearAnimations(playerid);
	Info(playerid, "Reload sukses.");
	TogglePlayerControllable(playerid, 1);
	InfoTD_MSG(playerid, 8000, "Weapon Reload!");
	KillTimer(pData[playerid][pArmsDealer]);
	pData[playerid][pActivityTime] = 0;
	pData[playerid][pEnergy] -= 3;
	return 1;
}

CMD:beli(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)  return Error(playerid, "Cuman family yang bisa beli.");
	if(IsPlayerInRangeOfPoint(playerid,2.0, 297.467285, -104.712501, 1001.515625))
	{
	    ShowPlayerDialog(playerid, DIALOG_BELICLIP, DIALOG_STYLE_LIST, "Jenis Clip","Clip DE\nClip SG\nClip AK47","Pilih","Batal");
	}
	return 1;
}

