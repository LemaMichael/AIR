include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AIR
AIR_FILES = AirRootListController.m DoubleTapListController.m QuadTapListController.m
AIR_INSTALL_PATH = /Library/PreferenceBundles
AIR_FRAMEWORKS = UIKit
AIR_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AIR.plist$(ECHO_END)
