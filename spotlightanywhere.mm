#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "substrate.h"

static BOOL isDisabled;

@interface FlipSLSwitch : NSObject <FSSwitchDataSource>
@end

@interface SBSearchViewController
+(id)sharedInstance;
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2 ;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
        return isDisabled?FSSwitchStateOff:FSSwitchStateOn;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{
        if(newState == FSSwitchStateIndeterminate)
                return;

        else if(newState == FSSwitchStateOn){
                isDisabled = NO;

                SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
                NSLog(@"new state = on");
                [vcont searchGesture:Nil changedPercentComplete:1.0];
                
        }

        else if(newState == FSSwitchStateOff){
                isDisabled = YES;
                SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
                NSLog(@"new state = off");
                [vcont searchGesture:Nil changedPercentComplete:0.0];
        }
}

@end