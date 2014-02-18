#THEOS_DEVICE_IP=172.20.10.1
THEOS_DEVICE_IP=192.168.0.196

THEOS_PACKAGE_DIR_NAME = debs
TARGET := iphone:clang
ARCHS := armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = AnySpot
AnySpot_FILES = AnySpot.xm
AnySpot_INSTALL_PATH = /Library/Switches
AnySpot_FRAMEWORKS = UIKit
AnySpot_PRIVATE_FRAMEWORKS = Preferences
AnySpot_LIBRARIES = flipswitch substrate
AnySpot_ARCHS = armv7 arm64

export SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

include $(THEOS_MAKE_PATH)/bundle.mk

SUBPROJECTS += anyspotpref

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"