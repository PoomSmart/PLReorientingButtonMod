GO_EASY_ON_ME = 1
SDKVERSION = 6.0

include theos/makefiles/common.mk
export ARCHS = armv7 armv7s
TWEAK_NAME = PLoBT
PLoBT_FILES = PLoBT.xm
PLoBT_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
