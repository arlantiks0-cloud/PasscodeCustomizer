TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PasscodeCustomizer

PasscodeCustomizer_FILES = Tweak.x
PasscodeCustomizer_FRAMEWORKS = UIKit QuartzCore
PasscodeCustomizer_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
