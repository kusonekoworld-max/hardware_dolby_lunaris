# hardware_dolby_lunaris

Dolby Atmos untuk Xiaomi creek (SD685) + LunarisDolby, berbasis blob DAX3 **3.6.0.12** dari modul `Fix_Dolby_Ksu_Lunaris`.

Kenapa dibuat: `hardware/dolby` bawaan (DAX3 3.7.0.8 + Codec2) di tree tidak aktif / audioserver 100% CPU, sedangkan modul root jalan.
Perbedaan yang dibawa dari modul:
- Blob 3.6 (libswdap, libswvqe, libswgamedap, dms service/impl, libdlbdsservice, libdapparamstorage)
- `libstagefright_foundation.so` milik Dolby di-rename `libstagefright_fdtn_dolby.so` (SONAME dan NEEDED libdlbdsservice dipatch) supaya tidak bentrok ABI dgn versi sistem
- libsqlite vendor private (`libsqlite_dolby`, stem libsqlite)
- Props: dax.version 3.6.0.12, ds2.enabled/hardbypass=true, persist.vendor.audio_fx.current=dolby
- sepolicy: audioserver boleh find hal_dms_hwservice + binder call
- Tanpa spatializer 3.7 dan Codec2 decoder (belum ada padanannya di 3.6; modul pakai OMX yang tidak ada di Android 17)

## Pakai
```
$(call inherit-product, hardware/dolby/dolby.mk)
```
Clone ke `hardware/dolby`. Di device tree `audio_effects.xml` harus mendaftarkan dap/vqe/gamedap (creek sudah).
Pakai `+=` untuk DEVICE_MANIFEST_FILE / DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE.

## Mengikuti alur instal modul (log KernelSU)
- File sistem sama seperti log: `daxService`, `MotorolaSettingsProvider`, `MotoSignatureApp`, jar moto, permissions/sysconfig/default-permissions. UI `MotoDolbyDax3` kosong di modul -> diganti LunarisDolby.
- Arm64 only: lib 32-bit modul tidak dipakai.
- `dax-default.xml`: volume-leveler-enable=false (default customize.sh).
- Props dari `service.sh` ada di `dolby.mk`.
- **Wajib**: terapkan `patches/creek-audio_effects.patch` ke device tree (`git apply`). Ini padanan `aml.sh`: buang helper/dlb listener (libdlbvol tidak ada di 3.6), daftarkan dap/vqe/gamedap, apply ke stream patch+rerouting.
