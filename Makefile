include $(THEOS)/makefiles/common.mk
TARGET = iphone:10.2:10.2

TWEAK_NAME = Siliqua
Siliqua_FILES = Tweak.xm
Siliqua_FRAMEWORKS = MediaPlayer
Siliqua_PRIVATE_FRAMEWORKS = MediaRemote
include $(THEOS_MAKE_PATH)/tweak.mk
DEBUG=1
FINALPACKAGE=0

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += silquaprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
