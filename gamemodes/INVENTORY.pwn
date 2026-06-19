#define MAX_INVENTORY   16
#define THREAD_LOAD_INVENTORY (8)
// OTHER DEFINE
#define forex(%0,%1) for(new %0 = 0; %0 != %1; %0++)
#define function%0(%1) forward %0(%1); public %0(%1)
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

enum inventoryData
{
	invExists,
	invID,
	invItem[32 char],
	invModel,
	invQuantity
};
new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
new PlayerText:NamaTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:InventoryTD[MAX_PLAYERS][11];
new PlayerText:KotakTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:AmountTD[MAX_PLAYERS][MAX_INVENTORY];
new PlayerText:BarangTD[MAX_PLAYERS][MAX_INVENTORY];
enum e_InventoryItems
{
	e_InventoryItem[32],
	e_InventoryModel
};

//Disini ganti nama barang dan ID barangnya
new const g_aInventoryItems[][e_InventoryItems] =
{
	{"Desert Eagle", 348},
	{"Shotgun", 349},
	{"Cellphone", 330},
	{"MP5", 353},
	{"AK-47", 355},
	{"Money", 1212},
	{"Marijuana", 759},
	{"Snack", 2768},
	{"Sprunk", 2647},
	{"Nani_Ya?", 2677}
};
CreateInventoryTD(playerid)
{
	InventoryTD[playerid][0] = CreatePlayerTextDraw(playerid, 128.000000, 118.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][0], 205.500000, 287.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][0], 355226292);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][0], 0);

	InventoryTD[playerid][1] = CreatePlayerTextDraw(playerid, 135.000000, 127.000000, "BANGSATRIO");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][1], 0.233333, 1.299998);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][1], 0);

	InventoryTD[playerid][2] = CreatePlayerTextDraw(playerid, 326.000000, 127.000000, "540.578/100000kg");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][2], 0.191667, 1.149999);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][2], 3);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][2], 0);

	InventoryTD[playerid][3] = CreatePlayerTextDraw(playerid, 134.000000, 146.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][3], 193.000000, 4.000000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][3], 355226292);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][3], 0);

	InventoryTD[playerid][4] = CreatePlayerTextDraw(playerid, 134.000000, 146.000000, "ld_dual:white"); //PROGRES BAR
	PlayerTextDrawFont(playerid, InventoryTD[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][4], 193.000000, 4.000000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][4], 16777140);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][4], 0);

	InventoryTD[playerid][5] = CreatePlayerTextDraw(playerid, 341.000000, 183.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][5], 90.500000, 139.000000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][5], 355226292);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][5], 0);

	InventoryTD[playerid][6] = CreatePlayerTextDraw(playerid, 386.000000, 193.000000, "50000");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][6], 0.229166, 1.849997);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][6], 9.000000, 73.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][6], -1094795521);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][6], -1094795654);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][6], 1);

	InventoryTD[playerid][7] = CreatePlayerTextDraw(playerid, 386.000000, 218.000000, "MENGGUNAKAN");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][7], 0.229166, 1.849997);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][7], 9.000000, 73.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][7], -1094795521);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][7], -1094795654);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][7], 1);

	InventoryTD[playerid][8] = CreatePlayerTextDraw(playerid, 386.000000, 244.000000, "MEMBERI");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][8], 0.229166, 1.849997);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][8], 9.000000, 73.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][8], -1094795521);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][8], -1094795654);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][8], 1);

	InventoryTD[playerid][9] = CreatePlayerTextDraw(playerid, 386.000000, 270.000000, "MENYIMPAN");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][9], 0.229166, 1.849997);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][9], 9.000000, 73.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][9], 2);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][9], -1094795521);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][9], -1094795654);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][9], 1);

	InventoryTD[playerid][10] = CreatePlayerTextDraw(playerid, 386.000000, 296.000000, "MENUTUP");
	PlayerTextDrawFont(playerid, InventoryTD[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, InventoryTD[playerid][10], 0.229166, 1.849997);
	PlayerTextDrawTextSize(playerid, InventoryTD[playerid][10], 9.000000, 73.500000);
	PlayerTextDrawSetOutline(playerid, InventoryTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, InventoryTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InventoryTD[playerid][10], 2);
	PlayerTextDrawColor(playerid, InventoryTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InventoryTD[playerid][10], -1094795521);
	PlayerTextDrawBoxColor(playerid, InventoryTD[playerid][10], -1094795654);
	PlayerTextDrawUseBox(playerid, InventoryTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InventoryTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InventoryTD[playerid][10], 1);

	KotakTD[playerid][0] = CreatePlayerTextDraw(playerid, 134.000000, 161.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][0], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][0], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][0], 0);

	KotakTD[playerid][1] = CreatePlayerTextDraw(playerid, 183.000000, 161.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][1], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][1], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][1], 0);

	KotakTD[playerid][2] = CreatePlayerTextDraw(playerid, 232.000000, 161.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][2], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][2], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][2], 0);

	KotakTD[playerid][3] = CreatePlayerTextDraw(playerid, 282.000000, 161.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][3], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][3], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][3], 0);

	KotakTD[playerid][4] = CreatePlayerTextDraw(playerid, 134.000000, 222.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][4], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][4], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][4], 0);

	KotakTD[playerid][5] = CreatePlayerTextDraw(playerid, 183.000000, 222.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][5], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][5], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][5], 0);

	KotakTD[playerid][6] = CreatePlayerTextDraw(playerid, 232.000000, 222.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][6], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][6], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][6], 0);

	KotakTD[playerid][7] = CreatePlayerTextDraw(playerid, 282.000000, 222.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][7], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][7], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][7], 0);

	KotakTD[playerid][8] = CreatePlayerTextDraw(playerid, 133.000000, 283.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][8], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][8], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][8], 0);

	KotakTD[playerid][9] = CreatePlayerTextDraw(playerid, 183.000000, 283.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][9], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][9], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][9], 0);

	KotakTD[playerid][10] = CreatePlayerTextDraw(playerid, 232.000000, 283.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][10], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][10], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][10], 0);

	KotakTD[playerid][11] = CreatePlayerTextDraw(playerid, 282.000000, 283.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][11], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][11], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][11], 0);

	KotakTD[playerid][12] = CreatePlayerTextDraw(playerid, 133.000000, 344.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][12], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][12], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][12], 0);

	KotakTD[playerid][13] = CreatePlayerTextDraw(playerid, 184.000000, 344.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][13], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][13], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][13], 0);

	KotakTD[playerid][14] = CreatePlayerTextDraw(playerid, 233.000000, 345.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][14], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][14], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][14], 0);

	KotakTD[playerid][15] = CreatePlayerTextDraw(playerid, 282.000000, 343.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, KotakTD[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, KotakTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KotakTD[playerid][15], 45.000000, 54.000000);
	PlayerTextDrawSetOutline(playerid, KotakTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, KotakTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, KotakTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, KotakTD[playerid][15], -1094795696);
	PlayerTextDrawBackgroundColor(playerid, KotakTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, KotakTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, KotakTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, KotakTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, KotakTD[playerid][15], 0);

	AmountTD[playerid][0] = CreatePlayerTextDraw(playerid, 136.000000, 203.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][0], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][0], 0);

	AmountTD[playerid][1] = CreatePlayerTextDraw(playerid, 184.000000, 203.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][1], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][1], 0);

	AmountTD[playerid][2] = CreatePlayerTextDraw(playerid, 233.000000, 203.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][2], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][2], 0);

	AmountTD[playerid][3] = CreatePlayerTextDraw(playerid, 284.000000, 203.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][3], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][3], 0);

	AmountTD[playerid][4] = CreatePlayerTextDraw(playerid, 136.000000, 264.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][4], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][4], 0);

	AmountTD[playerid][5] = CreatePlayerTextDraw(playerid, 185.000000, 264.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][5], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][5], 0);

	AmountTD[playerid][6] = CreatePlayerTextDraw(playerid, 233.000000, 264.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][6], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][6], 0);

	AmountTD[playerid][7] = CreatePlayerTextDraw(playerid, 283.000000, 264.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][7], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][7], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][7], 0);

	AmountTD[playerid][8] = CreatePlayerTextDraw(playerid, 136.000000, 326.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][8], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][8], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][8], 0);

	AmountTD[playerid][9] = CreatePlayerTextDraw(playerid, 184.000000, 326.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][9], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][9], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][9], 0);

	AmountTD[playerid][10] = CreatePlayerTextDraw(playerid, 233.000000, 326.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][10], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][10], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][10], 0);

	AmountTD[playerid][11] = CreatePlayerTextDraw(playerid, 284.000000, 326.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][11], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][11], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][11], 0);

	AmountTD[playerid][12] = CreatePlayerTextDraw(playerid, 135.000000, 386.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][12], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][12], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][12], 0);

	AmountTD[playerid][13] = CreatePlayerTextDraw(playerid, 185.000000, 386.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][13], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][13], 0);

	AmountTD[playerid][14] = CreatePlayerTextDraw(playerid, 234.000000, 386.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][14], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][14], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][14], 0);

	AmountTD[playerid][15] = CreatePlayerTextDraw(playerid, 284.000000, 386.000000, "1x");
	PlayerTextDrawFont(playerid, AmountTD[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, AmountTD[playerid][15], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, AmountTD[playerid][15], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AmountTD[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, AmountTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, AmountTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, AmountTD[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, AmountTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, AmountTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, AmountTD[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, AmountTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, AmountTD[playerid][15], 0);

	NamaTD[playerid][0] = CreatePlayerTextDraw(playerid, 136.000000, 162.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][0], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][0], 0);

	NamaTD[playerid][1] = CreatePlayerTextDraw(playerid, 186.000000, 162.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][1], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][1], 0);

	NamaTD[playerid][2] = CreatePlayerTextDraw(playerid, 235.000000, 162.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][2], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][2], 0);

	NamaTD[playerid][3] = CreatePlayerTextDraw(playerid, 285.000000, 162.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][3], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][3], 0);

	NamaTD[playerid][4] = CreatePlayerTextDraw(playerid, 137.000000, 222.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][4], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][4], 0);

	NamaTD[playerid][5] = CreatePlayerTextDraw(playerid, 185.000000, 222.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][5], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][5], 0);

	NamaTD[playerid][6] = CreatePlayerTextDraw(playerid, 234.000000, 222.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][6], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][6], 0);

	NamaTD[playerid][7] = CreatePlayerTextDraw(playerid, 284.000000, 222.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][7], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][7], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][7], 0);

	NamaTD[playerid][8] = CreatePlayerTextDraw(playerid, 137.000000, 283.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][8], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][8], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][8], 0);

	NamaTD[playerid][9] = CreatePlayerTextDraw(playerid, 186.000000, 283.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][9], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][9], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][9], 0);

	NamaTD[playerid][10] = CreatePlayerTextDraw(playerid, 235.000000, 283.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][10], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][10], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][10], 0);

	NamaTD[playerid][11] = CreatePlayerTextDraw(playerid, 285.000000, 283.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][11], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][11], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][11], 0);

	NamaTD[playerid][12] = CreatePlayerTextDraw(playerid, 137.000000, 344.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][12], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][12], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][12], 0);

	NamaTD[playerid][13] = CreatePlayerTextDraw(playerid, 186.000000, 344.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][13], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][13], 0);

	NamaTD[playerid][14] = CreatePlayerTextDraw(playerid, 236.000000, 344.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][14], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][14], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][14], 0);

	NamaTD[playerid][15] = CreatePlayerTextDraw(playerid, 285.000000, 344.000000, "Radio");
	PlayerTextDrawFont(playerid, NamaTD[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, NamaTD[playerid][15], 0.204164, 1.049998);
	PlayerTextDrawTextSize(playerid, NamaTD[playerid][15], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, NamaTD[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, NamaTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, NamaTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, NamaTD[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, NamaTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, NamaTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, NamaTD[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, NamaTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, NamaTD[playerid][15], 0);

	BarangTD[playerid][0] = CreatePlayerTextDraw(playerid, 131.000000, 166.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][0], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][0], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][0], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][0], 1, 1);

	BarangTD[playerid][1] = CreatePlayerTextDraw(playerid, 180.000000, 166.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][1], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][1], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][1], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][1], 1, 1);

	BarangTD[playerid][2] = CreatePlayerTextDraw(playerid, 228.000000, 166.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][2], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][2], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][2], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][2], 1, 1);

	BarangTD[playerid][3] = CreatePlayerTextDraw(playerid, 279.000000, 166.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][3], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][3], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][3], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][3], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][3], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][3], 1, 1);

	BarangTD[playerid][4] = CreatePlayerTextDraw(playerid, 131.000000, 228.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][4], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][4], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][4], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][4], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][4], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][4], 1, 1);

	BarangTD[playerid][5] = CreatePlayerTextDraw(playerid, 179.000000, 228.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][5], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][5], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][5], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][5], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][5], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][5], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][5], 1, 1);

	BarangTD[playerid][6] = CreatePlayerTextDraw(playerid, 227.000000, 228.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][6], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][6], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][6], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][6], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][6], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][6], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][6], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][6], 1, 1);

	BarangTD[playerid][7] = CreatePlayerTextDraw(playerid, 277.000000, 228.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][7], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][7], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][7], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][7], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][7], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][7], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][7], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][7], 1, 1);

	BarangTD[playerid][8] = CreatePlayerTextDraw(playerid, 131.000000, 289.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][8], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][8], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][8], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][8], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][8], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][8], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][8], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][8], 1, 1);

	BarangTD[playerid][9] = CreatePlayerTextDraw(playerid, 180.000000, 289.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][9], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][9], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][9], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][9], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][9], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][9], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][9], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][9], 1, 1);

	BarangTD[playerid][10] = CreatePlayerTextDraw(playerid, 228.000000, 289.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][10], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][10], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][10], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][10], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][10], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][10], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][10], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][10], 1, 1);

	BarangTD[playerid][11] = CreatePlayerTextDraw(playerid, 279.000000, 289.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][11], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][11], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][11], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][11], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][11], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][11], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][11], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][11], 1, 1);

	BarangTD[playerid][12] = CreatePlayerTextDraw(playerid, 132.000000, 351.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][12], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][12], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][12], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][12], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][12], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][12], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][12], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][12], 1, 1);

	BarangTD[playerid][13] = CreatePlayerTextDraw(playerid, 181.000000, 351.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][13], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][13], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][13], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][13], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][13], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][13], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][13], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][13], 1, 1);

	BarangTD[playerid][14] = CreatePlayerTextDraw(playerid, 230.000000, 351.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][14], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][14], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][14], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][14], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][14], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][14], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][14], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][14], 1, 1);

	BarangTD[playerid][15] = CreatePlayerTextDraw(playerid, 280.000000, 351.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, BarangTD[playerid][15], 5);
	PlayerTextDrawLetterSize(playerid, BarangTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarangTD[playerid][15], 48.000000, 47.500000);
	PlayerTextDrawSetOutline(playerid, BarangTD[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, BarangTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, BarangTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, BarangTD[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, BarangTD[playerid][15], 0);
	PlayerTextDrawBoxColor(playerid, BarangTD[playerid][15], 0);
	PlayerTextDrawUseBox(playerid, BarangTD[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, BarangTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, BarangTD[playerid][15], 1);
	PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][15], 19835);
	PlayerTextDrawSetPreviewRot(playerid, BarangTD[playerid][15], -10.000000, 0.000000, -62.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, BarangTD[playerid][15], 1, 1);
}


//Inventory
function Inventory_Clear(playerid)
{
    static
	    string[64];
	    
	forex(i, MAX_INVENTORY)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
	        InventoryData[playerid][i][invQuantity] = 0;
		}
	}
	format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d'", pData[playerid][pID]);
	return mysql_tquery(g_SQL, string);
}

function Inventory_GetItemID(playerid, item[])
{
	forex(i, MAX_INVENTORY)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;
		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

function Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= 100)
		return -1;
	forex(i, MAX_INVENTORY)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}


function Inventory_Items(playerid)
{
    new count;
    forex(i, MAX_INVENTORY) if (InventoryData[playerid][i][invExists]) {
        count++;
	}
	return count;
}


function Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid != -1)
	    return InventoryData[playerid][itemid][invQuantity];
	return 0;
}

function PlayerHasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

function Inventory_Set(playerid, item[], model, amount)
{
	new itemid = Inventory_GetItemID(playerid, item);
	if (itemid == -1 && amount > 0)
		Inventory_Add(playerid, item, model, amount);
	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount);
	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);
	return 1;
}

function Inventory_SetQuantity(playerid, item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item),
		string[128];
	if (itemid != -1)
	{
	    format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(g_SQL, string);
     	//TambahkanBerat(playerid, itemid);
	    InventoryData[playerid][itemid][invQuantity] = quantity;
	}
	return 1;
}

function Inventory_Show(playerid)
{
	if(!IsPlayerConnected(playerid))
		return 0;

	PlayerTextDrawSetString(playerid, InventoryTD[playerid][1], GetName(playerid));
	forex(i, 11)
	{
	    PlayerTextDrawShow(playerid, InventoryTD[playerid][i]);
	}
	new asu [120];
	format(asu, sizeof(asu), "%.1f/50.0_kg", pData[playerid][pBeratItem]);
    PlayerTextDrawSetString(playerid, InventoryTD[playerid][2], asu);
    PlayerTextDrawShow(playerid, InventoryTD[playerid][2]);

    new Float:jumlahbar = pData[playerid][pBeratItem] * 193.0/1000;
    PlayerTextDrawTextSize(playerid, InventoryTD[playerid][4], jumlahbar, 4.0);
    PlayerTextDrawShow(playerid, InventoryTD[playerid][4]);
	SelectTextDraw(playerid, 0xAFAFAFFF);
	forex(i, MAX_INVENTORY)
	{
	    new str[120], string[120];
	    PlayerTextDrawShow(playerid, KotakTD[playerid][i]);
        if(InventoryData[playerid][i][invExists])
		{
			PlayerTextDrawShow(playerid, NamaTD[playerid][i]);
			PlayerTextDrawSetPreviewModel(playerid, BarangTD[playerid][i], InventoryData[playerid][i][invModel]);
			
			PlayerTextDrawShow(playerid, BarangTD[playerid][i]);
			strunpack(string, InventoryData[playerid][i][invItem]);
			format(str, sizeof(str), "%s", string);
			PlayerTextDrawSetString(playerid, NamaTD[playerid][i], str);
			PlayerTextDrawShow(playerid, AmountTD[playerid][i]);
			format(str, sizeof(str), "%d", InventoryData[playerid][i][invQuantity]);
			PlayerTextDrawSetString(playerid, AmountTD[playerid][i], str);
		}
	}
	return 1;
}

function Inventory_Close(playerid)
{
	forex(i, 11)
	{
	    PlayerTextDrawHide(playerid, InventoryTD[playerid][i]);
	}
	forex(u, MAX_INVENTORY)
	{
	    PlayerTextDrawHide(playerid, BarangTD[playerid][u]);
	    PlayerTextDrawHide(playerid, NamaTD[playerid][u]);
	    PlayerTextDrawHide(playerid, AmountTD[playerid][u]);
	    PlayerTextDrawHide(playerid, KotakTD[playerid][u]);
	}
	CancelSelectTextDraw(playerid);
	pData[playerid][pSelectItem] = -1;
	return 1;
}
/*Function:OnPlayerUseInvItem(playerid, itemid, name[])
{
    else if(!strcmp(name, "Cellphone", true)) {
        cmd_phone(playerid, "\1");
    }
    else if(!strcmp(name, "Portable Radio", true)) {
        SendSyntaxMessage(playerid, "Use \"/pr [text]\" to chat with your radio.");
    }
    return 1;
}*/
static Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];
	if (itemid != -1)
	{
	    if (InventoryData[playerid][itemid][invQuantity] > 0)
	    {
	        if(!strcmp(item, "Money", true))
			{
			    pData[playerid][pBeratItem] -= quantity*0.2;
			}
			else if(!strcmp(item, "Marijuana", true))
			{
			    pData[playerid][pBeratItem] -= quantity*0.5;
			}
			else if(!strcmp(item, "Cellphone", true))
			{
			   	pData[playerid][pBeratItem] -= quantity*5.0;
			}
			SendClientMessageEx(playerid, -1, "Inventory anda sekarang adalah %.1f/50.0kg", pData[playerid][pBeratItem]);
	        InventoryData[playerid][itemid][invQuantity] -= quantity;
		}
		if (quantity == -1 || InventoryData[playerid][itemid][invQuantity] < 1)
		{
		    InventoryData[playerid][itemid][invExists] = false;
		    InventoryData[playerid][itemid][invModel] = 0;
		    InventoryData[playerid][itemid][invQuantity] = 0;
		    format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d' AND `invID` = '%d'", pData[playerid][pID], InventoryData[playerid][itemid][invID]);
	        mysql_tquery(g_SQL, string);
		}
		else if (quantity != -1 && InventoryData[playerid][itemid][invQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
            mysql_tquery(g_SQL, string);
		}
		return 1;
	}
	return 0;
}

function TambahkanBerat(playerid, item[], quantity)
{
    if(pData[playerid][pBeratItem] >= 50.0) return SendClientMessage(playerid, -1, "Inventory anda telah penuh!"), Inventory_Close(playerid);
   	if(!strcmp(item, "Snack", true))
	{
	    pData[playerid][pBeratItem] += quantity*0.2;
	    
	}
	else if(!strcmp(item, "Marijuana", true))
	{
	    pData[playerid][pBeratItem] += quantity*0.5;
	}
	else if(!strcmp(item, "Cellphone", true))
	{
	    if(PlayerHasItem(playerid, "Cellphone")) return SendClientMessage(playerid, -1, "Anda telah memiliki Handphone"), Inventory_Close(playerid);
	    pData[playerid][pBeratItem] += quantity*5.0;
	}
	SendClientMessageEx(playerid, -1, "Inventory anda sekarang adalah %.1f/50.0kg", pData[playerid][pBeratItem]);
	return 1;
}

static Inventory_Add(playerid, item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];
		
	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);
	    if (itemid != -1)
	    {
			TambahkanBerat(playerid, item, quantity);
	        InventoryData[playerid][itemid][invExists] = true;
	        InventoryData[playerid][itemid][invModel] = model;
	        InventoryData[playerid][itemid][invQuantity] = quantity;
	        strpack(InventoryData[playerid][itemid][invItem], item, 32 char);
	        format(string, sizeof(string), "INSERT INTO `inventory` (`ID`, `invItem`, `invModel`, `invQuantity`) VALUES('%d', '%s', '%d', '%d')", pData[playerid][pID], item, model, quantity);
			mysql_tquery(g_SQL, string, "OnInventoryAdd", "dd", playerid, itemid);
	        return itemid;
		}
		return -1;
	}
	else
	{
     	if(pData[playerid][pBeratItem] >= 50.0) return SendClientMessage(playerid, -1, "Inventory anda telah penuh!"), Inventory_Close(playerid);
      	if(!strcmp(item, "Snack", true))
		{
		    pData[playerid][pBeratItem] += quantity*0.2;
		}
		else if(!strcmp(item, "Marijuana", true))
		{
		    pData[playerid][pBeratItem] += quantity*0.5;
		}
		else if(!strcmp(item, "Cellphone", true))
		{
		    if(PlayerHasItem(playerid, "Cellphone")) return SendClientMessage(playerid, -1, "Anda telah memiliki Handphone"), Inventory_Close(playerid);
		    pData[playerid][pBeratItem] += quantity*5.0;
		}
		SendClientMessageEx(playerid, -1, "Inventory anda sekarang adalah %.1f/50.0kg", pData[playerid][pBeratItem]);
		InventoryData[playerid][itemid][invQuantity] += quantity;
        format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` + %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(g_SQL, string);
	}
	return itemid;
}

/*function PanSel(playerid)
{
    new str[256], string[256];
    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], InventoryData[playerid][pData[playerid][pSelectItem]][invItem], true))
	{
	    strunpack(string, InventoryData[playerid][i][invItem]);
        format(str, sizeof(str), "%s", string);
		PlayerTextDrawSetString(playerid, InventoryTD[playerid][16], str);
		format(str, sizeof(str), "%d", InventoryData[playerid][i][invQuantity]);
		PlayerTextDrawSetString(playerid, InventoryTD[playerid][18], str);
	    PlayerTextDrawShow(playerid, InventoryTD[playerid][16]);
	    PlayerTextDrawShow(playerid, InventoryTD[playerid][18]);
	}
	return 1;
}*/
function LoadInventory(playerid, item[])
{
    new cname[50];
	new rows = cache_num_rows();
    if(rows)
  	{
		for (new i = 0; i < rows && i < MAX_INVENTORY; i ++)
		{
			cache_get_value_name(i, "invItem",  cname);
			strpack(InventoryData[playerid][i][invItem], cname, 32 char);
			InventoryData[playerid][i][invExists] = true;
			cache_get_value_name_int(i, "invID", InventoryData[playerid][i][invID]);
			cache_get_value_name_int(i, "invModel", InventoryData[playerid][i][invModel]);
			cache_get_value_name_int(i, "invQuantity", InventoryData[playerid][i][invQuantity]);
		}
	}
}
CMD:setitem(playerid, params[])
{
	new
		item[32],
		amount;
	if (sscanf(params, "ds[32]", amount, item))
	    return SendClientMessage(playerid, -1, "USAGE: /setitem [amount] [Check cons g_aInventoryItems]");
	for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
	{
        Inventory_Add(playerid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);
		return SendClientMessageEx(playerid, -1, "INFO: You have set your \"%s\" to %d.", item, amount);
	}
	SendClientMessage(playerid, -1, "ERROR: Invalid item name!.");
	return 1;
}

CMD:inventory(playerid, params[])
{
	Inventory_Show(playerid);
	return 1;
}
#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_INVAMOUNT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		{
		    new asu [120];
			format(asu, sizeof(asu), "%d", pData[playerid][pKirim]);
    		PlayerTextDrawSetString(playerid, InventoryTD[playerid][2], asu);
			pData[playerid][pKirim] = amount;
		}
	}
	return 1;
}
