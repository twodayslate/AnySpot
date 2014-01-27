#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "CydiaSubstrate.h"
#import <UIKit/UIKit.h>

@interface FlipSLSwitch : NSObject <FSSwitchDataSource>
@end

@interface SBSearchViewController
+(id)sharedInstance;
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2;
-(BOOL)isVisible;
-(void)loadView;
-(void)cancelButtonPressed;
@end

@interface SBSearchHeader : UIView
@end

@interface SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 ;
@end

@interface SBApplication
-(id)contextHostViewForRequester:(id)requester enableAndOrderFront:(BOOL)front;
@end

@interface SpringBoard
-(id)_accessibilityFrontMostApplication;
@end

@interface SBSearchResultsBackdropView : UIView
@end

@interface UIWindow (extras)
+(void)setAllWindowsKeepContextInBackground:(BOOL)arg1;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

UIWindow *window;

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
        UIView *container = MSHookIvar<UIView *>(sheader, "_container");
        UITextField *search = MSHookIvar<UITextField *>(sheader, "_searchField");
        UITableView *table = MSHookIvar<UITableView *>(vcont, "_tableView");
		SBSearchResultsBackdropView *bd = MSHookIvar<SBSearchResultsBackdropView *>(vcont, "_tableBackdrop");
		UIView *ts = MSHookIvar<UIView *>(vcont, "_touchStealingView");
		//UIView *view = MSHookIvar<UIView *>(vcont, "_view");
		
        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                
                NSLog(@"new state = on");

                // [[[UIApplication sharedApplication] keyWindow] addSubview:sheader];
                // [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sheader];
                // sheader.removedOnCompletion=NO;
                //[[[UIApplication sharedApplication] keyWindow] insertSubview:sheader atIndex:0];

                //UIView *container = MSHookIvar<UIView *>(sheader, "_container"); 
                CGPoint newCenter = sheader.center;
				newCenter.x = 160;
				CGRect newBounds = CGRectMake(0, 0, 320, 73);

				sheader.hidden = NO;
				[sheader setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        sheader.center = newCenter;
			        sheader.bounds = newBounds;
			    }];

			    newCenter = container.center;
				newCenter.x = 160;
				newBounds = CGRectMake(0, 0, 320, 29);
				CGRect newFrame = CGRectMake(0,31,320,29);

				container.hidden = NO;
				[container setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        container.center = newCenter;
			        container.bounds = newBounds;
			        container.frame = newFrame;
			    }];

				newCenter = search.center;
				newCenter.x = 127.5;
				newBounds = CGRectMake(0, 0, 239, 29);
				newFrame = CGRectMake(8,0,239,29);

				search.hidden = NO;
				[search setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        search.center = newCenter;
			        search.bounds = newBounds;
			        search.frame = newFrame;
			    }];

                newCenter = table.center;
				newCenter.x = 160;
				newCenter.y = 320.5;
				newBounds = CGRectMake(0, 0, 320, 495);
				newFrame = CGRectMake(0,73,320,495);

				table.hidden = NO;
				[table setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        table.center = newCenter;
			        table.bounds = newBounds;
			        table.frame = newFrame;
			    }];

			    newCenter = ts.center;
				newCenter.x = 160;
				newCenter.y = 284;
				newBounds = CGRectMake(0, 0, 320, 568);
				newFrame = CGRectMake(0,0,320,568);

				ts.hidden = NO;
				[ts setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        ts.center = newCenter;
			        ts.bounds = newBounds;
			        ts.frame = newFrame;
			    }];

			    newCenter = bd.center;
				newCenter.x = 160;
				newCenter.y = 320.5;
				newBounds = CGRectMake(0, 0, 320, 495);
				newFrame = CGRectMake(0,73,320,495);

				bd.hidden = NO;
				[bd setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        bd.center = newCenter;
			        bd.bounds = newBounds;
			        bd.frame = newFrame;
			    }];
                window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                window.windowLevel = 9999*999;
                window.hidden = NO;
                //[window addSubview:MSHookIvar<UIView *>(vcont, "_touchStealingView")];
				[window addSubview:bd];
                [window addSubview:table];
                [window addSubview:sheader];
             
        }

        else if(newState == FSSwitchStateOff){
                
                NSLog(@"new state = off");
                [window release];
                [vcont loadView];
                //[ges resetAnimated:TRUE];
                
        }
}



@end


%hook SBSearchViewController
-(void)cancelButtonPressed {
	if(window) {
		[window release];
	} else {
		%orig;
	}
}
%end

%hook SBSearchModel
-(id)launchingURLForResult:(id)arg1 withDisplayIdentifier:(id)arg2 andSection:(id)arg3 {
	if(window) {
		[window release];
	} 
	return %orig;
}
%end