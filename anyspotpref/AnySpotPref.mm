//#import <Preferences/PSListController.h>
@interface PSViewController 
-(void)setPreferenceValue:(id)arg1 specifier:(id)arg2 ;
@end

@interface PSListController : PSViewController { 
	NSArray* _specifiers; 
}
-(id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2 ;
-(void)reloadSpecifier:(id)arg1 ;
-(id)specifierForID:(id)arg1 ;
@end

@interface PSSpecifier
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

-(void)reset_brightness {
	PSSpecifier *darknessSpecifier = [self specifierForID:@"anyspot_darkness"];
	[self setPreferenceValue:@(60) specifier:darknessSpecifier];
	[self reloadSpecifier:darknessSpecifier];
	darknessSpecifier = [self specifierForID:@"anyspot_dark"];
	[self setPreferenceValue:@(1) specifier:darknessSpecifier];
	[self reloadSpecifier:darknessSpecifier];
}

-(void)reset_alpha {
	PSSpecifier *darknessSpecifier = [self specifierForID:@"anyspot_alpha"];
	[self setPreferenceValue:@(100) specifier:darknessSpecifier];
	[self reloadSpecifier:darknessSpecifier];
}
@end

// vim:ft=objc
