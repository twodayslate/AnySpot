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
@end

@interface SBIcon
-(void)launchFromLocation:(int)arg1 ;
@end

@interface SBApplicationIcon : SBIcon
@end


@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

UIWindow *window = nil;
SBSearchViewController *vcont = nil;
SBRootFolderView *fv = nil;
//BOOL willLaunch = FALSE;
-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
        //UIView *container = MSHookIvar<UIView *>(sheader, "_container");
        //UITextField *search = MSHookIvar<UITextField *>(sheader, "_searchField");
        //UITableView *table = MSHookIvar<UITableView *>(vcont, "_tableView");
		//SBSearchResultsBackdropView *bd = MSHookIvar<SBSearchResultsBackdropView *>(vcont, "_tableBackdrop");
		//UIView *ts = MSHookIvar<UIView *>(vcont, "_touchStealingView");
		UIView *view = MSHookIvar<UIView *>(vcont, "_view");
		SBSearchGesture *ges = [%c(SBSearchGesture) sharedInstance];
		if ([[view superview] isKindOfClass:[%c(SBRootFolderView) class]]) {
			fv = (SBRootFolderView *)[view superview];
		}
		//NSLog(@"_view = %@",view);
		//NSLog(@"_view superview = %@",[view superview]);
		//NSLog(@"sbrootfolderview = %@",fv);

        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                window.windowLevel = 9999*999;
                window.hidden = NO;
                window.rootViewController = vcont;

                [window addSubview:view];
                //[window addSubview:sheader];
                [window makeKeyAndVisible];

                sheader.hidden = NO;
				[sheader setAlpha:1.0];
				view.hidden = NO;
				[view setAlpha:1.0];

				//[sheader searchGesture:nil changedPercentComplete:1.0];
     			//[vcont searchGesture:nil changedPercentComplete:1.0];
                //[vcont searchGesture:nil completedShowing:YES];
                [ges revealAnimated:TRUE];
             
        } else if(newState == FSSwitchStateOff){
                //[vcont searchGesture:nil changedPercentComplete:0.0];
                //[vcont searchGesture:nil completedShowing:NO]; 
                [ges resetAnimated:TRUE];
         
        }
        
}
@end

%hook SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 {
	NSLog(@"inside"); //called when hitting on note
	if([(SpringBoard*)[%c(SpringBoard) sharedApplication] isLocked]) {
		NSLog(@"is locked");
	} 
	return %orig;
}
%end

%hook SBSearchGesture
-(void)resetAnimated:(BOOL)arg1 {
	%log;
	%orig;
	if(window) {
		[fv addSubview:[[window subviews] objectAtIndex:0]];
		[window release];
		window = nil;
	}
}
%end

%hook UIApplication
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2  {
	%log;
	return %orig;
	if(window) {
		[fv addSubview:[[window subviews] objectAtIndex:0]];
		[window release];
		window = nil;
	}
}
%end

%hook SBSearchViewController
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2  {
	%log;
	%orig;
	//willLaunch = TRUE;
}
%end

%hook SpringBoard
-(BOOL)_launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2  {
	%log;
	return %orig;
}
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2  {
	%log;
	return %orig;
}
-(BOOL)_accessibilityShouldAllowAppLaunch { %log; return %orig;}
%end


%hook SBApplicationIcon
- (void)launchFromLocation:(int)location { //0 = SB, 4 = SP
        %log; 
        NSLog(@"displayIdentifier = %@",MSHookIvar<UIView *>(self, "_displayIdentifier"));
        %orig;

}
-(void)launch { %log; %orig; }
%end