// Siliqua Source. Created by LaughingQuoll. Copyright 2017.
// Special Thanks to finngaida for adding quad tap action ability.

// Collect our headers. We don't need many.

#import "MediaRemote.h"
@interface NSTimer (Private){

}
+ (id)scheduledTimerWithTimeInterval:(double)arg1 invocation:(id)arg2 repeats:(BOOL)arg3;
+ (id)scheduledTimerWithTimeInterval:(double)arg1 repeats:(BOOL)arg2 block:(id /* block */)arg3;
+ (id)scheduledTimerWithTimeInterval:(double)arg1 target:(id)arg2 selector:(SEL)arg3 userInfo:(id)arg4 repeats:(BOOL)arg5;
@end
@interface BluetoothDevice: NSObject
- (unsigned int)doubleTapAction;
- (bool)setDoubleTapAction:(unsigned int)arg;
- (BOOL)magicPaired;
- (unsigned)doubleTapActionEx:(unsigned*)arg1 rightAction:(unsigned*)arg2;

@end

@interface BluetoothManager : NSObject
- (void)earbudInfo;
+ (id)sharedInstance;
- (void)receivedDoubleTapFromAirpods;
-(void)postNotificationName:(id)arg1 object:(id)arg2;
@end

@interface MPMusicPlayerController
+ (id)systemMusicPlayer;
- (void)play;
- (void)skipToNextItem;
@end

@interface SBHomeScreenViewController
- (BOOL)justTapped;
- (void)setJustTapped:(BOOL)value;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (UIImage *)artwork;
- (BOOL)isPlaying;
- (BOOL)play;
- (BOOL)Pause;
- (BOOL)hasTrack;
- (BOOL)_sendMediaCommand:(unsigned)command;
- (BOOL)skipFifteenSeconds:(int)seconds;
-(void)increaseVolume;
-(void)decreaseVolume;
-(BOOL)_sendMediaCommand:(unsigned)arg1 ;
-(void)_changeVolumeBy:(float)arg1 ;
@end

bool Enabled;
bool dtPausePlay;
bool dtSkip;
bool dtRewind;
bool dtSkip15;
bool dtRewind15;
bool dtIncreaseVolume;
bool dtDecreaseVolume;
bool dtToggleSiri;

bool qtPausePlay;
bool qtSkip;
bool qtRewind;
bool qtSkip15;
bool qtRewind15;
bool qtIncreaseVolume;
bool qtDecreaseVolume;
bool qtToggleSiri;

int count = 0;
NSString *currentCall;
NSString *newCall;

static unsigned int leftEarPod;
static unsigned int rightEarPod;


@interface SBAssistantController
+ (id)sharedInstance;
- (void)handleSiriButtonUpEventFromSource:(int)arg1;
- (_Bool)handleSiriButtonDownEventFromSource:(int)arg1 activationEvent:(int)arg2;
+(BOOL)isAssistantVisible;
-(long long)participantState;
-(void)dismissAssistantView:(long long)arg1 forAlertActivation:(id)arg2 ;
@end

%hook SBHomeScreenViewController
// This hook will run our actions, whatever they are.
static BOOL justTapped = NO;
static NSTimer *timer;

- (void)viewDidLoad {
	%orig;
    // Register for our double tap notification.
	HBLogDebug(@"viewDidLoad has finished");
}
%end

//: MARK: - BluetoothManager 
%hook BluetoothManager
%new
-(void)receivedDoubleTapFromAirpods {
        // Credits to Finn Gaida who created quad tap for me :P
	if (justTapped) {
            // quad tap action
		HBLogDebug(@"Quad tap ACTIVATED");

		if(qtPausePlay){
			MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
		}

		if(qtSkip){
			MRMediaRemoteSendCommand(kMRNextTrack, 0);
		}

		if(qtRewind){
			MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
		}

		if(qtSkip15){
              // Both don't seem to work, looking for alternatives?
              // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:+15];
              // MRMediaRemoteSendCommand(kMRSkipFifteenSeconds, 0);
			//: Does not work ON ios 11?
			[[%c(SBMediaController) sharedInstance] _sendMediaCommand:17];
		}

		if(qtRewind15){
              // Both don't seem to work, looking for alternatives?
              // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:-15];
              // MRMediaRemoteSendCommand(kMRGoBackFifteenSeconds, 0);
			//: Does not work ON ios 11?
			[[%c(SBMediaController) sharedInstance] _sendMediaCommand:18];
		}

		if(qtIncreaseVolume){
			HBLogDebug(@"INCREASE VOLUME ACTIVATED");

			[[%c(SBMediaController) sharedInstance] _changeVolumeBy:0.1];
		}

		if(qtDecreaseVolume){
			HBLogDebug(@"DECREASE VOLUME ACTIVATED");
			[[%c(SBMediaController) sharedInstance] _changeVolumeBy:-0.1];
		}

		if(qtToggleSiri){
			SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];

			if((int)[assistantController participantState] == 1){
				[assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
				[assistantController handleSiriButtonUpEventFromSource:1];
			} else {
				[assistantController dismissAssistantView:1 forAlertActivation:nil];
			}
		}

		[timer invalidate];
		justTapped = NO;
	} else {
		HBLogDebug(@"Double tap ACTIVATED");

		justTapped = YES;
		timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {

			if(dtPausePlay){
				MRMediaRemoteSendCommand(kMRTogglePlayPause, 0);
			}

			if(dtSkip){
				MRMediaRemoteSendCommand(kMRNextTrack, 0);
			}

			if(dtRewind){
				MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
			}

			if(dtSkip15){
                  // Both don't seem to work, looking for alternatives?
                  // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:+15];
                  // MRMediaRemoteSendCommand(kMRSkipFifteenSeconds, 0);
				[[%c(SBMediaController) sharedInstance] _sendMediaCommand:17];
			}

			if(dtRewind15){
                  // Both don't seem to work, looking for alternatives?
                  // [[%c(SBMediaController) sharedInstance] skipFifteenSeconds:-15];
                  // MRMediaRemoteSendCommand(kMRGoBackFifteenSeconds, 0);
				[[%c(SBMediaController) sharedInstance] _sendMediaCommand:18];
			}

			if(dtIncreaseVolume){
				[[%c(SBMediaController) sharedInstance] _changeVolumeBy:0.1];
			}

			if(dtDecreaseVolume){
				[[%c(SBMediaController) sharedInstance] _changeVolumeBy:-0.1];
			}

			if(dtToggleSiri){

				SBAssistantController *assistantController = [%c(SBAssistantController) sharedInstance];
				if((int)[assistantController participantState] == 1){
					[assistantController handleSiriButtonDownEventFromSource:1 activationEvent:1];
					[assistantController handleSiriButtonUpEventFromSource:1];
				} else {
					[assistantController dismissAssistantView:1 forAlertActivation:nil];
				}

			}
			justTapped = NO;
		}];
	}
}

//NOTE BOTH OF these methods this will not be called if LEFT and RIGHT are set to OFF but will be called if one earbud is set SIRI
//: PRints ou similiar things to postNotificationArray but this includes the mac address
-(void)postNotificationName:(id)arg1 object:(id)arg2 {
  //: BluetoothAvailabilityChangedNotfication is called when settings app is tapped
  //: BluetoothDeviceConnectSuccessNotification is called when airpods are connected
  //: BluetoothDeviceDisconnectSuccessNotification "" when airpods are disconnected
  //: BluetoothDiscoveryStateChangedNotification gets printed out outfit when in bluetooth page
  //NSString *available = @"BluetoothAvailabilityChangedNotfication";
  //NSString *connected = @"BluetoothDeviceConnectSuccessNotification";
  //NSString *disconnected = @"BluetoothDeviceDisconnectSuccessNotification";
	NSString *initiatedCommand = @"BluetoothHandsfreeInitiatedVoiceCommand";
	NSString *endedCommand = @"BluetoothHandsfreeEndedVoiceCommand";

	if (Enabled) {
		//%log;
		if ([arg1 isKindOfClass:[NSString class]]) {
			NSString *notificationName = (NSString *)arg1;
			//HBLogDebug(@"The notificationName is %@", notificationName);
			if ( [notificationName isEqualToString: initiatedCommand] && !newCall ) {
				currentCall = notificationName;
				newCall = endedCommand;
				HBLogDebug(@"The CURRENT CALL is now: %@", currentCall);
				HBLogDebug(@"thE newCALL IS NOW %@", newCall);
				[self earbudInfo];
			} else if ([notificationName isEqualToString: endedCommand] && !newCall ) {
				currentCall = notificationName;
				newCall = initiatedCommand;
				HBLogDebug(@"The CURRENT CALL is now: %@", currentCall);
				HBLogDebug(@"thE newCALL IS NOW %@", newCall);
				[self earbudInfo];

			} else {
			//: Added this part bc for some reason postNotificationName gets called many times.
				if (newCall && [notificationName isEqualToString: currentCall]) {
					 return;
				} else if (![notificationName isEqualToString: currentCall] && newCall) {
				//: BUG: This gets called twice when in settings->bluetooth->airpod info view.
					HBLogDebug(@"EPIC");
					currentCall = notificationName;
					[self earbudInfo];
				}
			}
		}
	} else {
		return %orig;
	}
}
%new 
-(void)earbudInfo {
	HBLogDebug(@"earbudInfo got called!!!");
	HBLogDebug(@"The leftEarPod is %u and the rightEarPod is %u", leftEarPod, rightEarPod);
  	//: Lets find out which earbud called, this will be the one that is set to SIRI

  	if (leftEarPod == (unsigned int)0 && rightEarPod == (unsigned int)0) {
  		//: Default action, this must be an ios 10 User perhaps?
  		[self receivedDoubleTapFromAirpods];
  		HBLogDebug(@"IOS 10 USER or below");
  	} else if (leftEarPod == (unsigned int)1) {
  		HBLogDebug(@"leftEarPod was the one tapped");
  		[self receivedDoubleTapFromAirpods];
  	} else if (rightEarPod == (unsigned int)1) {
  		HBLogDebug(@"rightEarPod was the one tapped");
  		[self receivedDoubleTapFromAirpods];
  	}
}

- (void)_postNotificationWithArray:(id)arg1 { 
  //: MARK:- THIS IS NOT BEING CALLED ANYMORE NOW ALL OF A SUDDEN. NOT SURE WHY.
	%log;
	HBLogDebug(@"YOU'VE SEEM TO CALL ME ALL OF A SUDDEN");
}
%end


//: MARK: - BluetoothDevice 
%hook BluetoothDevice
//: Prints out the current doubleTapactions
/*
arg1 == Left earbud
if arg1 ==
0: OFF
1: SIRI
2: Play/Pause
3: Next Track
4: Previous Track

arg2 == Right earbud
*/
-(unsigned)doubleTapActionEx:(unsigned*)arg1 rightAction:(unsigned*)arg2 {
	unsigned int val = %orig;
	HBLogDebug(@"doubleTapActionEx RESULT %u", val);
	unsigned int *argVal = arg1;
	HBLogDebug(@"doubleTapActionEx ARGUEMENT1 %u", *argVal);
	unsigned int *argVal2 = arg2;
	HBLogDebug(@"doubleTapActionEx ARGUEMENT2 %u", *argVal2);
  //: Returns a value of 0 when viewing Airpods viewController

	//: set the leftEarPod and rightEarPod
	leftEarPod = *argVal;
	rightEarPod = *argVal2;
  	//: TODO MAKE IT SO THAT SUPPORTSBATTERYLVEVEL WILL ONLY CALL ONCE. ALSO later implement a notifcation for when setdoubletapaction is changed.
	return val;
}

//: HOLY grail, this is called when user selects a new option (such as Play/Pause)
-(BOOL)setDoubleTapActionEx:(unsigned)arg1 rightAction:(unsigned)arg2 {
	BOOL val = %orig;
	HBLogDebug(@"setDoubleTapActionEx RESULT %d", val);
	unsigned int argVal = arg1;
	HBLogDebug(@"setDoubleTapActionEx ARGUMENT1 %u", argVal);
	unsigned int argVal2 = arg2;
	HBLogDebug(@"setDoubleTapActionEx ARGUMENT2 %u", argVal2);

	leftEarPod = argVal;
	rightEarPod = argVal2;
  //: Returns a one when a value is set
	return val;
}

//: This is called when user opens cc or when user puts on/off airpods
// -(BOOL)isAppleAudioDevice{
//   BOOL val = %orig;
//   HBLogDebug(@"THIS IS BEING SHOWN AS an apple deivce connected? %d", val);
//   return %orig;
// }

//: This gets called immediately when the device resprings
-(BOOL)supportsBatteryLevel {

	//: This will ONLY support IOS 11
	NSOperatingSystemVersion ios11 = (NSOperatingSystemVersion){11, 0, 0};
	if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios11]) {
		HBLogDebug(@"supportsBatteryLevel called! HELLO IOS 11 USER!");
		//: The following values don't have to be set to get the results we want.
		unsigned int first = 100000000;
		unsigned int second = 25;
		[self doubleTapActionEx:&first rightAction:&second];
	} 
	BOOL val = %orig;
	return val;
}
%end

/*
//: This prints out the battery percentage of all devices. Will need to find out how to only get the airpod battery device later.
%hook BCBatteryDevice
-(long long)percentCharge{
  %log;
  long long val = %orig;
  HBLogDebug(@"It seems this is the battery level: %lli", val);
  return val;
}
%end
*/

static void settingsChangedSiliqua(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@autoreleasepool {
		NSDictionary *SiliquaPrefs = [[[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.laughingquoll.siliquaprefs.plist"]?:[NSDictionary dictionary] copy];
		Enabled = (BOOL)[[SiliquaPrefs objectForKey:@"enabled"]?:@YES boolValue];

        // Our Double Tap Preferences
		dtPausePlay = (BOOL)[[SiliquaPrefs objectForKey:@"dtPausePlay"]?:@NO boolValue];
		dtSkip = (BOOL)[[SiliquaPrefs objectForKey:@"dtSkip"]?:@NO boolValue];
		dtRewind = (BOOL)[[SiliquaPrefs objectForKey:@"dtRewind"]?:@NO boolValue];
		dtSkip15 = (BOOL)[[SiliquaPrefs objectForKey:@"dtSkip15"]?:@NO boolValue];
		dtRewind15 = (BOOL)[[SiliquaPrefs objectForKey:@"dtRewind15"]?:@NO boolValue];
		dtIncreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"dtIncreaseVolume"]?:@NO boolValue];
		dtDecreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"dtDecreaseVolume"]?:@NO boolValue];
		dtToggleSiri = (BOOL)[[SiliquaPrefs objectForKey:@"dtToggleSiri"]?:@NO boolValue];

        // Our Quad Tap Preferences
		qtPausePlay = (BOOL)[[SiliquaPrefs objectForKey:@"qtPausePlay"]?:@NO boolValue];
		qtSkip = (BOOL)[[SiliquaPrefs objectForKey:@"qtSkip"]?:@NO boolValue];
		qtRewind = (BOOL)[[SiliquaPrefs objectForKey:@"qtRewind"]?:@NO boolValue];
		qtSkip15 = (BOOL)[[SiliquaPrefs objectForKey:@"qtSkip15"]?:@NO boolValue];
		qtRewind15 = (BOOL)[[SiliquaPrefs objectForKey:@"qtRewind15"]?:@NO boolValue];
		qtIncreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"qtIncreaseVolume"]?:@NO boolValue];
		qtDecreaseVolume = (BOOL)[[SiliquaPrefs objectForKey:@"qtDecreaseVolume"]?:@NO boolValue];
		qtToggleSiri = (BOOL)[[SiliquaPrefs objectForKey:@"qtToggleSiri"]?:@NO boolValue];
	}
}
__attribute__((constructor)) static void initialize_Siliqua()
{
	@autoreleasepool {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedSiliqua, CFSTR("com.laughingquoll.SiliquaPrefs/changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		settingsChangedSiliqua(NULL, NULL, NULL, NULL, NULL);
	}
}
