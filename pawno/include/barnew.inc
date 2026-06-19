/* 
	[ LOADING BAR BY LUMINOUZ AND REMWORK BY Zeezy#0001]
	[ DON'T SELL, ITS FREE]
*/
#if defined _loadingbar_included
  #endinput
#endif
#define _loadingbar_included

static  PlayerText:LoadingBar[MAX_PLAYERS][3],
        LoadingTimer[MAX_PLAYERS],
        LoadingValue[MAX_PLAYERS],
        bool:IsLoading[MAX_PLAYERS];

stock Loading_Remove(playerid)
{
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, LoadingBar[playerid][i]);
	}
	LoadingValue[playerid] = 0;
	IsLoading[playerid] = false;
	return 1;
}

stock Loading_BarUpdate(playerid)
{
	PlayerTextDrawTextSize(playerid, LoadingBar[playerid][1], LoadingValue[playerid]*79/100, 13.500000);
	PlayerTextDrawShow(playerid, LoadingBar[playerid][1]);
}

forward Loading_TimerUpdate(playerid);
public Loading_TimerUpdate(playerid)
{
	if(!IsValidLoadingBar(playerid))
		return 0;

	if(LoadingValue[playerid] < 100)
	{
		LoadingValue[playerid]++;
		Loading_BarUpdate(playerid);
	}
	else
	{
		StopPlayerLoadingBar(playerid);
	}
	return 1;
}

/* Used Functions */

stock IsValidLoadingBar(playerid)
	return IsLoading[playerid];

stock ShowProgressbar(playerid, text[] = "", interval)
{
	if(IsValidLoadingBar(playerid))
		StopPlayerLoadingBar(playerid);

	new time = interval*10;

	LoadingBar[playerid][0] = CreatePlayerTextDraw(playerid, 277.000000, 399.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, LoadingBar[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, LoadingBar[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, LoadingBar[playerid][0], 83.000000, 18.000000);
	PlayerTextDrawSetOutline(playerid, LoadingBar[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, LoadingBar[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, LoadingBar[playerid][0], 1);
	PlayerTextDrawColor(playerid, LoadingBar[playerid][0], 1296911791);
	PlayerTextDrawBackgroundColor(playerid, LoadingBar[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, LoadingBar[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, LoadingBar[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, LoadingBar[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingBar[playerid][0], 0);

	LoadingBar[playerid][1] = CreatePlayerTextDraw(playerid, 279.000000, 401.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, LoadingBar[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, LoadingBar[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, LoadingBar[playerid][1], 0.000000, 13.500000);
	PlayerTextDrawSetOutline(playerid, LoadingBar[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, LoadingBar[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, LoadingBar[playerid][1], 1);
	PlayerTextDrawColor(playerid, LoadingBar[playerid][1], 1687547311);
	PlayerTextDrawBackgroundColor(playerid, LoadingBar[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, LoadingBar[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, LoadingBar[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, LoadingBar[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingBar[playerid][1], 0);

	LoadingBar[playerid][2] = CreatePlayerTextDraw(playerid, 318.000000, 403.000000, "_");
	PlayerTextDrawFont(playerid, LoadingBar[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, LoadingBar[playerid][2], 0.175000, 0.950000);
	PlayerTextDrawTextSize(playerid, LoadingBar[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, LoadingBar[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, LoadingBar[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, LoadingBar[playerid][2], 2);
	PlayerTextDrawColor(playerid, LoadingBar[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingBar[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, LoadingBar[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, LoadingBar[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, LoadingBar[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingBar[playerid][2], 0);

	PlayerTextDrawSetString(playerid, LoadingBar[playerid][2], text);
	PlayerTextDrawColor(playerid, LoadingBar[playerid][1], 1687547311);

	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawShow(playerid, LoadingBar[playerid][i]);
	}
	LoadingValue[playerid] = 0;
	IsLoading[playerid] = true;
	LoadingTimer[playerid] = SetTimerEx(#Loading_TimerUpdate, time, true, "d", playerid);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

stock StopPlayerLoadingBar(playerid)
{
    KillTimer(LoadingTimer[playerid]);
    Loading_Remove(playerid);
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, 1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
}