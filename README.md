# hardware_dolby_lunaris

Dolby Atmos for Xiaomi creek (SD685) + LunarisDolby, based on the DAX3 **3.6.0.12** blobs from the `Fix_Dolby_Ksu_Lunaris` module.

## Why this exists
The stock `hardware/dolby` in the tree (DAX3 3.7.0.8 + Codec2) does not activate Dolby and audioserver sits at 100% CPU, while the root module works fine.

What is carried over from the module:
- 3.6 blobs (libswdap, libswvqe, libswgamedap, dms service/impl, libdlbdsservice, libdapparamstorage)
- Dolby's `libstagefright_foundation.so` renamed to `libstagefright_fdtn_dolby.so` (SONAME and the NEEDED entry in libdlbdsservice are patched) to avoid an ABI clash with the system version
- Private vendor sqlite (`libsqlite_dolby`, stem `libdlbsql`)
- Props: dax.version 3.6.0.12, ds2.enabled/hardbypass=true, persist.vendor.audio_fx.current=dolby, ro.audio.ignore_effects=false
- sepolicy: audioserver and app domains may find hal_dms_hwservice and call the HAL; app domains may read vendor_audio_prop
- No 3.7 spatializer and no Codec2 decoders (there is no 3.6 equivalent; the module uses OMX, which does not exist on Android 17). `media_codecs_dolby_audio.xml` is intentionally empty, same as the module.

## Usage
Add to your device makefile:

    $(call inherit-product, hardware/dolby/dolby.mk)

Clone into `hardware/dolby`. The device tree's `audio_effects.xml` must register dap/vqe/gamedap (creek already does).
Use `+=` for DEVICE_MANIFEST_FILE / DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE.

## Mirroring the module's install flow (KernelSU log)
- System files match the log: `daxService`, `MotorolaSettingsProvider`, `MotoSignatureApp`, moto jars, permissions/sysconfig/default-permissions. The module's `MotoDolbyDax3` UI is empty, so it is replaced by LunarisDolby.
- arm64 only: the module's 32-bit libs are not used.
- `dax-default.xml`: volume-leveler-enable=false (default of `customize.sh`).
- Props from `service.sh` are in `dolby.mk`.
- **Required**: apply `patches/creek-audio_effects.patch` to the device tree (`git apply`). It is the equivalent of `aml.sh`: removes the helper/dlb listener effects (libdlbvol does not exist in 3.6), registers dap/vqe/gamedap, and applies them to the patch and rerouting streams.
- Also like `aml.sh`: replace `AUDIO_OUTPUT_FLAG_RAW` with `AUDIO_OUTPUT_FLAG_NONE` in the device tree's audio policy, and apply the same effect cleanup to every `audio_effects*` file.

## Dirty flash note
Delete `/data/vendor/dolby/dax_sqlite3.db` once after switching from 3.7 to 3.6 (the module does this on install).
