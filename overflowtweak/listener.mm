#include <substrate.h>
#import "Beigelist.h"
#import <SMFramework/SMFramework.h>
static SMFPreferences * _preferences = nil;
static NSString * const kHiddenArray  = @"Hidden";

@interface OverflowLoadListener: NSObject <BeigelistApplianceLoadListener>

+ (BOOL)shouldLoadApplianceBundle:(NSBundle *)bundle;

@end

@implementation OverflowLoadListener
// optional
+ (BOOL)shouldLoadApplianceBundle:(NSBundle *)bundle {
	
	NSString *l = [[bundle bundlePath] lastPathComponent];
	if([[_preferences objectForKey:kHiddenArray] containsObject:l])
	{
		return NO;
	}
	return YES;
}

// optional
+ (void)loadedApplianceBundle:(NSBundle *)bundle {
}

+ (void)initialize
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_preferences = [[SMFPreferences alloc] initWithPersistentDomainName:@"org.tomcool.Overflow"];
	[_preferences registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],kHiddenArray,nil]];
	[pool release];
}

+ (void)load {
	[_BEIGELIST registerApplianceLoadListener:self];
}
@end

//MSInitialize
//{
//	NSLog(@"where is this?2");
//		// _preferences = [[SMFPreferences alloc] initWithPersistentDomainName:@"org.tomcool.Overflow"];
//		//[_preferences registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],kHiddenArray,nil]];
//}
