#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "CydiaSubstrate.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface AnySpotSwitch : NSObject <FSSwitchDataSource>
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
-(void)_fadeForLaunchWithDuration:(double)arg1 completion:(/*^block*/ id)arg2 ;
-(void)window:(id)arg1 willAnimateRotationToInterfaceOrientation:(int)arg2 duration:(double)arg3 ;
-(void)window:(id)arg1 setupWithInterfaceOrientation:(int)arg2 ;
-(BOOL)_forwardRotationMethods;
-(void)_updateTableContents;
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
-(int)interfaceOrientationForCurrentDeviceOrientation;
-(void)noteInterfaceOrientationChanged:(int)arg1 duration:(float)arg2 ;
-(id)_accessibilityFrontMostApplication;
-(id)_accessibilityFrontMostApplication;
-(int)_frontMostAppOrientation;
@end

@interface UIApplication (extras)
-(id)_accessibilityFrontMostApplication;
@end

@interface SBSearchResultsBackdropView : UIView
@end

@interface UIWindow (extras)
+(void)setAllWindowsKeepContextInBackground:(BOOL)arg1;
-(BOOL)isInternalWindow;
-(void)setDelegate:(id)arg1 ;
-(id)_clientsForRotation;
-(void)setContentView:(id)arg1 ;
-(void)_setRotatableViewOrientation:(int)arg1 duration:(double)arg2 force:(BOOL)arg3 ;
-(int)_windowInterfaceOrientation;
-(void)setAutorotates:(BOOL)arg1 ;
-(void)_addRotationViewController:(id)arg1 ;
-(id)contentView;
-(id)delegate;
-(void)_updateInterfaceOrientationFromDeviceOrientationIfRotationEnabled:(BOOL)arg1 ;
-(void)_updateToInterfaceOrientation:(int)arg1 animated:(BOOL)arg2 ;
-(void)_updateToInterfaceOrientation:(int)arg1 duration:(double)arg2 force:(BOOL)arg3 ;
-(void)makeKeyAndOrderFront:(id)arg1 ;
-(int)interfaceOrientation;
@end

@interface UIViewController (extras)
-(id)viewControllerForRotation;
-(unsigned)supportedInterfaceOrientations;
-(id)_embeddedDelegate;
-(id)transitioningDelegate;
-(void)setInterfaceOrientation:(int)arg1 ;
-(id)_window;
@end

@interface SBRootFolderView : UIView
-(void)setOrientation:(int)arg1 ;
-(id)delegate;
-(id)_viewDelegate;
@end

@interface SBSearchGesture
+(id)sharedInstance;
-(void)revealAnimated:(BOOL)arg1 ;
-(void)resetAnimated:(BOOL)arg1;
-(void)updateForRotation;
-(void)setTargetView:(id)arg1 ;
@end

@interface SBSearchGestureObserver
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2;
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
-(void)setHidden:(BOOL)arg1 ;
-(void)setStatusBarWindow:(id)arg1 ;
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

@interface SBUIController
-(BOOL)isAppSwitcherShowing;
@end

@interface SBIconScrollView : UIScrollView
@end

@interface AnySpotUIViewController : UIViewController
@end

@interface SBRootFolderController : UIViewController
-(void)setOrientation:(int)arg1 ;
-(void)willAnimateRotationToInterfaceOrientation:(int)arg1 ;
@end

// Convergance support
@interface CVResources : NSObject
+(BOOL)lockScreenEnabled;
@end

@implementation AnySpotSwitch
-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

static UIWindow *window = nil;
static SBSearchViewController *vcont = nil;
static SBRootFolderView *fv = nil; static SBRootFolderController *fvd = nil;
static UIToolbar *toolbar = nil;
static SBIconScrollView *gesTargetview = nil;
static BOOL willLaunchWithSBIcon = NO;
static BOOL willlaunchWithURL = NO;
static id sbicon = nil;
static int sbloc = nil;
static id urlResult = nil;
static id section = nil;
static NSString *displayIdentifier = @"";
static int brightness = 80;
static int alpha = 100;
static UIWindow *topMost = nil;
static BOOL hidecc, hidenc, hotfix_one, dynamicheader, translucent, clearbg, dark = YES;
static BOOL hotfix_two, logging, pleaselaunch, added, alphabutton, tint, enabled, blurbg = NO;

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
	//[vcont loadView];

    vcont = [objc_getClass("SBSearchViewController") sharedInstance];
    SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
	UIView *view = MSHookIvar<UIView *>(vcont, "_view");
	SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	SBWallpaperEffectView *blurView = MSHookIvar<SBWallpaperEffectView *>(sheader, "_blurView");
	if(!gesTargetview)	gesTargetview = MSHookIvar<SBIconScrollView *>(ges, "_targetView");
	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/org.thebigboss.anyspot.plist"]];
	
	if ([[view superview] isKindOfClass:[%c(SBRootFolderView) class]]) {
		fv = [(SBRootFolderView *)[view superview] retain];
		if([[fv delegate] isKindOfClass:[%c(SBRootFolderController) class]]) 
			fvd = [[fv delegate] retain];
	}

	if(!enabled) return; 
	
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

			if(logging) {
				NSLog(@"AnySpot: before anything ***********************************");
				NSLog(@"AnySpot: sheader's window = %@",[sheader window]);
				NSLog(@"AnySpot: view's window = %@",[view window]);
				NSLog(@"AnySpot: vcont window = %@",[vcont _window]);
				NSLog(@"AnySpot: target view's window = %@",[gesTargetview window]);
				NSLog(@"AnySpot: viewController window = %@",[vcont _window]);
				for(id subview in [view subviews]) {
					NSLog(@"AnySpot: view's window = %@ for %@",[subview window],subview);
				}
				NSLog(@"AnySpot: folderView delegate = %@",[fv delegate]);
				NSLog(@"AnySpot: folderView viewDelegate = %@",[fv _viewDelegate]);
				NSLog(@"AnySpot: target view's mask= %d",(int)[gesTargetview autoresizingMask]);
				NSLog(@"AnySpot: target view = %@",gesTargetview);
				NSLog(@"AnySpot: view auto resize subview = %d",(int)[view autoresizesSubviews]);
				NSLog(@"AnySpot: view sub view = %@",[view subviews]);
				// NSLog(@"AnySpot: vcont window contentview = %@",[[vcont _window] contentView]);
				// NSLog(@"AnySpot: vcont window contentview subviews = %@",[[[vcont _window] contentView] subviews]);
				// NSLog(@"AnySpot: vcont window contentview subviews subviews = %@",[[[[vcont _window] contentView] subviews][0] subviews]);
				// NSLog(@"AnySpot: vcont window contentview subviews subviews subviews = %@",[[[[[vcont _window] contentView] subviews][0] subviews][0] subviews]);
				// NSLog(@"AnySpot: vcont window contentview subviews subviews subviews = %@",[[[[[[vcont _window] contentView] subviews][0] subviews][0] subviews][0] subviews]);
				NSLog(@"AnySpot: keyWindow root view Controller = %@",[[UIApplication sharedApplication] keyWindow].rootViewController);
				NSLog(@"AnySpot: keyWindow delegate = %@",[[[UIApplication sharedApplication] keyWindow] delegate]);
				NSLog(@"AnySpot: keywindow's clients for rotation = %@",[[[UIApplication sharedApplication] keyWindow] _clientsForRotation]);
				NSLog(@"AnySpot: keywindow's interface orientation %d",[[[UIApplication sharedApplication] keyWindow] _windowInterfaceOrientation]);
				NSLog(@"AnySpot: view = %@",view);
				NSLog(@"AnySpot: target view's mask= %d",(int)[view autoresizingMask]);
				NSLog(@"AnySpot: Top App:%@", [(SpringBoard *)[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication]);
				NSLog(@"AnySpot: Top App orientation :%d", [(SpringBoard *)[%c(SpringBoard) sharedApplication] _frontMostAppOrientation]);
				UIStatusBar *status = [(SpringBoard *)[UIApplication sharedApplication] statusBar];
				NSLog(@"AnySpot: Statusbar WindowLevel = %f",((UIWindow *)[status statusBarWindow]).windowLevel);
				NSLog(@"AnySpot: view controller's interface orientation %d", (int)[vcont interfaceOrientation]);
				NSLog(@"AnySpot view controller's controllers for rotations = %@",[vcont viewControllerForRotation]);
				UIViewController *appContr = MSHookIvar<UIViewController *>((SpringBoard *)[%c(SpringBoard) sharedApplication].keyWindow, "_rootViewController");
				NSLog(@"AnySpot: UIApplication controllers for rotations = %@",[appContr viewControllerForRotation]);
				NSLog(@"AnySpot: view's supported orientations: %u",[vcont supportedInterfaceOrientations]); // originally 26?
				NSLog(@"AnySpot: view should auto rotate? = %d",[vcont shouldAutorotate]);
				NSLog(@"AnySpot current orientation: %d",[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]);
			}
			
			if(dynamicheader) {
				[blurView setStyle:0]; // 0 = transparent, 1 = hidden (not supported), 6 = default

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
			//if(window == NULL) window = [sheader window];
			NSLog(@"window %@",window);

			NSLog(@"window's level = %f",window.windowLevel);
            //
			//window = [[UIWindow alloc] initWithFrame:[[UIApplication sharedApplication].keyWindow bounds]];
            

            //window = [[UIWindow alloc] initWithFrame:[gesTargetview frame]];
           	// [view setFrame:[gesTargetview frame]];
           	// [view setBounds:[gesTargetview bounds]];


   //         	[vcont setInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] _frontMostAppOrientation]];
			// [vcont updateViewConstraints];
			// [ges updateForRotation];
			 //[ges setTargetView:window];

           	window.windowLevel = 998; //one less than the statusbar
            //[window setWindowLevel:9000]; // http://stackoverflow.com/questions/22241412/add-uiview-banner-above-status-bar-ios-7
			if ([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
				window.windowLevel = 1051;
				
				if ([objc_getClass("CVLockController") class]) {
					// Convergance support
					if ([objc_getClass("CVResources") lockScreenEnabled])
						window.windowLevel = 1065;
				}
			}
			if([[%c(SBUIController) sharedInstance] isAppSwitcherShowing]) {
				window.windowLevel = 10000;
				//UIStatusBar *status = [(SpringBoard *)[%c(SpringBoard) sharedApplication] statusBar];
				//[[status statusBarWindow] setWindowLevel:10001];
				//[status setHidden:NO];
				//[status setStatusBarWindow:window];
			}
			//window.windowLevel = 100000;
			//UIStatusBar *status = [(SpringBoard *)[%c(SpringBoard) sharedApplication] statusBar];
			//[[status statusBarWindow] setWindowLevel:10000];

            //window.hidden = NO;
            //window.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            // AnySpotUIViewController *myController = [[AnySpotUIViewController alloc] init];
            // [vcont setView:nil]; // Cant get rid of view for vcont as it is needed. "Applications are expected to have a root view controller at the end of application launch" SBAppWindow
            // [myController setView:view];            
            // window.rootViewController = myController;
            //window.rootViewController = vcont;
            ///[window _addRotationViewController:vcont];
            //[window setDelegate:[%c(SBUIController) sharedInstance]];
            //[window setDelegate:[[%c(SpringBoard) sharedApplication] delegate]];
            //[window setDelegate:[vcont _embeddedDelegate]];
            //[window setDelegate:[vcont transitioningDelegate]];
            //[window setDelegate:vcont];
            // //[window setDelegate:ges];
            //[window setContentView:view];
            
            [window setAutorotates:YES];
            //[window _addRotationViewController:vcont];
            [%c(SBSearchViewController) attemptRotationToDeviceOrientation];
            window.rootViewController = vcont;

            [window setRootViewController:vcont];
			
			[window setDelegate:vcont];
			[window setContentView:view];

			//NSLog(@"Springboard -(int)interfaceOrientationForCurrentDeviceOrientation; = %f",(float)[UIApplication interfaceOrientationForCurrentDeviceOrientation]);
			[window _setRotatableViewOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0 force:1];
			//[(SpringBoard *)%c(SpringBoard) _rotateView:view toOrientation:[[UIDevice currentDevice] orientation]];
			[vcont _forwardRotationMethods];
			
			//[fv setOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
			//[fvd setOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
			//[fvd willAnimateRotationToInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];

			topMost = [UIApplication sharedApplication].keyWindow;

			if(logging) {
				NSLog(@"AnySpot: Top Most keyWindow = %@",topMost);
				NSLog(@"AnySpot Top Most view Controller = %@",topMost.rootViewController);
			}

			// [topMost addSubview:view];
 
			// if(topMost != vcont) {
			// 	NSLog(@"GRATE GOD YOU DID THIS! %@",topMost);
			// 	didAddTopMost = YES;
			// 	[topMost presentViewController:vcont animated:YES completion:nil];
			// }
			

            if(hotfix_one) {
            	[window addSubview:view];
			}
			if(hotfix_two) {
				[window addSubview:sheader];
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
			//[self _fadeForLaunchWithDuration:0.25f completion:^void{[icon launchFromLocation:4];}];

			[window makeKeyAndVisible];
			[window makeKeyAndOrderFront:nil];

			//[ges setTargetView:[window contentView]];

			//[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];

			[ges setTargetView:window]; // This is for animations
			

			[ges revealAnimated:YES];
  
			//[ges updateForRotation];
			//[window _setRotatableViewOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] _frontMostAppOrientation] duration:0.0 force:0]; //force landscape


			

			//[ges updateForRotation];

			//[window _setRotatableViewOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0 force:1]; //force landscape
			//[ges updateForRotation];

			if(logging) {
				NSLog(@"AnySpot: After changing things ***********************************");
				NSLog(@"AnySpot: ges targetview = %@",MSHookIvar<UIView *>(ges, "_targetView"));
				NSLog(@"AnySpot: target observers = %@",MSHookIvar<UIView *>(ges, "_observers"));
				UIStatusBar *status = [(SpringBoard *)[UIApplication sharedApplication] statusBar];
				NSLog(@"AnySpot: Statusbar WindowLevel = %f",((UIWindow *)[status statusBarWindow]).windowLevel);
				NSLog(@"AnySpot: window's clients for rotation = %@",[window _clientsForRotation]);
				NSLog(@"AnySpot: window's interface orientation %d",[window _windowInterfaceOrientation]);
				NSLog(@"AnySpot: view controller's interface orientation %d", (int)[vcont interfaceOrientation]);
				NSLog(@"AnySpot view controller's controllers for rotations = %@",[vcont viewControllerForRotation]);
				NSLog(@"AnySpot: window's controllers for rotations = %@",[window.rootViewController viewControllerForRotation]);
				UIViewController *appContr = MSHookIvar<UIViewController *>((SpringBoard *)[%c(SpringBoard) sharedApplication].keyWindow, "_rootViewController");
				NSLog(@"AnySpot: UIApplication controllers for rotations = %@",[appContr viewControllerForRotation]);
				NSLog(@"AnySpot: view's supported orientations: %u",[vcont supportedInterfaceOrientations]);
			}

		}
	}
}
@end

%hook SBWallpaperEffectView
-(void)setStyle:(int)arg1 {
	if(logging) { %log; } 
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
		[vcont _fadeForLaunchWithDuration:0.3f completion:^void{
			SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	   		[ges setTargetView:gesTargetview];

			for(id view in [window subviews]) {
			[fv addSubview:view];
			}

			[window resignKeyWindow];
			[window release];
			window = nil;
		}];
	}

	
}
-(void)revealAnimated:(BOOL)arg1 {
	//%orig;



	// UIWindow *win = [vcont _window];
	// NSLog(@"%@ orientation = %d vs. %d",win,[win interfaceOrientation], [(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]);

	// if([win interfaceOrientation] != [(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]) {
	// 	[win _setRotatableViewOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0 force:1];
	// 	[vcont _forwardRotationMethods];		
	// 	[vcont window:win setupWithInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
	// 	[vcont window:win willAnimateRotationToInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0];	
	// 	[self updateForRotation];
	// 	[%c(SBSearchViewController) attemptRotationToDeviceOrientation];
	// }
	
	
	%orig;
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

-(void)searchGesture:(SBSearchGesture *)arg1 completedShowing:(BOOL)arg2 {
	%log;
	NSLog(@"AnySpot: viewController window = %@",[vcont _window]);
	NSLog(@"AnySpot: viewController parent controller = %@",vcont.parentViewController);

	if(arg2){
		UIWindow *win = [[vcont _window] retain];

		if(logging) NSLog(@"%@ orientation = %d vs. %d",win,[win interfaceOrientation], [(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]);

		if(win && [win interfaceOrientation] != [(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]) {
			[win _setRotatableViewOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0 force:1];
			[vcont _forwardRotationMethods];		
			[vcont window:win setupWithInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
			[vcont window:win willAnimateRotationToInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation] duration:0.0];	
			[arg1 updateForRotation];
			[%c(SBSearchViewController) attemptRotationToDeviceOrientation];
		}
		[fv setOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
		[fvd setOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
		[fvd willAnimateRotationToInterfaceOrientation:[(SpringBoard *)[%c(SpringBoard) sharedApplication] interfaceOrientationForCurrentDeviceOrientation]];
		[win release];
	} else {
		if(window) {
		[vcont _fadeForLaunchWithDuration:0.3f completion:^void{
			SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	   		[ges setTargetView:gesTargetview];

			for(id view in [window subviews]) {
			[fv addSubview:view];
			}

			[window resignKeyWindow];
			[window release];
			window = nil;
		}];
		}
	}

	
	%orig;	
}

%new
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(void)_resizeTableViewForPreferredContentSizeChange:(id)arg1 {
	%log;
	NSLog(@"GRATE GOD!");
	%orig;
}

%new
-(BOOL)shouldAutorotate {
	return YES;
}

-(BOOL)_hasResults {
	if(blurbg)	return YES;
	else return %orig;
}

%new
- (BOOL)shouldAutomaticallyForwardRotationMethods {
	return YES;
}

%new
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
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

%hook SpringBoard

-(void)noteInterfaceOrientationChanged:(int)arg1 duration:(float)arg2 {
	if(logging) %log;
	//[window _updateInterfaceOrientationFromDeviceOrientationIfRotationEnabled:YES];
	//[window _updateToInterfaceOrientation:arg1 duration:arg2 force:1];
	%orig;
	[window _setRotatableViewOrientation:arg1 duration:arg2 force:1];
	SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
	[ges updateForRotation];

	//[fv setOrientation:arg1];
	//[fvd setOrientation:arg1];
	//[fvd willAnimateRotationToInterfaceOrientation:arg1];
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

@implementation AnySpotUIViewController : UIViewController
-(unsigned)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate {
	return YES;
}
@end

static void loadPrefs() {
	//NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/org.thebigboss.anyspot.plist"]];

    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/org.thebigboss.anyspot.plist"];

    if(settings) {
    	enabled = [[settings objectForKey:@"anyspot_enabled"] boolValue]; 
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
    	blurbg = [[settings objectForKey:@"anyspot_blurbg"] boolValue];
    	brightness = [[settings objectForKey:@"anyspot_darkness"] integerValue]; 
    	alpha = [[settings objectForKey:@"anyspot_alpha"] integerValue];
    }
    if(logging) NSLog(@"AnySpot: settings = %@",settings);
    [settings release];
}

%hook SBRootFolderView 
-(void)addSubview:(id)arg1 {
	NSLog(@"Adding special view");
	NSLog(@"hooked view = %@",MSHookIvar<UIView *>([objc_getClass("SBSearchViewController") sharedInstance], "_view"));
	%log;
	%orig;
}
-(void)insertSubview:(id)arg1 below:(id)arg2 {
	%log;
	%orig;
}
-(void)insertSubview:(id)arg1 belowSubview:(id)arg2 {
	%log;
	%orig;
}
-(void)_addSubview:(id)arg1 positioned:(int)arg2 relativeTo:(id)arg3 {
	%log;
	%orig;
}
-(void)insertSubview:(id)arg1 aboveSubview:(id)arg2 {
	%log; %orig;
}
-(void)insertSubview:(id)arg1 above:(id)arg2 { %log; %orig; }
-(void)layoutViewsForSearch { %log; %orig;}
-(void)setOrientation:(int)arg1 { %log; %orig; }
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("org.thebigboss.anyspot/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
