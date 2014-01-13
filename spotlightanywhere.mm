#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "substrate.h"
#import <UIKit/UIKit.h>

static BOOL isDisabled;

@interface FlipSLSwitch : NSObject <FSSwitchDataSource>
@end

@interface SBSearchViewController
+(id)sharedInstance;
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2 ;
-(id)_searchHeader;
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


@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
        return isDisabled?FSSwitchStateOff:FSSwitchStateOn;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
        SBSearchGesture *ges = [objc_getClass("SBSearchGesture") sharedInstance];



        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                isDisabled = NO;

                
                NSLog(@"new state = on");
                //[ges setEnabled:TRUE];
                [ges revealAnimated:TRUE];

                //[[[UIApplication sharedApplication] keyWindow] addSubview:vcont._searchHeader];
                //[[UIApplication sharedApplication] bringSubviewToFront:vcont._searchHeader];

                //for (int i = 0.0; i > 1.0; i = i + .1) {
                //	[vcont searchGesture:ges changedPercentComplete:i];
                //}
                
        }

        else if(newState == FSSwitchStateOff){
                isDisabled = YES;
                
                NSLog(@"new state = off");

                
                [ges resetAnimated:TRUE];
                for (int i = 1.0; i < 0; i = i - .1) {
                	[vcont searchGesture:ges changedPercentComplete:i];
                }
                
        }
}



@end