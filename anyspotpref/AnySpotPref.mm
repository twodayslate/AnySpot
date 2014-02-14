//#import <Preferences/PSListController.h>
@interface PSListController { 
	NSArray* _specifiers; 
}
-(id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2 ;
@end

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
