TARGET=:clang
ARCHS = armv7 arm64

BUNDLE_NAME = AnySpotPreferences
AnySpotPreferences_FILES = Preferences.xm
AnySpotPreferences_INSTALL_PATH = /Library/PreferenceBundles
AnySpotPreferences_FRAMEWORKS = UIKit Twitter
AnySpotPreferences_PRIVATE_FRAMEWORKS = Preferences

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AnySpotPreferences.plist$(ECHO_END)