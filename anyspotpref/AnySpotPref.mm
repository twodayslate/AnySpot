#import <Preferences/Preferences.h>

@interface AnySpotPrefListController: PSListController {
}
@end

@implementation AnySpotPrefListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AnySpotPref" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
