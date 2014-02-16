#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "substrate.h"
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

@interface SBWallpaperEffectView : UIView {
	UIImage* _maskImage;
}
+(id)imageInRect:(CGRect)arg1 forVariant:(int)arg2 withStyle:(int)arg3 zoomFactor:(float)arg4 mask:(id)arg5 masksBlur:(BOOL)arg6 masksTint:(BOOL)arg7 ;
-(void)setMaskImage:(id)arg1 masksBlur:(BOOL)arg2 masksTint:(BOOL)arg3 ;
-(void)setStyle:(int)arg1;
-(void)_updateWallpaperAverageColor:(id)arg1 ;
@end

@interface UIResizableView : UIView
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

static UIWindow *window = nil;
static SBSearchViewController *vcont = nil;
static SBRootFolderView *fv = nil;
static BOOL willLaunchWithSBIcon = NO;
static BOOL willlaunchWithURL = NO;
static id sbicon = nil;
static int sbloc = nil;
static id urlResult = nil;
static id section = nil;
static NSString *displayIdentifier = @"";
static id hidecc, hidenc, hotfix_one, hotfix_two, logging = nil;

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
    vcont = [objc_getClass("SBSearchViewController") sharedInstance];
    SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
	UIView *view = MSHookIvar<UIView *>(vcont, "_view");
	SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.twodayslate.anyspot.plist"]];
	
	if ([[view superview] isKindOfClass:[%c(SBRootFolderView) class]]) {
		fv = (SBRootFolderView *)[view superview];
	}
	
	switch (newState){
		case FSSwitchStateIndeterminate: return;
		case FSSwitchStateOff:
			[ges resetAnimated:YES];
			break;
		case FSSwitchStateOn:{
			SBWallpaperEffectView *blurView = MSHookIvar<SBWallpaperEffectView *>(sheader, "_blurView");
			[blurView setStyle:0]; 

			UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:sheader.bounds];
			toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[toolbar setTranslucent:YES];
			[toolbar setBarStyle:UIBarStyleBlack];
			[toolbar setTranslucent:YES];
			toolbar.backgroundColor = [UIColor clearColor];
			toolbar.alpha = 0.8;
			[sheader insertSubview:toolbar atIndex:0];
			//0 is transparent, 1 is hidden (not supported)
								   //2 is normal
			// UIImage *backgroundImage = [self getImage];
			// GPUImageiOSBlurFilter *_blurFilter = [[GPUImageiOSBlurFilter alloc] init];
   //      	_blurFilter.blurRadiusInPixels = 1.0f;
   //      	GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
   //  		[picture addTarget:_blurFilter];
   //  		[_blurFilter addTarget:_blurView];
   //  		[sheader addSubview:picture];
			// NSLog(@"_blurView = %@",blurView);

			// UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
			// CGRect rect = [keyWindow bounds];
			// UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
			// CGContextRef context = UIGraphicsGetCurrentContext();
			// [keyWindow.layer renderInContext:context];   
			// UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
			// UIGraphicsEndImageContext();
			// UIImage *blurredImage = MSHookIvar<UIImage *>(blurView, "_maskImage");

			// blurredImage = capturedScreen;
			// object_setInstanceVariable(blurView,"_maskImage",capturedScreen);
			
			// //UIView *headerView = [[UIView alloc] initWithFrame:rect];
			// UIImageView *logoView = [[UIImageView alloc] initWithImage:capturedScreen];
			// object_setInstanceVariable(blurView,"_maskImageView",logoView);
			//UIColor * color = [UIColor colorWithRed:255/255.0f green:256/255.0f blue:0/255.0f alpha:1.0f];

			// object_setInstanceVariable(blurView,"_wallpaperAverageColor",color);
			//NSLog(@"AnySpot: wallpaper color: %@",MSHookIvar<UIColor *>(blurView, "_wallpaperAverageColor"));
			//[blurView _updateWallpaperAverageColor:color];
			// [blurView setNeedsDisplay];
			//[headerView addSubview:logoView];
			//mask is a uiresizableimage
			//[blurView setMaskImage:headerView masksBlur:YES masksTint:NO];
			
			// SBSearchResultsBackdropView *backdrop = MSHookIvar<SBSearchResultsBackdropView *>(vcont, "_tableBackdrop");
			// SBWallpaperEffectView *blurView = MSHookIvar<SBWallpaperEffectView *>(sheader, "_blurView");
			// blurView = MSHookIvar<SBWallpaperEffectView *>(backdrop, "_effectView");

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

%hook UIView
-(id)_initWithMaskImage:(id)arg1 {
	if(logging) %log;
	return %orig;
}
%end
%hook UIResizableView
-(id)_initWithMaskImage:(id)arg1 {
	if(logging) %log;
	return %orig;
}
%end

%hook SBWallpaperEffectView
+(id)imageInRect:(CGRect)arg1 forVariant:(int)arg2 withStyle:(int)arg3 zoomFactor:(float)arg4 mask:(id)arg5 masksBlur:(BOOL)arg6 masksTint:(BOOL)arg7 {
	if(logging) %log;
	return %orig;
}
-(void)setMaskImage:(id)arg1 masksBlur:(BOOL)arg2 masksTint:(BOOL)arg3 {
	if(logging) %log;
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

	// if(willLaunch) {
	// 	[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:arg2 suspended:NO];
	// 	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
	// 		[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
	// 		displayIdentifier = arg2;
	// 		willLaunch = TRUE;
	// 	}
		
	// } else {
	// 	willLaunch = FALSE;
	// }
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
// -(void)updateForRotation {
// 	//%log;
// 	%orig;
// }
%end

%hook SBSearchViewController
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2  {
	if(logging) %log;
	%orig;
	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
	}
}
// -(void)willRotateToInterfaceOrientation:(int)arg1 duration:(double)arg2 {
// 	//%log;
// 	%orig;
// 	[[%c(SBSearchGesture) sharedInstance] updateForRotation];
// }
// -(void)willAnimateRotationToInterfaceOrientation:(int)arg1 duration:(double)arg2 {
// 	//%log;
// 	%orig;
// 	[[%c(SBSearchGesture) sharedInstance] updateForRotation];
// }
// -(void)didRotateFromInterfaceOrientation:(int)arg1 {
// 		//%log;	
// 		%orig;	
// 		[[%c(SBSearchGesture) sharedInstance] updateForRotation];
// }
%end

%hook SBApplicationIcon
- (void)launchFromLocation:(int)location {
	if(logging) %log;

	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		willLaunchWithSBIcon = YES; 
		willlaunchWithURL = NO; 
		sbicon = self; [sbicon retain];
		sbloc = location; 
	}

	%orig;
	

	// if (willLaunch) {
	// 	willLaunch = FALSE;
	// 	[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:MSHookIvar<NSString *>(self, "_displayIdentifier") suspended:NO];
	// 	if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
	// 		[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] setPasscodeLockVisible:YES animated:YES];
	// 		displayIdentifier = MSHookIvar<NSString *>(self, "_displayIdentifier");
	// 		willLaunch = TRUE;
	// 	}
	// }
	// %orig;
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
	if(logging) %log; 
	%orig;

	if(willlaunchWithURL) {
		willlaunchWithURL = NO; 
		willLaunchWithSBIcon = NO;
		//NSLog(@"will call launchingURLForResult %@ %@ %@",urlResult, displayIdentifier, section);
		if(urlResult && [urlResult url]) {
			if(logging) NSLog(@"AnySpot: urlResutl url = %@",[urlResult url]);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[urlResult url] description]]];
			//[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:displayIdentifier suspended:NO];
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
}
%end

static void loadPrefs() {
	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.twodayslate.anyspot.plist"]];

    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.twodayslate.anyspot.plist"];

    if(settings) {
    	hidenc = [settings objectForKey:@"anyspot_hidenc"]; [hidenc retain];
    	hidecc = [settings objectForKey:@"anyspot_hidecc"]; [hidecc retain];
    	hotfix_one = [settings objectForKey:@"anyspot_hotfix_one"]; [hotfix_one retain];
    	hotfix_two = [settings objectForKey:@"anyspot_hotfix_two"]; [hotfix_two retain];
    	logging = [settings objectForKey:@"anyspot_logging"]; [logging retain];
    }
    if(logging) NSLog(@"AnySpot: settings = %@",settings);
    [settings release];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.twodayslate.anyspot/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}