#
# hardware_dolby_lunaris
# Dolby Atmos (DAX3 3.6.0.12) untuk creek + LunarisDolby.
# Blob & konfigurasi diambil dari modul Fix_Dolby_Ksu_Lunaris yang terbukti jalan.
# Base struktur: FlamingoOS hardware/dolby (Apache-2.0).
#

DOLBY_PATH := hardware/dolby

PRODUCT_SOONG_NAMESPACES += $(DOLBY_PATH)

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DOLBY_PATH)/sepolicy/vendor

# VINTF
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DOLBY_PATH)/configs/vintf/dolby_framework_matrix.xml
DEVICE_MANIFEST_FILE += $(DOLBY_PATH)/configs/vintf/vendor.dolby.hardware.dms@2.0-service.xml

# Config
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/media/media_codecs_dolby_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby_audio.xml \
    $(DOLBY_PATH)/configs/dax/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml \
    $(DOLBY_PATH)/proprietary/vendor/etc/init/vendor.dolby.hardware.dms@2.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.dolby.hardware.dms@2.0-service.rc

# Props (sama dengan service.sh modul)
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.dolby.dax.version=DAX3_3.6.0.12_r1 \
    ro.dolby.mod_uuid=false \
    ro.dolby.music_stream=false \
    vendor.audio.dolby.ds2.enabled=true \
    vendor.audio.dolby.ds2.hardbypass=true \
    persist.vendor.audio_fx.current=dolby

# App
PRODUCT_PACKAGES += LunarisDolby init.dolby.rc

# Blob
PRODUCT_PACKAGES += \
    libdapparamstorage \
    libdlbdsservice \
    libsqlite_dolby \
    libstagefright_fdtn_dolby \
    vendor.dolby.hardware.dms@2.0 \
    vendor.dolby.hardware.dms@2.0-impl \
    vendor.dolby.hardware.dms@2.0-service \
    libswdap \
    libswvqe \
    libswgamedap

# File sistem dari modul (framework moto, permissions, sysconfig, default-permissions)
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/proprietary/system/etc/default-permissions/default-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/default-permissions/default-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/default-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.frameworks.core.addon.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.frameworks.core.addon.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.motosignature.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.motosignature.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/com.motorola.software.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.software.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto-checkin.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-checkin.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto-settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/moto.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.motorola.android.providers.settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.motorola.android.providers.settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/permissions/privapp-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.dolby.daxservice.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.dolby.daxservice.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.android.providers.settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.android.providers.settings.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.dolby.dolbyui.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.dolby.dolbyui.xml \
    $(DOLBY_PATH)/proprietary/system/etc/sysconfig/config-com.motorola.motosignature.app.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/config-com.motorola.motosignature.app.xml \
    $(DOLBY_PATH)/proprietary/system/framework/com.motorola.frameworks.core.addon.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/com.motorola.frameworks.core.addon.jar \
    $(DOLBY_PATH)/proprietary/system/framework/com.motorola.motosignature.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/com.motorola.motosignature.jar \
    $(DOLBY_PATH)/proprietary/system/framework/moto-checkin.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/moto-checkin.jar \
    $(DOLBY_PATH)/proprietary/system/framework/moto-settings.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/moto-settings.jar \
    $(DOLBY_PATH)/proprietary/system/framework/moto.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/moto.jar

PRODUCT_PACKAGES += \
    daxService \
    MotorolaSettingsProvider \
    MotoSignatureApp

# From the module's service.sh
PRODUCT_SYSTEM_PROPERTIES += ro.audio.ignore_effects=false
