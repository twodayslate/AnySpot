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

@interface SBSearchGesture
+(id)sharedInstance;
-(void)setEnabled:(BOOL)arg1 ;
-(void)revealAnimated:(BOOL)arg1 ;
-(void)resetAnimated:(BOOL)arg1 ;
-(id)targetView;
-(void)setTargetView:(id)arg1 ;
- (UIViewController*) topMostController;
@end

@interface SBSearchHeader
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

static UIWindow *window; 

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchGesture *ges = [objc_getClass("SBSearchGesture") sharedInstance];



        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                
                NSLog(@"new state = on");
                UIView *sheader = MSHookIvar<UIView *>(vcont, "_searchHeader");

                [[[UIApplication sharedApplication] keyWindow] insertSubview:sheader atIndex:0];

                UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                window.windowLevel = 9999*999;
                window.hidden = NO;
                [window addSubview:MSHookIvar<UIView *>(vcont, "_touchStealingView")];
				[window addSubview:sheader];
                // Above displays it but then makes the device unusable (window not dismised)
                // Also, header doesn't display fully http://i.imgur.com/hwLkw8u.png

                
                [ges revealAnimated:TRUE];
                ///[search becomeFirstResponder]; //set cursor location

                // http://blog.adambell.ca/post/73338421921/breaking-chat-heads-out-of-the-ios-sandbox
                // //http://pastie.org/pastes/7618709#2
                // UIView *hostView = [app1 contextHostViewForRequester:@"epichax1" enableAndOrderFront:YES];
                //UITextField *search = MSHookIvar<UITextField *>(sheader, "_searchField");
                
                // [[[UIApplication sharedApplication] keyWindow] addSubview:sheader];
                // [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sheader];

                
                //SBApplication *currentApplication = [objc_getClass("SpringBoard-Class") _accessibilityFrontMostApplication];
                
				//[ges setTargetView:view];

                //[[[UIApplication sharedApplication] keyWindow] insertSubview:sheader atIndex:0];
                // Everything pops up for a second and then it all disapears. The icons are still moved 
                // down (on Springboard), and you have to double press the home button to exit an app
                // so the phone thinks it is there. 
                
        }

        else if(newState == FSSwitchStateOff){
                
                NSLog(@"new state = off");

                [ges resetAnimated:TRUE];
                
        }
}



@end

