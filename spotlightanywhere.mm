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

@end

@interface SBSearchHeader : UIView
@end

@interface SBApplication
-(id)contextHostViewForRequester:(id)requester enableAndOrderFront:(BOOL)front;
@end

@interface SpringBoard
-(id)_accessibilityFrontMostApplication;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchHeader *sheader = MSHookIvar<SBSearchHeader *>(vcont, "_searchHeader");
        UIView *container = MSHookIvar<UIView *>(sheader, "_container");
        UITextField *search = MSHookIvar<UITextField *>(sheader, "_searchField");

        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                
                NSLog(@"new state = on");

                [[[UIApplication sharedApplication] keyWindow] addSubview:sheader];
                [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sheader];

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

				container.hidden = NO;
				[container setAlpha:1.0];

                [UIView animateWithDuration:1.0 
			    animations:^{
			        search.center = newCenter;
			        search.bounds = newBounds;
			        search.frame = newFrame;
			    }];

    //             UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //             window.windowLevel = 9999*999;
    //             window.hidden = NO;
    //             [window addSubview:MSHookIvar<UIView *>(vcont, "_touchStealingView")];
				// [window addSubview:sheader];
                // Above displays it but then makes the device unusable (window not dismised)
                // Also, header doesn't display fully http://i.imgur.com/hwLkw8u.png

                
                //[ges revealAnimated:TRUE];
                
                [search becomeFirstResponder]; //set cursor location

                // http://blog.adambell.ca/post/73338421921/breaking-chat-heads-out-of-the-ios-sandbox
                // //http://pastie.org/pastes/7618709#2
                // UIView *hostView = [app1 contextHostViewForRequester:@"epichax1" enableAndOrderFront:YES];
                //
                
                

                
                //SBApplication *currentApplication = [objc_getClass("SpringBoard-Class") _accessibilityFrontMostApplication];
                
				//[ges setTargetView:view];

                //[[[UIApplication sharedApplication] keyWindow] insertSubview:sheader atIndex:0];
                // Everything pops up for a second and then it all disapears. The icons are still moved 
                // down (on Springboard), and you have to double press the home button to exit an app
                // so the phone thinks it is there. 
                
        }

        else if(newState == FSSwitchStateOff){
                
                NSLog(@"new state = off");

                //[ges resetAnimated:TRUE];
                
        }
}



@end

