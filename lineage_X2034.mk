#
# LineageOS product definition for OMIX X2034
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, device/omix/X2034/device.mk)

PRODUCT_NAME := lineage_X2034
PRODUCT_DEVICE := X2034
PRODUCT_BRAND := OMIX
PRODUCT_MODEL := X2034
PRODUCT_BOARD := pri_board
PRODUCT_MANUFACTURER := OMIX
PRODUCT_SHIPPING_API_LEVEL := 33
