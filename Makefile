GO_EASY_ON_ME = 1
SDKVERSION = 6.0

include theos/makefiles/common.mk
export ARCHS = armv7 armv7s
TWEAK_NAME = PLoBT
PLoBT_FILES = PLoBT.xm
PLoBT_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp -R PLoBT $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)

