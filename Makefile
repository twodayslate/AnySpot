THEOS_DEVICE_IP=192.168.0.105

THEOS_PACKAGE_DIR_NAME = debs
TARGET := iphone:clang
ARCHS := armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = AnySpot
AnySpot_FILES = AnySpot.xm
AnySpot_INSTALL_PATH = /Library/Switches
AnySpot_FRAMEWORKS = UIKit
AnySpot_PRIVATE_FRAMEWORKS = Preferences
AnySpot_LIBRARIES = flipswitch substrate
AnySpot_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += anyspotpref
include $(THEOS_MAKE_PATH)/aggregate.mk