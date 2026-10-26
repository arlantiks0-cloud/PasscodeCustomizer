TARGET := iphone:clang:latest:14.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PasscodeCustomizerPrefs

PasscodeCustomizerPrefs_FILES = PFCPreferencesController.m
PasscodeCustomizerPrefs_FRAMEWORKS = UIKit
PasscodeCustomizerPrefs_PRIVATE_FRAMEWORKS = Preferences
PasscodeCustomizerPrefs_EXTRA_FRAMEWORKS += Cephei
PasscodeCustomizerPrefs_INSTALL_PATH = /Library/PreferenceBundles
PasscodeCustomizerPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
