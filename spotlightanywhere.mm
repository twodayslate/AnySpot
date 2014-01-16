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


@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
		SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchGesture *ges = [objc_getClass("SBSearchGesture") sharedInstance];



        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                
                NSLog(@"new state = on");
                UIView *sheader = MSHookIvar<UIView *>(vcont, "_searchHeader");
                [[[UIApplication sharedApplication] keyWindow] insertSubview:sheader atIndex:0];
                // [[[UIApplication sharedApplication] keyWindow] addSubview:sheader];
                // [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sheader];

                [ges revealAnimated:TRUE];

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