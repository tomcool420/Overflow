GO_EASY_ON_ME=1
SDKVERSION=4.3
FW_DEVICE_IP=apple-tv.local
THEOS_DEVICE_IP=apple-tv.local
export $THEOS_DEVICE_IP

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Overflow
Overflow_FILES = Classes/overflow.mm  Classes/CPlusFunctions.mm Classes/OverflowSettings.m  Classes/OFlowMenu.m 
Overflow_INSTALL_PATH = /Applications/Lowtide.app/Appliances
Overflow_BUNDLE_EXTENSION = frappliance
Overflow_LDFLAGS = -undefined dynamic_lookup  
Overflow_CFLAGS  = -I../ATV2Includes
Overflow_OBJ_FILES = ../SMFramework/obj/SMFramework
SUBPROJECTS = OverflowHelper

include $(FW_MAKEDIR)/bundle.mk
include $(FW_MAKEDIR)/aggregate.mk
after-Overflow-stage::
	mkdir -p $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances; 
	ln -f -s /Applications/Lowtide.app/Appliances/Overflow.frappliance $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances/
after-install::
	ssh root@$(FW_DEVICE_IP) killall AppleTV

	
