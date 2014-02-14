#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface AnySpotPreferenceController : PSListController
- (id)specifiers;
@end

@implementation AnySpotPreferenceController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AnySpot" target:self] retain];
  }
	return _specifiers;
}

- (void)restartAS:(id)param
{
	//system("killall assistivetouchd");
}

@end