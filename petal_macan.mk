#
# Copyright (C) 2026 The petalOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# petal variant of the macan build. lineage base + petal extras, keeps lineage_macan clean.
$(call inherit-product, device/oneplus/macan/lineage_macan.mk)

# Approved Petal V3 3D boot animation, native fade included.
TARGET_BOOTANIMATION := vendor/lineage/bootanimation/petal.zip

# GmsCompat (sandboxed Google Play Services).
PRODUCT_PACKAGES += \
    GmsCompat \
    GmsCompatLib \
    GmsCompatConfig

$(call inherit-product, vendor/petal/network-location.mk)
$(call inherit-product, vendor/petal/apps/PetalSettings/settings.mk)
$(call inherit-product, vendor/petal/apps/PetalServices/services.mk)

# petalOS customization hub (no launcher icon, reachable from Settings).
PRODUCT_PACKAGES += \
    PetalHub \
    FontCommissionerOverlay
PRODUCT_COPY_FILES += vendor/petal/overlays/petal_config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/overlay/config/config.xml

# Proton4A: Windows-app compatibility runtime host (PetalHub "Import Windows EXE").
$(call inherit-product, vendor/petal/apps/Proton4A/integration/Proton4A.mk)

# petalOS advanced features / hosts-based content blocker (no launcher icon).
PRODUCT_PACKAGES += \
    PetalAdvanced \
    petal-blocklist.sh

# petalOS depth studio (3D lock screen photo thing).
PRODUCT_PACKAGES += \
    PetalDepth

# CATBACK, android auto but ours. needs an AA apk fed to it once for the car identity
PRODUCT_PACKAGES += \
    Catback

# petalOS flagship camera (overrides Aperture/Camera2).
PRODUCT_PACKAGES += \
    PetalCam

# petalOS idle power policy (stops apps messing about while screen is off).
PRODUCT_PACKAGES += \
    PetalPower

# tuner shell first, App Center puts the real thing over it
PRODUCT_PACKAGES += \
    PetalTunerStub

# App Center holds the installable APKs of the optional apps.
PRODUCT_PACKAGES += \
    PetalAppCenterApks

# assistant shell reserves the package and key for Hub
PRODUCT_PACKAGES += \
    PetalAssistantStub

# Assistant CDSP runtime (kept so the App Center-installed app can use Hexagon).
$(call inherit-product, vendor/petal/apps/PetalAssistant/integration/PetalAssistant.mk)

# PetalMusic replaces Twelve; streaming clients and AutoMix live here
PRODUCT_PACKAGES += \
    PetalMusic
PRODUCT_DEXPREOPT_SPEED_APPS += PetalMusic

# gms hog eats a verify filter on every cold start, compile the bastard at build time
PRODUCT_DEXPREOPT_SPEED_APPS += GmsCompat

# compile on install so cold starts don't crawl through the interpreter
PRODUCT_SYSTEM_PROPERTIES += \
    pm.dexopt.install=speed

# keep more apps warm so relaunches stop being cold
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.device_config.activity_manager.max_cached_processes=48

# Helper shell only; App Center has the actual avatar app.
PRODUCT_PACKAGES += \
    PetalAgeVerStub \
    virtual_camera
$(call soong_config_set,vdm,virtual_camera_service_enabled,true)
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += vendor/petal/sepolicy

PRODUCT_NAME := petal_macan
