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

@interface SBWallpaperEffectView : UIView 
-(void)setStyle:(int)arg1;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

static UIWindow *window = nil;
static SBSearchViewController *vcont = nil;
static SBRootFolderView *fv = nil;
static UIToolbar *toolbar = nil;
static BOOL willLaunchWithSBIcon = NO;
static BOOL willlaunchWithURL = NO;
static id sbicon = nil;
static int sbloc = nil;
static id urlResult = nil;
static id section = nil;
static NSString *displayIdentifier = @"";
static int brightness = 80;
static int alpha = 100;
static BOOL hidecc, hidenc, hotfix_one, dynamicheader, translucent, clearbg, dark = YES;
static BOOL hotfix_two, logging, pleaselaunch, added, alphabutton, tint = NO;

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
    vcont = [objc_getClass("SBSearchViewController") sharedInstance];
    SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
	UIView *view = MSHookIvar<UIView *>(vcont, "_view");
	SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	SBWallpaperEffectView *blurView = MSHookIvar<SBWallpaperEffectView *>(sheader, "_blurView");

	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.twodayslate.anyspot.plist"]];
	
	if ([[view superview] isKindOfClass:[%c(SBRootFolderView) class]]) {
		fv = (SBRootFolderView *)[view superview];
	}
	
	switch (newState){
		case FSSwitchStateIndeterminate: return;
		case FSSwitchStateOff: {
			[ges resetAnimated:YES];
			break;
		}
		case FSSwitchStateOn:{
			if(added) {
				added = NO;
				[toolbar removeFromSuperview];
			}

			if(dynamicheader) {
				[blurView setStyle:0]; // 0 = transparent, 1 = hidden (not supported)

				toolbar = [[UIToolbar alloc] initWithFrame:sheader.bounds]; [toolbar retain];
				toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

				if(dark) {
					[toolbar setBarStyle:UIBarStyleBlack];
				} else { [toolbar setBarStyle:UIBarStyleDefault]; }

				if(translucent) [toolbar setTranslucent:YES];

				if(clearbg) [toolbar setBackgroundColor:[UIColor clearColor]];

				CGFloat alpha_true = alpha * 0.01;
				CGFloat brightness_true = brightness * 0.01;
				UIColor *color = [UIColor colorWithHue:0.0f saturation:0.0f brightness:brightness_true alpha:1.0];
				//http://stackoverflow.com/questions/19511744/uitoolbar-tintcolor-and-bartintcolor-issues
				if(tint) {
					toolbar.tintColor = color;
					toolbar.barTintColor = color;
				}
				
				if(alphabutton) toolbar.alpha = alpha_true;

				added = YES;

				[sheader insertSubview:toolbar atIndex:0];
			} else {
				[blurView setStyle:6];
			}

            window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = 998; //one less than the statusbar
			if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
				window.windowLevel = 1051;
			}
            window.hidden = NO;
            window.rootViewController = vcont;
			
            if(hotfix_one) {
            	[window addSubview:view];
			}
			if(hotfix_two) {
				[window addSubview:sheader];
			}
			
            [window makeKeyAndVisible];
			
			if(logging) {
				UIStatusBar *status = [(SpringBoard *)[UIApplication sharedApplication] statusBar];
				NSLog(@"AnySpot: Statusbar WindowLevel = %f",((UIWindow *)[status statusBarWindow]).windowLevel);
			}

			if(hidecc) {
				SBControlCenterController *cccont = [%c(SBControlCenterController) sharedInstance];
				if([cccont isVisible])
					[cccont dismissAnimated:YES];
			}
			

			if(hidenc){
				SBNotificationCenterController *nccont = [%c(SBNotificationCenterController) sharedInstance];
				if([nccont isVisible])
					[nccont dismissAnimated:YES];
			}
			
			[ges revealAnimated:YES];
            
		}
	}
}
@end

%hook SBWallpaperEffectView
-(void)setStyle:(int)arg1 {
	%log;
	%orig;
}
%end

%hook SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 {
	if(logging) %log;

	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		willlaunchWithURL = YES; 
		willLaunchWithSBIcon = NO; 
		urlResult = arg1; [urlResult retain];
		displayIdentifier = arg2; [displayIdentifier retain];
		section = arg3; [section retain];
	}
	pleaselaunch = NO;
	return %orig;
}
%end

%hook SBSearchGesture
-(void)resetAnimated:(BOOL)arg1 {
	if(logging) %log;
	%orig;
	if(window) {
		for(id view in [window subviews]) {
			[fv addSubview:view];
		}
		//[fv addSubview:[[window subviews] objectAtIndex:0]];
		[window release];
		window = nil;
	}
}
%end

%hook SBSearchViewController
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2  {
	if(logging) %log;
	%orig;
	pleaselaunch = YES;
	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
	}
}
%end

%hook SBApplicationIcon
- (void)launchFromLocation:(int)location {
	if(logging) %log;
	if(logging) NSLog(@"AnySpot: pleaselaunch = %d",pleaselaunch);

	%orig;

	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		willLaunchWithSBIcon = YES; 
		willlaunchWithURL = NO; 
		sbicon = self; [sbicon retain];
		sbloc = location; // 0 = dock/springboard, 4 = spotlight
	} else if(pleaselaunch) {
		[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:MSHookIvar<NSString *>(self, "_displayIdentifier") suspended:NO];
	}
	pleaselaunch = NO;
}
%end
	
%hook SBLockScreenManager
-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
	if(logging) %log; 
	%orig;

	if(willlaunchWithURL) {
		willlaunchWithURL = NO; 
		willLaunchWithSBIcon = NO;
		if(urlResult && [urlResult url]) {
			if(logging) NSLog(@"AnySpot: urlResutl url = %@",[urlResult url]);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[urlResult url] description]]];
			[[%c(SBSearchModel) sharedInstance] launchingURLForResult:urlResult withDisplayIdentifier:displayIdentifier andSection:section];
			[urlResult release];
			[displayIdentifier release];
			[section release];
		}
	}
	if(willLaunchWithSBIcon) {
		willlaunchWithURL = NO; 
		willLaunchWithSBIcon = NO; 
		if(sbicon) {
			[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:MSHookIvar<NSString *>(sbicon, "_displayIdentifier") suspended:NO];
			[sbicon launchFromLocation:sbloc];
			[sbicon release];
		}
	}
	pleaselaunch = NO;
}
%end

static void loadPrefs() {
	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.twodayslate.anyspot.plist"]];

    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.twodayslate.anyspot.plist"];

    if(settings) {
    	hidenc = [[settings objectForKey:@"anyspot_hidenc"] boolValue]; 
    	hidecc = [[settings objectForKey:@"anyspot_hidecc"] boolValue];
    	hotfix_one = [[settings objectForKey:@"anyspot_hotfix_one"] boolValue]; 
    	hotfix_two = [[settings objectForKey:@"anyspot_hotfix_two"] boolValue]; 
    	dynamicheader = [[settings objectForKey:@"anyspot_dynamicheader"] boolValue]; 
    	dark = [[settings objectForKey:@"anyspot_dark"] boolValue]; 
    	translucent = [[settings objectForKey:@"anyspot_translucent"] boolValue]; 
    	alphabutton = [[settings objectForKey:@"anyspot_alphabutton"] boolValue]; 
    	translucent = [[settings objectForKey:@"anyspot_tint"] boolValue]; 
    	clearbg = [[settings objectForKey:@"anyspot_clearbg"] boolValue]; 
    	logging = [[settings objectForKey:@"anyspot_logging"] boolValue];
    	brightness = [[settings objectForKey:@"anyspot_darkness"] integerValue]; 
    	alpha = [[settings objectForKey:@"anyspot_alpha"] integerValue];
    }
    if(logging) NSLog(@"AnySpot: settings = %@",settings);
    [settings release];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.twodayslate.anyspot/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}