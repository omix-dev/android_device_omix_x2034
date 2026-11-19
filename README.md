# OMIX X2034 (MT6835) — LineageOS 23 device tree

## Device
| Item | Value |
|---|---|
| Brand / model | OMIX X2034 |
| SoC | MediaTek MT6835 (Dimensity 6300 class) |
| CPU | 2× Cortex-A76 + 6× Cortex-A55, arm64 |
| GPU | Mali-G57 |
| Stock vendor | Android 13, `alps-mp-t0.mp1-V14.94`, VNDK 33 |
| Installed system | LineageOS 23.2 GSI (Android 16) |
| Kernel | GKI2 5.15.167-android13 (`5.15.167-android13-8-00017-gb1f32b310a30-ab12826353`) |
| Partitioning | A/B, dynamic `super` (9,663,676,416 bytes), group `main` |

## Tree layout
```
device/omix/X2034/
├── AndroidProducts.mk
├── BoardConfig.mk
├── device.mk
├── lineage_X2034.mk
├── extract-files.sh
└── prebuilt/
    ├── kernel             # stock LZ4 kernel from boot_a
    ├── Image              # decompressed ARM64 Image (reference)
    ├── dtbo.img           # stock dtbo_a
    ├── vendor_boot.img    # stock vendor_boot_a (vendor ramdisk + DTB)
    ├── init_boot.img      # stock init_boot_a (clean generic ramdisk)
    ├── boot.img           # stock boot_a (reference)
    └── SHA256SUMS
```

## Build
```bash
. build/envsetup.sh
lunch lineage_X2034-userdebug
mka bacon
```

## Important notes
- **Kernel is prebuilt GKI2.** The stock LZ4 kernel is packed by the build.
- **`vendor_boot.img` is prebuilt.** The stock vendor ramdisk contains the
  MTK modules and the device DTB table; do not regenerate it unless you also
  rebuild the matching GKI modules.
- **Vendor blobs are normalized.** Stock MediaTek puts real ELF files in
  `lib*/mt6835/`, `bin*/mt6835/` and top-level symlinks. The generated
  `vendor/omix/X2034` tree installs the real files at the loader-facing
  paths, so the `mt6835/` directory is not installed. This was verified not
  to break hardcoded paths (no `/vendor/*/mt6835/` strings in the blobs).
- **AVB uses AOSP test keys** (`external/avb/test/data/testkey_rsa2048.pem`).
  Replace them with your own keys for anything other than development.
  The bootloader must be unlocked to boot a self-signed image.
- **No recovery partition exists.** `TARGET_NO_RECOVERY := true`; the stock
  A/B layout has no `recovery` partition. Use fastboot/OTA flows, or add a
  recovery-as-boot/vendor_boot fragment if you need a recovery UI.
- **Vendor is EROFS.** The stock vendor tree is 1.0 GB uncompressed but only
  666 MB on EROFS/LZ4; ext4 will not fit the stock partition size.
- **First boot may need AVB disabled** on an unlocked bootloader:
  `fastboot --disable-verity --disable-verification flash vbmeta ...`.
  Do not flash anything until you have a verified stock backup.

## Refreshing blobs
`extract-files.sh` re-pulls `/vendor`, `/vendor_dlkm` and `/odm_dlkm` with
root. It uses `stty raw -echo` because Magisk's `su` runs over a pty and
would otherwise turn `LF` into `CRLF` and corrupt binaries.
