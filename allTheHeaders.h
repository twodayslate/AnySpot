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
-(void)forceRotation;
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

@interface UIView (extras)
-(void)_updateContentSizeConstraints;
@end

@interface _UIBackdropView : UIView
-(void)setStyle:(int)arg1 ;
-(id)initWithStyle:(int)arg1 ;
@end

// Convergance support
@interface CVResources : NSObject
+(BOOL)lockScreenEnabled;
@end