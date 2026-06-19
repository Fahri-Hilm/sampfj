# 🔍 Audit Menyeluruh — Hopixel Roleplay

> Audit awal: 2026-06-20 · Total source: **124.767 baris** · 85+ modul

Dokumen ini memetakan kondisi codebase dari tiga sisi: **kesiapan compile (Linux)**,
**efisiensi/performa**, dan **maintainability**. Setiap item diberi prioritas dan status,
agar progres perbaikan bisa ditrack lewat commit.

Legenda prioritas: 🔴 Kritis · 🟡 Sedang · 🟢 Ringan/opsional

---

## 1. ✅ Yang Sudah Bagus

| Aspek | Catatan |
|:------|:--------|
| **Arsitektur modular** | `GM.pwn` = root, tiap fitur 1 file. Persis struktur ideal. |
| **Callback inti tunggal** | `OnPlayerConnect/Spawn/Disconnect/...` masing-masing hanya di 1 file — tidak ada konflik/duplikasi, tidak perlu ALS hooking. |
| **Konfigurasi terpusat** | `DEFINE.pwn` memegang nama server, MySQL, dan makro umum. |
| **Pola job & command konsisten** | `JOB/` dan `CMD/` punya 1 file per unit — gampang ditiru. |
| **Include lengkap** | Semua 17 include utama + YSI tersedia di `pawno/include/`. |

---

## 2. 🔴 Kesiapan Compile di Linux

Server target Linux (VPS), compiler pawncc Linux **case-sensitive** & **tidak menerima `\`** sebagai pemisah path.

| # | Masalah | Lokasi | Prio | Status |
|:--|:--------|:-------|:----:|:------:|
| 2.1 | **Backslash path di `#include`** — `JOB\...`, `CMD\...` | `GM.pwn` (24 baris), `JOB/SINGKONG.pwn` | 🔴 | ✅ |
| 2.2 | **Backslash path di library include** — `YSI_Data\y_iterate`, dll | `pawno/include/` (101 `#include` + 67 `#tryinclude`) | 🔴 | ✅ |
| 2.3 | Error compile pertama terkonfirmasi | `progress2.inc:13` → `cannot read file "YSI_Data\y_iterate"` | 🔴 | ✅ |
| 2.4 | YSI salah deteksi versi compiler (`__Pawn`) | compiler lama lapor `10`, resmi lapor `0x030A` | 🔴 | ✅ |
| 2.5 | Self-init variabel `health` | `GM.pwn:5786` | 🔴 | ✅ |

**✅ SELESAI** — `GM.amx` berhasil di-compile di Linux (pawncc 3.10.10 resmi, **0 error**, 9.97 MB).
- Compiler resmi disalin ke `tools/pawncc/` (in-project, `__Pawn=0x030A` benar untuk YSI).
- Build script `build.sh` dibuat. Jalankan: `bash build.sh`.
- Sisa 5993 warning bersifat kosmetik (239 = string literal, 214 = symbol unused) — tidak memengaruhi runtime.

---

## 3. 🟡 Efisiensi & Performa

### 3.1 Buffer stack berlebihan
Pawn mengalokasikan array lokal di stack tiap fungsi dipanggil. Buffer raksasa untuk query/teks pendek memboroskan stack.

| Buffer | Lokasi | Catatan |
|:-------|:-------|:--------|
| `cQuery[22480]` | `PRIVATE_VEHICLE.pwn:704` | UPDATE multi-kolom — **mungkin perlu besar**, perlu cek isi |
| `list[20000]` | `SALARY.pwn:35` | daftar gaji — bisa dipangkas |
| `Zan/Zann/Zanv/ZENN[10000]` | `PEDAGANGPV/SAMD/SANA/SAPD.pwn` | pola berulang, kandidat penyeragaman |
| `Dstring[18000]` | `JOB/JOB_MECH.pwn:338` | |
| `string[8000]`, `str[3500]×5` | `GARAGE.pwn`, `CMD/FACTION.pwn` | |

> ⚠️ Tidak semua dipangkas membabi-buta — buffer untuk UPDATE banyak kolom memang butuh besar. Tiap kasus dicek dulu.

### 3.2 Lainnya
| # | Item | Lokasi | Prio |
|:--|:-----|:-------|:----:|
| 3.3 | `VehicleUpdate` loop `1..MAX_VEHICLES` — lebih lambat dari `foreach` | `GM.pwn` | 🟡 |
| 3.4 | `playerUpdate()` rebuild string faction tiap update (bisa di-cache) | `GM.pwn` | 🟡 |
| 3.5 | `query[12800]` untuk `DELETE WHERE id=?` (FJ GM lama — N/A di sini, dicatat) | — | 🟢 |
| 3.6 | ~30 `printf` debug tertinggal (PLAYER 9, SERVER 5, GM 5, ...) | banyak file | 🟢 |

---

## 4. 🟡 Maintainability

| # | Item | Detail | Prio |
|:--|:-----|:-------|:----:|
| 4.1 | **File orphan** (tidak di-include di mana pun) | `JAIL`, `MODSHOP`, `ROBBERY`, `VTOYS`, `JOB/JOB_KURIR`, `JOB/JOB_REFLENISH`, `JOB/SINGKONG` | 🟡 |
| 4.2 | **Modul di-disable** (include dikomentari) | `GARKOT`, `INVENTORY`, `DISCORD/REGISTERDISCORD`, `CMD/DISCORD` | 🟡 |
| 4.3 | **TEXTDRAW manual** | 96 deklarasi `new PlayerText:/Text:` berurutan (`BankTD0..23`) — kandidat jadi array | 🟢 |
| 4.4 | **MAPPING.pwn 50.612 baris** | data objek murni — bisa dipindah ke loader `.txt`/streamer agar compile cepat | 🟢 |
| 4.5 | **DIALOG.pwn 17.777 baris** | satu `OnDialogResponse` raksasa — kandidat pecah per-fitur (easyDialog) | 🟢 |

---

## 5. 🔒 Keamanan (sudah ditangani)

| Item | Status |
|:-----|:------:|
| 2× Discord bot token di `server.cfg` | ✅ Diredaksi → placeholder sebelum push |
| MySQL password kosong di `DEFINE.pwn` | ℹ️ Default dev, isi via config produksi |

> ⚠️ Token Discord lama dianggap **bocor** — wajib di-regenerate di Discord Developer Portal.

---

## 6. 🗺️ Roadmap Usulan (urutan kerja)

1. 🔴 **Fix compile Linux** — ganti `\`→`/` di semua `#include` (source + libs), compile bersih. *(blocker utama)*
2. 🟡 **Bersihkan orphan & modul mati** — putuskan: hapus atau aktifkan kembali.
3. 🟡 **Optimasi buffer** — kecilkan buffer yang jelas berlebihan (per-kasus).
4. 🟡 **Cache & loop** — `playerUpdate` caching, `VehicleUpdate` pakai `foreach`.
5. 🟢 **Rapikan TEXTDRAW** jadi array; pertimbangkan pecah `DIALOG.pwn`.
6. 🟢 **Hapus `printf` debug** sisa.

Setiap langkah = 1 commit terpisah agar progres jelas di GitHub.

---

*Audit ini hidup — status (⬜/✅) diperbarui seiring perbaikan dikerjakan.*
