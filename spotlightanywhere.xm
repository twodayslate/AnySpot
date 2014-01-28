#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "CydiaSubstrate.h"
#import <UIKit/UIKit.h>

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
@end

@interface SBSearchHeader : UIView
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2 ;
@end

@interface SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 ;
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

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

UIWindow *window;
SBSearchViewController *vcont;

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
        //UIView *container = MSHookIvar<UIView *>(sheader, "_container");
        //UITextField *search = MSHookIvar<UITextField *>(sheader, "_searchField");
        //UITableView *table = MSHookIvar<UITableView *>(vcont, "_tableView");
		//SBSearchResultsBackdropView *bd = MSHookIvar<SBSearchResultsBackdropView *>(vcont, "_tableBackdrop");
		//UIView *ts = MSHookIvar<UIView *>(vcont, "_touchStealingView");
		UIView *view = MSHookIvar<UIView *>(vcont, "_view");

        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){

                NSLog(@"new state = on");

                window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                window.windowLevel = 9999*999;
                window.hidden = NO;
                window.rootViewController = vcont;

                [window addSubview:view];
                [window addSubview:sheader];
                [window makeKeyAndVisible];

                sheader.hidden = NO;
				[sheader setAlpha:1.0];
				view.hidden = NO;
				[view setAlpha:1.0];

     			[vcont searchGesture:nil changedPercentComplete:1.0];
                [vcont searchGesture:nil completedShowing:YES];
                [sheader searchGesture:nil changedPercentComplete:1.0]; 
             
        } else if(newState == FSSwitchStateOff){
                
                NSLog(@"new state = off");
                [vcont loadView];
                [sheader searchGesture:nil changedPercentComplete:0.0];
                [vcont searchGesture:nil changedPercentComplete:0.0];
                [vcont searchGesture:nil completedShowing:NO]; 
	            [vcont loadView];
	            if(window) { [window release]; } 
                window = nil;
                //[ges resetAnimated:TRUE];
        }
        
}



@end


%hook SBSearchViewController
-(void)cancelButtonPressed {
	if(window) {
		[vcont loadView];
        [vcont searchGesture:nil changedPercentComplete:0.0];
        [vcont searchGesture:nil completedShowing:NO];
		if(window) { [window release]; }
		window = nil;
	} else {
		%orig;
	}
}
%end

%hook SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 {
	if(window) {
		[vcont searchGesture:nil changedPercentComplete:0.0];
        [vcont searchGesture:nil completedShowing:NO];
		[vcont loadView];
		if(window) { [window release]; }
		window = nil;
	} 
	return %orig;
}
%end

%hook SpringBoard //Is activator fucking this up?
-(void)_menuButtonUp:(id)arg1 { //This doesn't run, wrong method
	if(window) {
		[vcont searchGesture:nil changedPercentComplete:0.0];
        [vcont searchGesture:nil completedShowing:NO];
        [vcont _setShowingKeyboard:NO];
        [vcont loadView];
		if(window) { [window release]; }
		window = nil;
	} else {
		%orig;
	}
}
%end