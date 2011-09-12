
SDKVERSION=4.3
FW_DEVICE_IP=appletv.local
include $(THEOS)/makefiles/common.mk
TOOL_NAME = OverflowHelper
OverflowHelper_FILES = overflowHelper.m overflowHelperClass.m
Overflow_INSTALL_PATH = /usr/bin

include $(FW_MAKEDIR)/tool.mk

after-OverflowHelper-stage::   
	 $(FAKEROOT) chmod 4755 $(FW_STAGING_DIR)/usr/bin/OverflowHelper
#	 $(FAKEROOT) chmod u+s $(FW_STAGING_DIR)/usr/bin/OverflowHelper
	 $(FAKEROOT) chown root:staff $(FW_STAGING_DIR)/usr/bin/OverflowHelper
