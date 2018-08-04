#include "SiliquaPrefsRootListController.h"

@implementation SiliquaPrefsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

//: Button actions
-(void)goToOriginalCode {
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://github.com/LaughingQuoll/Siliqua"]];
}

-(void)goToModifiedCode {
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://github.com/LemaMichael/AIR"]];
}
@end


@protocol PreferencesTableCustomView
-(id)initWithSpecifier:(id)arg1;
@optional
-(CGFloat)preferredHeightForWidth:(CGFloat)arg1;
@end

@interface PSTableCell : UITableView
-(id)initWithStyle:(int)style reuseIdentifier:(id)arg2;
@end

@interface SiliquaBannerCell : PSTableCell <PreferencesTableCustomView> {

	UILabel *titleLabel;
	UILabel *descLabel;
	UILabel *creatorLabel;
	UILabel *modifierLabel;
	UILabel *other1Label;
	UILabel *other2Label;
}
@end
@implementation SiliquaBannerCell
-(id)initWithSpecifier:(id)specifier {

	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self) {

		CGRect titleFrame = CGRectMake(0, -15, [[UIScreen mainScreen] bounds].size.width, 60);
		CGRect descFrame = CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, 60);
		CGRect creatorFrame = CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 60);
		CGRect other1Frame = CGRectMake(0, 60, [[UIScreen mainScreen] bounds].size.width, 60);
		CGRect other2Frame = CGRectMake(0, -80, [[UIScreen mainScreen] bounds].size.width, 60);

		titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
		[titleLabel setNumberOfLines:1];
		titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
		[titleLabel setText:@"Airpods ++"];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.textAlignment = NSTextAlignmentCenter;

		descLabel = [[UILabel alloc] initWithFrame:descFrame];
		[descLabel setNumberOfLines:1];
		descLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[descLabel setText:@"Your AirPods are now useful!"];
		[descLabel setBackgroundColor:[UIColor clearColor]];
		descLabel.textColor = [UIColor grayColor];
		descLabel.textAlignment = NSTextAlignmentCenter;

		creatorLabel = [[UILabel alloc] initWithFrame:creatorFrame];
		[creatorLabel setNumberOfLines:1];
		creatorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[creatorLabel setText:@"Created by LaughingQuoll"];
		[creatorLabel setBackgroundColor:[UIColor clearColor]];
		creatorLabel.textColor = [UIColor grayColor];
		creatorLabel.textAlignment = NSTextAlignmentCenter;

		//: Thanks LaughingQuoll
		other1Label = [[UILabel alloc] initWithFrame:other1Frame];
		[other1Label setNumberOfLines:1];
		other1Label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        [other1Label setText:@"Modified by Lema"];
		[other1Label setBackgroundColor:[UIColor clearColor]];
		other1Label.textColor = [UIColor grayColor];
		other1Label.textAlignment = NSTextAlignmentCenter;

		other2Label = [[UILabel alloc] initWithFrame:other2Frame];
		[other2Label setNumberOfLines:1];
		other2Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10];
		[other2Label setText:@""];
		[other2Label setBackgroundColor:[UIColor clearColor]];
		other2Label.textColor = [UIColor blackColor];
		other2Label.textAlignment = NSTextAlignmentCenter;

		[self addSubview:titleLabel];
		[self addSubview:descLabel];
		[self addSubview:creatorLabel];
		[self addSubview:other1Label];
		[self addSubview:other2Label];
	}
	return self;
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	CGFloat prefHeight = 110.0;
	return prefHeight;
}
@end