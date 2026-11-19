#
# OMIX X2034 device makefile
#
$(call inherit-product, vendor/omix/X2034/X2034-vendor.mk)

# System properties required by the MT6835 vendor stack
PRODUCT_SYSTEM_PROPERTIES += \
    ro.hardware.egl=meow \
    ro.hardware.vulkan=mali \
    ro.hardware.gralloc=common \
    ro.hardware.hwcomposer=mtk_common \
    ro.hardware.gatekeeper=trustonic

# Include the stock VNDK 33 snapshot for the Android 13 vendor
PRODUCT_EXTRA_VNDK_VERSIONS := 33

# Vendor APEX/namespace compatibility
PRODUCT_SOONG_NAMESPACES += vendor/omix/X2034
