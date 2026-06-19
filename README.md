<div align="center">

# 🌆 HOPIXEL ROLEPLAY

### *San Andreas Multiplayer — Indonesian Roleplay Gamemode*

<br>

[![SA-MP](https://img.shields.io/badge/SA--MP-0.3.7-orange?style=for-the-badge&logo=gta&logoColor=white)](https://www.sa-mp.mp/)
[![Pawn](https://img.shields.io/badge/Pawn-3.10.x-blue?style=for-the-badge)](https://github.com/pawn-lang/compiler)
[![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-Private-red?style=for-the-badge)]()

[![Modules](https://img.shields.io/badge/Modules-85+-success?style=flat-square)]()
[![Jobs](https://img.shields.io/badge/Jobs-17-yellow?style=flat-square)]()
[![Language](https://img.shields.io/badge/Bahasa-Indonesia-red?style=flat-square)]()
[![Maintained](https://img.shields.io/badge/Maintained-yes-brightgreen?style=flat-square)]()

<br>

*Server roleplay berbasis MySQL dengan arsitektur modular —*
*mudah dikembangkan, mudah di-maintain, siap kolaborasi.* 🚀

</div>

---

## 📖 Tentang

**Hopixel Roleplay** adalah gamemode SA-MP bergaya *roleplay* Indonesia. Dibangun dengan
arsitektur **modular** di mana setiap fitur hidup di file-nya sendiri — bukan satu file
raksasa. Ini membuat tim bisa bekerja paralel tanpa saling tabrakan, dan fitur baru bisa
ditambah hanya dengan membuat satu file.

---

## 🗂️ Arsitektur

`GM.pwn` adalah **root file** — ia hanya menyertakan seluruh modul dan memegang callback inti.
Logika tiap fitur dipisah ke filenya masing-masing.

```
gamemodes/
│
├── 🎯 GM.pwn            → Root: include semua modul + callback inti
├── ⚙️  DEFINE.pwn        → Konfigurasi terpusat (server, MySQL, makro)
├── 🖼️  TEXTDRAW.pwn      → Seluruh textdraw / UI
├── 💬 DIALOG.pwn        → Seluruh dialog
├── 🔧 NATIVE.pwn        → Fungsi native & helper
├── 📦 FUNCTION.pwn      → Fungsi umum
│
├── 💼 JOB/              → Satu file per pekerjaan
│   ├── JOB_FISH.pwn         🎣 Nelayan
│   ├── JOB_MINER.pwn        ⛏️  Penambang
│   ├── JOB_TRUCKER.pwn      🚚 Supir Truk
│   ├── JOB_LUMBER.pwn       🪵 Penebang Kayu
│   ├── JOB_FARMER.pwn       🌾 Petani
│   └── ... (17 job)
│
├── 🎮 CMD/             → Command
│   ├── PLAYER.pwn           Command pemain
│   ├── ADMIN.pwn            Command admin
│   ├── FACTION.pwn          Command faksi
│   └── ALIAS/               Alias command
│
└── 🏠 <FITUR>.pwn      → HOUSE · BISNIS · FAMILY · GARAGE · VEHICLE · dll
```

---

## ✨ Fitur Utama

<table>
<tr>
<td>

**🏘️ Properti & Ekonomi**
- 🏠 House System
- 🏢 Bisnis System
- 🏦 Bank & ATM
- 🚗 Private Vehicle
- 🅿️ Garage & Parking

</td>
<td>

**👮 Faksi & Roleplay**
- 🚔 SAPD (Polisi)
- 🚑 SAMD (Medis)
- 📰 SANEWS (Berita)
- 👨‍👩‍👧 Family System
- 🦹 Penjahat & Robbery

</td>
<td>

**🎯 Aktivitas**
- 💼 17 Jenis Pekerjaan
- 🎒 Inventory System
- 🎉 Event System
- 📞 Phone & SMS
- 🎙️ Voice (SampVoice)

</td>
</tr>
</table>

---

## 🚀 Cara Menambah Fitur

| Mau menambah... | Lakukan ini |
|:----------------|:------------|
| 💼 **Job baru** | Buat `JOB/JOB_NAMA.pwn`, daftarkan `#include "JOB/JOB_NAMA.pwn"` di `GM.pwn` |
| 🎮 **Command baru** | Tambahkan di `CMD/PLAYER.pwn` (atau ADMIN/FACTION) |
| 🖼️ **Textdraw** | Edit `TEXTDRAW.pwn` |
| ⚙️ **Konfigurasi** | Edit `DEFINE.pwn` |
| 🏠 **Fitur besar** | Buat `<FITUR>.pwn`, daftarkan di `GM.pwn` |

---

## 🛠️ Build & Deploy

```bash
# Compile GM.pwn → GM.amx menggunakan pawncc (Pawn 3.10.x)
pawncc gamemodes/GM.pwn -igamemodes -ipawno/include -ogamemodes/GM.amx -O2 -d3

# Jalankan server
./samp03svr            # Linux
samp-server.exe        # Windows
```

| Komponen | Lokasi |
|:---------|:-------|
| 📚 Include | `pawno/include/` |
| 🔌 Plugin | `plugins/` (`.so` Linux · `.dll` Windows) |
| 🗄️ Database | `hrp.sql` (MySQL, schema `hrp`) |
| ⚙️ Config | `server.cfg` · `gamemodes/DEFINE.pwn` |

---

## 🗄️ Database

Gamemode berbasis **MySQL**. Import schema sebelum menjalankan server:

```bash
mysql -u root hrp < hrp.sql
```

Pengaturan koneksi ada di `gamemodes/DEFINE.pwn` (`MYSQL_HOST`, `MYSQL_USER`, `MYSQL_DATABASE`).

---

<div align="center">

### 🧩 Tech Stack

![Pawn](https://img.shields.io/badge/Pawn-1f425f?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Streamer](https://img.shields.io/badge/Streamer-555?style=flat-square)
![YSI](https://img.shields.io/badge/YSI-555?style=flat-square)
![SampVoice](https://img.shields.io/badge/SampVoice-555?style=flat-square)
![sscanf2](https://img.shields.io/badge/sscanf2-555?style=flat-square)

<br>

**Dibuat dengan ❤️ untuk komunitas SA-MP Indonesia**

*⭐ Star repo ini jika bermanfaat!*

</div>
