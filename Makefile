include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Siliqua
Siliqua_FILES = Tweak.xm
Siliqua_FRAMEWORKS = MediaPlayer
Siliqua_PRIVATE_FRAMEWORKS = MediaRemote
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += silquaprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
