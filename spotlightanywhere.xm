#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "CydiaSubstrate.h"
#import <UIKit/UIKit.h>
#import "SpringBoard.h"

@interface FlipSLSwitch : NSObject <FSSwitchDataSource>
@end

@interface SBSearchHeader : UIView
@end

@interface SBApplication
-(id)contextHostViewForRequester:(id)requester enableAndOrderFront:(BOOL)front;
@end

@interface SBSearchResultsBackdropView : UIView
@end

@interface SpringBoard (extras)
- (void)_revealSpotlight;
- (void)quitTopApplication:(struct __GSEvent *)arg1;
- (id)_accessibilityFrontMostApplication;
- (void)_revealSpotlight;
@end

@interface SBSearchViewController
+(id)sharedInstance;
-(void)searchGesture:(id)arg1 changedPercentComplete:(float)arg2;
-(BOOL)isVisible;
@end

@implementation FlipSLSwitch

-(FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier{
	SBSearchViewController *vcont = [objc_getClass("SBSearchViewController") sharedInstance];
	return [vcont isVisible]?FSSwitchStateOn:FSSwitchStateOff;
}

-(void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier{		
		switch(newState){
			case FSSwitchStateIndeterminate:return;
			case FSSwitchStateOn:{
                // Activate Spotlight
				[(SpringBoard *)[UIApplication sharedApplication] _revealSpotlight];
				break;
			}
			case FSSwitchStateOff:
				NSLog(@"new state = off");
				break;
			default:return; 
		}
}
@end

%hook SpringBoard
- (void)_revealSpotlight{
	%log;
	%orig;
}
%end
	
%hook SBAppToAppWorkspaceTransaction 
-(BOOL)selfApplicationWillBecomeReceiver:(id)arg1 fromApplication:(id)arg2{
	
	// This is fired when the app is told to close
	
	%log;
	NSLog(@"-----------");
	if(arg2){
		SBApplication *app = (SBApplication*)arg2;
		NSLog(@"From App Arg: %@",app);
	}
	BOOL superR = %orig;
	NSLog(@"Orig %d",superR);
	NSLog(@"-----------");	
	return superR;
}	
%end
	
%hook SBWorkspace
-(BOOL)_applicationExited:(id)arg1 withInfo:(id)arg2{
	%log;
	BOOL superR = %orig;
	NSLog(@"Orig %d",superR);
	return superR;
}
%end