include $(THEOS)/makefiles/common.mk
THEOS_DEVICE_IP=apple-tv.local
export $THEOS_DEVICE_IP

TWEAK_NAME = bl_overflow
bl_overflow_FILES = listener.mm
bl_overflow_LDFLAGS= -undefined dynamic_lookup
bl_overflow_CFLAGS = -I../../ATV2Includes

include $(THEOS_MAKE_PATH)/tweak.mk
