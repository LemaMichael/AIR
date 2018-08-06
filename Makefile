include $(THEOS)/makefiles/common.mk
TARGET = iphone:10.2:10.2

TWEAK_NAME = AIR
AIR_FILES = Tweak.xm
AIR_FRAMEWORKS = MediaPlayer
AIR_PRIVATE_FRAMEWORKS = MediaRemote
include $(THEOS_MAKE_PATH)/tweak.mk
DEBUG=1
FINALPACKAGE=0

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += airPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
