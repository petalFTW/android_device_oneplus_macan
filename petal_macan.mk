#
# Copyright (C) 2026 The petalOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# petal variant of macan. lineage base + the petal extras, keeps lineage_macan clean.
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

# petalOS customization hub (no launcher icon, reachable from Settings).
PRODUCT_PACKAGES += \
    PetalHub \
    FontCommissionerOverlay
PRODUCT_COPY_FILES += vendor/petal/overlays/petal_config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/overlay/config/config.xml

# Proton4A: Windows-app compatibility runtime host (PetalHub "Import Windows EXE").
$(call inherit-product, vendor/petal/apps/Proton4A/integration/Proton4A.mk)

# petalOS depth studio (3D lock screen photo thing).
PRODUCT_PACKAGES += \
    PetalDepth

# petalOS flagship camera (overrides Aperture/Camera2).
PRODUCT_PACKAGES += \
    PetalCam

# petalOS idle power policy (stops apps messing about while screen is off).
PRODUCT_PACKAGES += \
    PetalPower

# petalOS game mode / tuner (PetalGM source tree).
PRODUCT_PACKAGES += \
    PetalTuner

# App Center holds the installable APKs of the optional apps.
PRODUCT_PACKAGES += \
    PetalAppCenterApks

# gms hog eats a verify filter on every cold start, compile the bastard at build time
PRODUCT_DEXPREOPT_SPEED_APPS += GmsCompat

# petalOS: AOT-compile user apps at install instead of leaving them at the default
# speed-profile (which collapses to verify when there is no profile yet). Without this,
# installed apps cold start through the interpreter + JIT, so the first launch pays
# class-loading and verification cost. Costs install time and a little storage.
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
