#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "CydiaSubstrate.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface FlipSLSwitch : NSObject <FSSwitchDataSource>
@end

@interface SBSearchViewController : UIViewController
+(id)sharedInstance;
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2;
-(BOOL)isVisible;
-(void)loadView;
-(void)cancelButtonPressed;
-(void)searchGesture:(id)arg1 completedShowing:(BOOL)arg2 ;
-(void)_setShowingKeyboard:(BOOL)arg1 ;
-(void)_resetViewController;
-(id)_window;
@end

@interface SBSearchHeader : UIView
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2 ;
@end

@interface SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3;
@end

@interface SBApplication
-(id)contextHostViewForRequester:(id)requester enableAndOrderFront:(BOOL)front;
@end

@interface SpringBoard
-(void)_menuButtonUp:(id)arg1;
-(void)_revealSpotlight;
-(void)quitTopApplication:(id)arg1 ;
-(void)applicationSuspend:(id)arg1 ;
-(BOOL)isLocked;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
-(void)_rotateView:(id)arg1 toOrientation:(int)arg2;
-(void)showSpringBoardStatusBar;
-(id)statusBar;
@end

@interface UIApplication (extras)
-(id)_accessibilityFrontMostApplication;
@end

@interface SBSearchResultsBackdropView : UIView
@end

@interface UIWindow (extras)
+(void)setAllWindowsKeepContextInBackground:(BOOL)arg1;
-(BOOL)isInternalWindow;
@end

@interface SBRootFolderView : UIView
@end

@interface SBSearchGesture
+(id)sharedInstance;
-(void)revealAnimated:(BOOL)arg1 ;
-(void)resetAnimated:(BOOL)arg1;
-(void)updateForRotation;
@end

@interface SBIcon
-(void)launchFromLocation:(int)arg1 ;
@end

@interface SBApplicationIcon : SBIcon
@end

@interface SBLockScreenManager 
+(id)sharedInstance;
-(id)lockScreenViewController;
-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2;
@end 

@interface UIStatusBar
-(id)statusBarWindow;
@end

@interface SBlockScreenViewControllerBase
-(void)setPasscodeLockVisible:(BOOL)arg1 animated:(BOOL)arg2;
@end

@interface SBNotificationCenter
-(void)dismissAnimated:(BOOL)arg1;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

static UIWindow *window = nil;
static SBSearchViewController *vcont = nil;
static SBRootFolderView *fv = nil;
static BOOL willLaunch = FALSE;
static NSString *displayIdentifier = @"";

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
    vcont = [objc_getClass("SBSearchViewController") sharedInstance];
    SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
	UIView *view = MSHookIvar<UIView *>(vcont, "_view");
	SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.twodayslate.anyspot.plist"]];
	
	if ([[view superview] isKindOfClass:[%c(SBRootFolderView) class]]) {
		fv = (SBRootFolderView *)[view superview];
	}
	
	switch (newState){
		case FSSwitchStateIndeterminate: return;
		case FSSwitchStateOff:
			[ges resetAnimated:TRUE];
			break;
		case FSSwitchStateOn:{
			
			
            window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = 998; //one less than the statusbar
			if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
				window.windowLevel = 1051;
			}
            window.hidden = NO;
            window.rootViewController = vcont;
			
            [window addSubview:view];
            if(![settings objectForKey:@"qcsupport"]) {
				[window addSubview:sheader];
			}
			
            [window makeKeyAndVisible];
			
			//UIStatusBar *status = [(SpringBoard *)[UIApplication sharedApplication] statusBar];
			//NSLog(@"Statusbar WindowLevel = %f",((UIWindow *)[status statusBarWindow]).windowLevel);
			if(![settings objectForKey:@"hidecc"]) {
				SBControlCenterController *cccont = [%c(SBControlCenterController) sharedInstance];
				if([cccont isVisible])
					[cccont dismissAnimated:TRUE];
			}
			
			if(![settings objectForKey:@"hidenc"]){
				SBNotificationCenterController *nccont = [%c(SBNotificationCenterController) sharedInstance];
				if([nccont isVisible])
					[nccont dismissAnimated:TRUE];
			}
			
			[ges revealAnimated:TRUE];
            
		}
	}
}
@end

%hook SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 {
	//%log;
	if(willLaunch) {
		//NSLog(@"inside willLaunch");
		[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:arg2 suspended:NO];
		if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
			[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
			displayIdentifier = arg2;
			willLaunch = TRUE;
		}
		
	} else {
		willLaunch = FALSE;
	}
	return %orig;
}
%end

%hook SBSearchGesture
-(void)resetAnimated:(BOOL)arg1 {
	%orig;
	if(window) {
		[fv addSubview:[[window subviews] objectAtIndex:0]];
		[window release];
		window = nil;
	}
}
-(void)updateForRotation {
	//%log;
	%orig;
}
%end

%hook SBSearchViewController
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2  {
	//%log;
	willLaunch = TRUE;
	%orig;
}
-(void)willRotateToInterfaceOrientation:(int)arg1 duration:(double)arg2 {
	//%log;
	%orig;
	[[%c(SBSearchGesture) sharedInstance] updateForRotation];
}
-(void)willAnimateRotationToInterfaceOrientation:(int)arg1 duration:(double)arg2 {
	//%log;
	%orig;
	[[%c(SBSearchGesture) sharedInstance] updateForRotation];
}
-(void)didRotateFromInterfaceOrientation:(int)arg1 {
		//%log;	
		%orig;	
		[[%c(SBSearchGesture) sharedInstance] updateForRotation];
}
%end

%hook SBApplicationIcon
- (void)launchFromLocation:(int)location {
	//%log;
	if (willLaunch) {
		willLaunch = FALSE;
		[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:MSHookIvar<NSString *>(self, "_displayIdentifier") suspended:NO];
		if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
			[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
			displayIdentifier = MSHookIvar<NSString *>(self, "_displayIdentifier");
			willLaunch = TRUE;
		}
	}
	%orig;
}
%end
	
%hook SpringBoard
	-(void)_rotateView:(id)arg1 toOrientation:(int)arg2 {
		//%log;
		%orig;
		//[[%c(SBSearchGesture) sharedInstance] updateForRotation];
	}
%end
	
	%hook SBLockScreenManager
		-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
			//%log; 
			%orig;
			if(willLaunch) {
				[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:displayIdentifier suspended:NO];
				willLaunch = FALSE;
			}
		}
%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.jontelang.sliderchangerprefs.plist"];
    if(prefs)
    {
		//load prefs
    }
    [prefs release];
}

%ctor {
    //CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    //CFNotificationCenterAddObserver(r, NULL, &loadPrefs, CFSTR("com.twodayslate.anyspot/reloadSettings"), NULL, 0);
    loadPrefs();
}