TARGET=:clang
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = AnySpotPref
AnySpotPref_FILES = AnySpotPref.mm
AnySpotPref_INSTALL_PATH = /Library/PreferenceBundles
AnySpotPref_FRAMEWORKS = UIKit
AnySpotPref_PRIVATE_FRAMEWORKS = Preferences

export SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AnySpotPref.plist$(ECHO_END)
