THEOS_DEVICE_IP=10.0.0.18

# THEOS_PACKAGE_DIR_NAME = debs
TARGET := iphone:clang


include theos/makefiles/common.mk

BUNDLE_NAME = spotlightanywhere
spotlightanywhere_FILES = spotlightanywhere.xm
spotlightanywhere_INSTALL_PATH = /Library/Switches
spotlightanywhere_FRAMEWORKS = UIKit
spotlightanywhere_PRIVATE_FRAMEWORKS = Preferences
spotlightanywhere_LIBRARIES = flipswitch substrate
spotlightanywhere_ARCHS = armv7 arm64

export SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/library.mk

after-install::
	install.exec "killall -9 SpringBoard"