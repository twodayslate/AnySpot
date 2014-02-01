THEOS_DEVICE_IP=192.168.0.108

# THEOS_PACKAGE_DIR_NAME = debs
TARGET := iphone:clang
ARCHS := armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = anyspot
anyspot_FILES = spotlightanywhere.xm
anyspot_INSTALL_PATH = /Library/Switches
anyspot_FRAMEWORKS = UIKit
anyspot_PRIVATE_FRAMEWORKS = Preferences
anyspot_LIBRARIES = flipswitch substrate
anyspot_ARCHS = armv7 arm64

#export SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/library.mk

after-install::
	install.exec "killall -9 SpringBoard"