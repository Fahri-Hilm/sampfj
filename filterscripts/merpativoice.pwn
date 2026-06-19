// COLOR DEFINE
#define 	WARNA_MERAH		"{FF0000}"
#define 	WARNA_KUNING	"{FFFF00}"
#define 	WARNA_BIRU		"{0099FF}"
#define 	WARNA_PUTIH		"{FFFFFF}"

#define FILTERSCRIPT

#include <a_samp>
#include <sampvoice>
#include <sscanf2>

#include <zcmd>


// RADIO DEFINE
//#define 	MAX_PLAYERS 1000
#define 	MAX_FREQUENSI	9999
#define 	MAX_CHANEL	10

// MESSAGE DEFINE
#define 	Info(%1,%2)		SendClientMessage(%1, -1, ""WARNA_BIRU"[INFO]: "WARNA_PUTIH""%2)
#define 	Error(%1,%2)	SendClientMessage(%1, -1, ""WARNA_MERAH"[ERROR]: "WARNA_PUTIH""%2)
#define 	Usage(%1,%2)	SendClientMessage(%1, -1, ""WARNA_KUNING"[USAGE]: "WARNA_PUTIH""%2)

// OTHER DEFINE
#define function%0(%1) forward %0(%1); public %0(%1)
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new SV_LSTREAM:localStream[MAX_PLAYERS] = SV_NULL;
new SV_GSTREAM:radioStream[MAX_FREQUENSI] = SV_NULL;
new SV_GSTREAM:siaranStream[MAX_CHANEL] = SV_NULL;



// DIALOG DEFINE
enum
{
    DIALOG_RADIOSETTINGS,
    DIALOG_SETFREQ,
    DIALOG_SETSFX,
    DIALOG_SHOPELE
}

// PLAYER DATA
enum E_PLAYERS
{
    pID,
    pName[MAX_PLAYER_NAME],
    pMoney,
    bool: IsLoggedIn,
    bool: dataTerload,
    pRadio,
    pTogRadio,
    pTogMic,
    pFreqSiaran,
    pTogSiaran,
    pMic,
    pFreqRadio,
    pSfxTurnOn,
    pFaction,
    pSfxTurnOff
};
new pData[MAX_PLAYERS][E_PLAYERS];

// ---=== HANDLE ===---
/*#include    "MERPATIVOICE\DEFINE.pwn"
#include    "MERPATIVOICE\FUNCTIONS.pwn"
#include    "MERPATIVOICE\COMMANDS.pwn"
#include    "MERPATIVOICE\DIALOGS.pwn"
*/
main()
{

}

public OnFilterScriptInit()
{

    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        radioStream[i] = SvCreateGStream(0xDB881AFF, "Radio");
    }
    for(new i = 0; i < MAX_CHANEL; i++)
    {
        siaranStream[i] = SvCreateGStream(0xDB881AFF, "Siaran");
    }
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOn(pData[playerid][pFreqRadio]);
        if(pData[playerid][pSfxTurnOn] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micon.ogg");
    	ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
        if(!IsPlayerAttachedObjectSlotUsed(playerid, 9)) SetPlayerAttachedObject(playerid, 9, 19942, 2, 0.0300, 0.1309, -0.1060, 118.8998, 19.0998, 164.2999);
        SvAttachSpeakerToStream(radioStream[pData[playerid][pFreqRadio]], playerid);
    }
    if(keyid == 0x42 && pData[playerid][pFreqSiaran] >= 1 && pData[playerid][pMic] == 1 && pData[playerid][pTogSiaran] == 1)
    {
        SvAttachSpeakerToStream(siaranStream[pData[playerid][pFreqSiaran]], playerid);
    }

    if (keyid == 0x42 && localStream[playerid]) SvAttachSpeakerToStream(localStream[playerid], playerid); // Local Stream
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOff(pData[playerid][pFreqRadio]);
        if(pData[playerid][pSfxTurnOff] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micoff.ogg");
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        SvDetachSpeakerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);
        if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
    }
    if(keyid == 0x42 && pData[playerid][pFreqSiaran] >= 1 && pData[playerid][pMic] == 1 && pData[playerid][pTogSiaran] == 1)
    {
        SvDetachSpeakerFromStream(siaranStream[pData[playerid][pFreqSiaran]], playerid);
    }

    if (keyid == 0x42 && localStream[playerid]) SvDetachSpeakerFromStream(localStream[playerid], playerid); // Local Stream
}

public OnPlayerConnect(playerid)
{
    if (SvGetVersion(playerid) == SV_NULL)
    {
    	Error(playerid, "Tidak dapat menemukan plugin sampvoice.");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
    	Error(playerid, "Mikrofon tidak dapat ditemukan.");
    }
    else if ((localStream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid)))
    {
    	Info(playerid, "Tekan B Untuk Berkomunikasi Di Sekitar Player. (Pengguna PC)");
        SvAddKey(playerid, 0x42);
    }

    GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
    pData[playerid][IsLoggedIn] = true;
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES)
	{
        //if(pData[playerid][pRadio] == 0) return 1;
        if(pData[playerid][pTogMic] == 0)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio Aktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 1;
        }
        else if(pData[playerid][pTogMic] == 1)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio NonAktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 0;
        }
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (localStream[playerid])
    {
        SvDeleteStream(localStream[playerid]);
        localStream[playerid] = SV_NULL;
    }

    printf("[MySql]: Berhasil Menyimpan Data Player %s Dengan ID %d", GetPlayerNameEx(playerid), pData[playerid][pID]);

    ResetDataVoicePlayer(playerid);

    pData[playerid][dataTerload] = false;
    pData[playerid][IsLoggedIn] = false;
    return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        SvDeleteStream(radioStream[i]);
    }
    for(new i = 0; i < MAX_CHANEL; i++)
    {
        SvDeleteStream(siaranStream[i]);
    }
	return 1;
}
function ConnectToFrequensi(playerid, freq, bool:rConnected)
{
    if(freq == 0) return 1;
    if(rConnected == true)
    {
        new msgToFreq[256];
        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Keluar Dari Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], msgToFreq);

        new msgFreq[256];
        format(msgFreq, sizeof msgFreq, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d){FFFFFF}, Dan terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio], freq);
        SendClientMessage(playerid, -1, msgFreq);

        SvDetachSpeakerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);
        SvDetachListenerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);

        pData[playerid][pFreqRadio] = freq;

        SvAttachListenerToStream(radioStream[freq], playerid);

        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Terhubung Ke Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], msgToFreq);
    }
    else if(rConnected == false)
    {
        pData[playerid][pFreqRadio] = freq;
        SvAttachListenerToStream(radioStream[freq], playerid);

        new string[128];
        format(string, 128, ""WARNA_KUNING"[RADIO]:"WARNA_PUTIH" Anda berhasil Terhubung ke Frequensi: {ff0000}(%d).", freq);
        SendClientMessage(playerid, 0x00AE00FF, string);

        format(string, 128, "{FF0000}(%s){FFFFFF} Telah Terhubung ke frequensi {ff0000}(%d)", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], string);
    }
    return 1;
}
function ConnectToSiaran(playerid, siaran, bool:sConnected)
{
    if(siaran == 0) return 1;
    if(sConnected == true)
    {
        new msgToFreq[256];
        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Keluar Dari Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqSiaran]);
        SendMessageToFrequensi(pData[playerid][pFreqSiaran], msgToFreq);

        new msgFreq[256];
        format(msgFreq, sizeof msgFreq, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d){FFFFFF}, Dan terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqSiaran], siaran);
        SendClientMessage(playerid, -1, msgFreq);

        SvDetachSpeakerFromStream(siaranStream[pData[playerid][pFreqSiaran]], playerid);
        SvDetachListenerFromStream(siaranStream[pData[playerid][pFreqSiaran]], playerid);

        pData[playerid][pFreqSiaran] = siaran;

        SvAttachListenerToStream(siaranStream[siaran], playerid);

        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Terhubung Ke Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqSiaran]);
        SendMessageToFrequensi(pData[playerid][pFreqSiaran], msgToFreq);
    }
    else if(sConnected == false)
    {
        pData[playerid][pFreqSiaran] = siaran;
        SvAttachListenerToStream(siaranStream[siaran], playerid);

        new string[128];
        format(string, 128, ""WARNA_KUNING"[RADIO]:"WARNA_PUTIH" Anda berhasil Terhubung ke Frequensi: {ff0000}(%d).", siaran);
        SendClientMessage(playerid, 0x00AE00FF, string);

        format(string, 128, "{FF0000}(%s){FFFFFF} Telah Terhubung ke frequensi {ff0000}(%d)", GetPlayerNameEx(playerid), pData[playerid][pFreqSiaran]);
        SendMessageToFrequensi(pData[playerid][pFreqSiaran], string);
    }
    return 1;
}
function DisconnectToFrequensi(playerid, freq, bool:togOnRadio)
{
    SvDetachListenerFromStream(radioStream[freq], playerid);
    SvDetachSpeakerFromStream(radioStream[freq], playerid);

    new msgToFreq[256];
    format(msgToFreq, 256, "{ff0000}(%s) {FFFFFF}Telah Keluar Dari Frequensi: {FF0000}(%d).", GetPlayerNameEx(playerid), freq);
    SendMessageToFrequensi(freq, msgToFreq);

    new msgFreq[256];
    format(msgFreq, 256, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d).", freq);
    SendClientMessage(playerid, -1, msgFreq);

    if(togOnRadio == false)
    {
        pData[playerid][pFreqRadio] = 0;
    }
    return 1;
}
function DisconnectToSiaran(playerid, siaran, bool:togOnSiaran)
{
    SvDetachListenerFromStream(siaranStream[siaran], playerid);
    SvDetachSpeakerFromStream(siaranStream[siaran], playerid);

    new msgToFreq[256];
    format(msgToFreq, 256, "{ff0000}(%s) {FFFFFF}Telah Keluar Dari Frequensi: {FF0000}(%d).", GetPlayerNameEx(playerid), siaran);
    SendMessageToFrequensi(siaran, msgToFreq);

    new msgFreq[256];
    format(msgFreq, 256, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d).", siaran);
    SendClientMessage(playerid, -1, msgFreq);

    if(togOnSiaran == false)
    {
        pData[playerid][pFreqSiaran] = 0;
    }
    return 1;
}
// ---=== STOCK ===---

stock GetPlayerNameEx(playerid)
{
    new getName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, getName, MAX_PLAYER_NAME);
    return getName;
}

stock ResetDataVoicePlayer(playerid)
{
    pData[playerid][pID] = 0;
    pData[playerid][pRadio] = 0;
    pData[playerid][pTogRadio] = 0;
    pData[playerid][pTogMic] = 0;
    pData[playerid][pFreqRadio] = 0;
    pData[playerid][pSfxTurnOn] = 0;
    pData[playerid][pSfxTurnOff] = 0;
    pData[playerid][IsLoggedIn] = false;
}

stock SendMessageToFrequensi(freq, msg[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq)
            {
            	new getMsg[256];
            	format(getMsg, 256, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"%s", msg);
                SendClientMessage(i, -1, getMsg);
            }
        }
    }
    return 1;
}

stock PlaySoundToFrequensi(freq, getUrl[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq)
            {
                PlayAudioStreamForPlayer(i, getUrl);
            }
        }
    }
    return 1;
}

stock SfxSoundTurnOn(freq)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq && pData[i][pSfxTurnOn] == 1)
            {
                PlayAudioStreamForPlayer(i, "http://20.213.160.211/music/micon.ogg");
            }
        }
    }
}

stock SfxSoundTurnOff(freq)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq && pData[i][pSfxTurnOff] == 1)
            {
                PlayAudioStreamForPlayer(i, "http://20.213.160.211/music/micoff.ogg");
            }
        }
    }
}

/*public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_RADIOSETTINGS)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    return callcmd::togradio(playerid);
                }
                case 1:
                {
                    return callcmd::togmic(playerid);
                }
                case 2:
                {
                    ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "Masukkan Frequensi Radio Yang Ingin Kamu Hubungkan (Maksimal 1 - 99999)", "Hubungkan", "Tutup");
                }
                case 3:
                {
                    new str[256], togSfxTurnOn[256], togSfxTurnOff[256];
                    if(pData[playerid][pSfxTurnOn] == 0)
                    {
                        togSfxTurnOn = "{ff0000}Disable";
                    }
                    else if(pData[playerid][pSfxTurnOn] == 1)
                    {
                        togSfxTurnOn = "{00ff00}Enable";
                    }

                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        togSfxTurnOff = "{ff0000}Disable";
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        togSfxTurnOff = "{00ff00}Enable";
                    }

                    format(str, sizeof(str), "Sound Effect Settings\tStatus\n{FFFFFF}Status FX TurnON:\t%s\n{FFFFFF}Status FX TurnOFF:\t%s\n{FFFFFF}Hidupkan Semua FX\n{FFFFFF}Matikan Semua FX", togSfxTurnOn, togSfxTurnOff);
                }
                case 4:
                {
                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        pData[playerid][pSfxTurnOff] = 1;
                        Info(playerid, "(Sfx Turning Off) Radio Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        pData[playerid][pSfxTurnOff] = 0;
                        Info(playerid, "(Sfx Turning Off) Radio Berhasil Dimatikan.");
                    }
                }
            }
        }
    }
    if(dialogid == DIALOG_SETFREQ)
    {
        if(response)
        {
            new Frequensi = strval(inputtext);

            if(isnull(inputtext))
            {
                ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "{ff0000}ERROR: {FFFFFF}Harap Input Frequensi Yang Benar\n\nMasukkan Frequensi Radio Yang Ingin Anda Hubungkan (Maksimal 1 - 99999)", "Hubungkan", "Tutup");
                return 1;
            }
            if(Frequensi > 99999 || Frequensi < 0)
            {
                ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "{ff0000}ERROR: {FFFFFF}Maksimal Frequensi 1 - 99999\n\nMasukkan Frequensi Radio Yang Ingin Anda Hubungkan (Maksimal 1 - 99999)", "Hubungkan", "Tutup");
                return 1;
            }

            if(pData[playerid][pFreqRadio] >= 1)
            {
                ConnectToFrequensi(playerid, Frequensi, true);
            }
            else if(pData[playerid][pFreqRadio] == 0)
            {
                ConnectToFrequensi(playerid, Frequensi, false);
            }
        }
    }
    if(dialogid == DIALOG_SETSFX)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(pData[playerid][pSfxTurnOn] == 0)
                    {
                        pData[playerid][pSfxTurnOn] = 1;
                        Info(playerid, "(FX) Radio TurnON Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOn] == 1)
                    {
                        pData[playerid][pSfxTurnOn] = 0;
                        Info(playerid, "(FX) Radio TurnON Berhasil Dimatikan.");
                    }
                }
                case 1:
                {
                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        pData[playerid][pSfxTurnOff] = 1;
                        Info(playerid, "(FX) Radio TurnOFF Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        pData[playerid][pSfxTurnOff] = 0;
                        Info(playerid, "(FX) Radio TurnOFF Berhasil Dimatikan.");
                    }
                }
                case 2:
                {
                    if(pData[playerid][pSfxTurnOn] == 1 && pData[playerid][pSfxTurnOff] == 1) return Error(playerid, "(FX) Radio Anda telah Aktif");

                    pData[playerid][pSfxTurnOn] = 1;
                    pData[playerid][pSfxTurnOff] = 1;

                    Info(playerid, "(FX) Radio anda berhasil di aktifkan semua");
                }
                case 3:
                {
                    if(pData[playerid][pSfxTurnOn] == 0 && pData[playerid][pSfxTurnOff] == 0) return Error(playerid, "(FX) Radio Anda telah Nonaktif");

                    pData[playerid][pSfxTurnOn] = 0;
                    pData[playerid][pSfxTurnOff] = 0;

                    Info(playerid, "(FX) Radio anda berhasil di Nonaktifkan semua");
                }
            }
        }yu
    }*/
  /*  if(dialogid == DIALOG_SHOPELE)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    new getMoney = GetPlayerMoney(playerid);
                    if(pData[playerid][pRadio] == 1) return Error(playerid, "Anda sudah memiliki radio.");
                    if(getMoney < 10000) return Error(playerid, "Uang Anda Kurang");
                    GivePlayerMoney(playerid, -10000);
                    pData[playerid][pRadio] = 1;
                    Info(playerid, "Anda berhasil membeli radio dengan harga $10.000");
                }
            }
        }
    }
    return 1;
}*/

// ---=== RADIO COMMANDS ====---
CMD:togsfx(playerid)
{

	if(pData[playerid][pSfxTurnOn] == 0)
	{
	    pData[playerid][pSfxTurnOn] = 1;
	}
	else if(pData[playerid][pSfxTurnOn] == 1)
	{
	    pData[playerid][pSfxTurnOn] = 0;
	}
	if(pData[playerid][pSfxTurnOff] == 0)
	{
	    pData[playerid][pSfxTurnOff] = 1;
	}
	else if(pData[playerid][pSfxTurnOff] == 1)
	{
        pData[playerid][pSfxTurnOff] = 0;
	}
	return 1;
}
CMD:togmic(playerid)
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

    if(pData[playerid][pTogMic] == 0)
    {
        if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
        if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

        new msgRadio[256];
        format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio Aktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
        SendClientMessage(playerid, -1, msgRadio);

        pData[playerid][pTogMic] = 1;
    }
    else if(pData[playerid][pTogMic] == 1)
    {
        if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
        if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

        new msgRadio[256];
        format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio NonAktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
        SendClientMessage(playerid, -1, msgRadio);

        pData[playerid][pTogMic] = 0;
    }
    return 1;
}
CMD:togradio(playerid)
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

	if(pData[playerid][pTogRadio] == 0)
	{
		if(pData[playerid][pFreqRadio] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {7FFF00}dihidupakan{FFFFFF}");
            SendClientMessage(playerid, -1, msgTogRadio);
			ConnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
            pData[playerid][pTogRadio] = 1;
		}
        else
        {
            Info(playerid, "Radio anda berhasil Dihidupkan.");
            pData[playerid][pTogRadio] = 1;
        }
	}
	else if(pData[playerid][pTogRadio] == 1)
	{
		if(pData[playerid][pFreqRadio] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {FF0000}dimatikan{FFFFFF}.");
			SendClientMessage(playerid, -1, msgTogRadio);
            DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], true);
            pData[playerid][pTogRadio] = 0;
		}
        else
        {
            Info(playerid, "Radio anda berhasil Dimatikan.");
            pData[playerid][pTogRadio] = 0;
        }
	}
	return 1;
}
CMD:siaran(playerid)
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

    if(pData[playerid][pMic] == 0)
    {
        if(pData[playerid][pTogSiaran] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
        if(pData[playerid][pFreqSiaran] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

        new msgRadio[256];
        format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio FM Aktif, terhubung ke Siaran: {ff0000}(%d) FM.", pData[playerid][pFreqSiaran]);
        SendClientMessage(playerid, -1, msgRadio);

        pData[playerid][pMic] = 1;
    }
    else if(pData[playerid][pMic] == 1)
    {
        if(pData[playerid][pTogSiaran] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
        if(pData[playerid][pFreqSiaran] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

        new msgRadio[256];
        format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio FM NonAktif, terhubung ke Siaran: {ff0000}(%d) FM.", pData[playerid][pFreqSiaran]);
        SendClientMessage(playerid, -1, msgRadio);

        pData[playerid][pMic] = 0;
    }
    return 1;
}
stock PlayLagu(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(pData[playerid][pTogSiaran] == 0)
	{
		if(pData[playerid][pFreqSiaran] >= 1)
		{
	 		PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
		}
	}
	else if(pData[playerid][pTogSiaran] == 1)
	{
		if(pData[playerid][pFreqSiaran] >= 1)
		{
    		StopAudioStreamForPlayer(playerid);
		}
	}
}
CMD:jahil(playerid, params[])
{
	/*if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);*/

	new songname[128], otherid, tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "ds[128]", otherid, songname))
	{
		Usage(playerid, "/jahil Otherid <link>");
		return 1;
	}

	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	PlayAudioStreamForPlayer(otherid, tmp);
	return 1;
}
CMD:playlagu(playerid, params[])
{
	/*if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);*/

	new songname[128], player, tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		Usage(playerid, "/playlagu <link>");
		return 1;
	}

	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	if(pData[player][pFreqSiaran] == 1)
	{
		PlayAudioStreamForPlayer(player, tmp);
	}
	return 1;
}
CMD:togsiaran(playerid)
{
	if(pData[playerid][pTogSiaran] == 0)
	{
		if(pData[playerid][pFreqSiaran] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"|___________ Menghidupkan Radio FM ___________|");
            SendClientMessage(playerid, -1, msgTogRadio);
			ConnectToSiaran(playerid, pData[playerid][pFreqSiaran], false);
            pData[playerid][pTogSiaran] = 1;
		}
        else
        {
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"|___________ Menghidupkan Radio FM ___________|");
            SendClientMessage(playerid, -1, msgTogRadio);
            pData[playerid][pTogSiaran] = 1;
        }
	}
	else if(pData[playerid][pTogSiaran] == 1)
	{
		if(pData[playerid][pFreqSiaran] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"|___________ Mematikan Radio FM ___________|");
			SendClientMessage(playerid, -1, msgTogRadio);
            DisconnectToSiaran(playerid, pData[playerid][pFreqSiaran], true);
            StopAudioStreamForPlayer(playerid);
            pData[playerid][pTogSiaran] = 0;
		}
        else
        {
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"|___________ Mematikan Radio FM ___________|");
			SendClientMessage(playerid, -1, msgTogRadio);
            pData[playerid][pTogSiaran] = 0;
        }
	}
	return 1;
}
CMD:setsiaran(playerid, params[])
{
	if(pData[playerid][pTogSiaran] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");

    new siaran;
    if(sscanf(params, "d", siaran)) return Usage(playerid, "/setsiaran [Frequensi yang tersedia hanya 1]");
    if(siaran > 1 || siaran < 0) return Error(playerid, "Frequensi Tidak Valid, Maksimal Frequensi 1 !");
    if(siaran == pData[playerid][pFreqSiaran]) return Error(playerid, "Kamu sedang berada di Siaran Yang Anda Input.");

    if(siaran == 0)
    {
    	DisconnectToSiaran(playerid, pData[playerid][pFreqSiaran], false);
    }
    else
    {
        if(pData[playerid][pFreqSiaran] >= 1)
        {
            SetTimerEx("ConnectToSiaran", 100, false, "idb", playerid, siaran, true);
            //SavePlayerDataVoice(playerid);
        }

        if(pData[playerid][pFreqSiaran] == 0)
        {
            SetTimerEx("ConnectToSiaran", 100, false, "idb", playerid, siaran, false);
        }
    }
    return 1;
}
CMD:setradio(playerid, params[])
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");
	if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");

    new freq;
    if(sscanf(params, "d", freq)) return Usage(playerid, "/setradio [Frequensi]");
    if(freq > 99999 || freq < 0) return Error(playerid, "Frequensi Tidak Valid, Maksimal Frequensi 1 - 99999!");
    if(freq == pData[playerid][pFreqRadio]) return Error(playerid, "Kamu sedang berada di Frequensi Yang Anda Input.");

    if(freq == 0)
    {
    	DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
    }
    else
    {
        if(pData[playerid][pFreqRadio] >= 1)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, true);
        }

        if(pData[playerid][pFreqRadio] == 0)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, false);
        }
    }
    return 1;
}
/*CMD:setradiof(playerid, params[])
{
    if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");
	if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
	if(pData[playerid][pFaction] != 1) return Error(playerid, "cuk");

    new freq;
    if(sscanf(params, "d", freq)) return Usage(playerid, "/setradio [Frequensi]");
    if(freq > 10 || freq < 0) return Error(playerid, "Frequensi Tidak Valid, Maksimal Frequensi 1 - 99999!");
    if(freq == pData[playerid][pFreqRadio]) return Error(playerid, "Kamu sedang berada di Frequensi Yang Anda Input.");

    if(freq == 0)
    {
    	DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
    }
    else
    {
        if(pData[playerid][pFreqRadio] >= 1)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, true);
            SavePlayerDataVoice(playerid);
        }

        if(pData[playerid][pFreqRadio] == 0)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, false);
        }
    }
    return 1;
}*/

CMD:minti(playerid, params[])
{
    if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

    new str[1024], togRadio[64], togMic[64], radioFreq[64];
    if(pData[playerid][pTogRadio] == 0)
    {
        togRadio = "{ff0000}Disable";
    }
    else if(pData[playerid][pTogRadio] == 1)
    {
        togRadio = "{00ff00}Enable";
    }

    if(pData[playerid][pTogMic] == 0)
    {
        togMic = "{ff0000}Disconnected";
    }
    else
    {
        togMic = "{00ff00}Connected";
    }

    if(pData[playerid][pFreqRadio] == 0)
    {
        radioFreq = "{ff0000}Freq Not Connected";
    }
    else if(pData[playerid][pFreqRadio] >= 1)
    {
        format(radioFreq, sizeof radioFreq, "{00ff00}%d", pData[playerid][pFreqRadio]);
    }

    format(str, sizeof(str), "Radio Settings\tStatus\n{FFFFFF}Status Radio:\t%s\n{FFFFFF}Status Mic:\t%s\n{FFFFFF}Frequensi Radio:\t%s\n{FFFFFF}Atur FX Radio", togRadio, togMic, radioFreq);

    ShowPlayerDialog(playerid, DIALOG_RADIOSETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Radio Settings", str, "Set", "Close");

    return 1;
}

CMD:buangradio(playerid, params[])
{
    if(pData[playerid][pRadio] < 1) return Error(playerid, "Anda tidak memiliki radio.");
    {
	    pData[playerid][pRadio] -= 1;
		Info(playerid, "Anda berhasil membeli radio dengan harga $10.000");
	}
	return 1;
}
CMD:buyradio(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2441.419921,1298.619995,10.820312)) return Info(playerid, "Kamu tidak berada di pasar");
    {
    				new getMoney = GetPlayerMoney(playerid);
                    if(pData[playerid][pRadio] == 1) return Error(playerid, "Anda sudah memiliki radio.");
                    if(getMoney < 10000) return Error(playerid, "Uang Anda Kurang");
                    GivePlayerMoney(playerid, -10000);
                    pData[playerid][pRadio] = 1;
                    Info(playerid, "Anda berhasil membeli radio dengan harga $10.000");
	}
    return 1;
}
CMD:s(playerid)
{
	SvUpdateDistanceForLStream(localStream[playerid], 20.0);
	SendClientMessage(playerid, 0xFF0000FF, "[INFO] Anda telah memperbesar distance suara gunakan /n untuk kembali normal");
	return 1;
}
CMD:n(playerid)
{
    SvUpdateDistanceForLStream(localStream[playerid], 10.0);
	SendClientMessage(playerid, 0xFF0000FF, "[INFO] Suara anda telah kembali normal");
	return 1;
}
CMD:w(playerid)
{
    SvUpdateDistanceForLStream(localStream[playerid], 2.0);
	SendClientMessage(playerid, 0xFF0000FF, "[INFO] Anda telah memperkecil distance suara gunakan /n untuk kembali normal");
	return 1;
}
