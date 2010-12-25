
#include <substrate.h>
#import <SMFramework/SMFramework.h>
static SMFPreferences * _preferences = nil;
static NSString * const kHiddenArray  = @"Hidden";
%hook BRApplianceManager
- (void)_loadApplianceAtPath:(id)path
{
    //%log;
    if([[_preferences objectForKey:kHiddenArray] containsObject:[path lastPathComponent]])
        /*
         * If Overflow declares it hidden, do not load it ;)
         */
        return;
    %orig;
}
- (void)_loadAppliancesInFolder:(id)folder
{
    %orig;
    /*
     *  If other frappliances need to be loaded, just run
     *  [self _loadApplianceAtPath:(NSString *)path];
     *  after the %orig;
     */
}
%end
MSInitialize
{
    _preferences = [[SMFPreferences alloc] initWithPersistentDomainName:@"org.tomcool.Overflow"];
    [_preferences registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],kHiddenArray,nil]];
}