//
//  overflow.mm
//  Overflow2
//
//  Created by Thomas Cool on 10/20/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

//#import "overflow.h"
#import <Foundation/Foundation.h>
#import "CPlusFunctions.mm"
#import "OverflowSettings.h"
#import "OFlowMenu.h"
#define SETTINGS_ID @"settingsIdentifier"
#define TEST_ID @"test"
#define kSMFApplianceOrderKey   @"FRAppliancePreferedOrderValue"

#define SETTINGS_CAT [BRApplianceCategory categoryWithName:@"Overflow Settings" identifier:SETTINGS_ID preferredOrder:5]
#define TEST_CAT [BRApplianceCategory categoryWithName:@"TEST" identifier:TEST_ID preferredOrder:10]
static NSString * const kHiddenArray  = @"Hidden";

@interface BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage;

@end
//
//
@implementation BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage
{
	return MSHookIvar<BRImageControl *>(self, "_productImage");
}

@end
@interface OFTopShelfController : NSObject {
}
- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
@end
@implementation OFTopShelfController



- (void)selectCategoryWithIdentifier:(id)identifier 
{
	
}
-(void)refresh { }



- (BRTopShelfView *)topShelfView {
	
	BRTopShelfView *topShelf = [[BRTopShelfView alloc] init];
	BRImageControl *imageControl = [topShelf productImage];
	BRImage *gpImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[OverflowSettings class]] pathForResource:@"overflow" ofType:@"png"]];
	[imageControl setImage:gpImage];
	
	return topShelf;
}
@end
@interface overflowAppliance : BRBaseAppliance {
    NSArray *_applianceCategories;
    OFTopShelfController *_topShelfController;
}
-(void)reloaddCategories;
@property(nonatomic, readonly, retain) id topShelfController;

@end

@implementation overflowAppliance
@synthesize topShelfController=_topShelfController;



-(id)init
{
    if((self = [super init]) != nil) 
    {

        _topShelfController=[[OFTopShelfController alloc] init];
		_applianceCategories = [[NSArray alloc] initWithObjects:SETTINGS_CAT ,nil];
        [self reloaddCategories];
        
	}
    return self;
}
-(void)reloaddCategories
{
    NSMutableArray *categories = [NSMutableArray array];
    NSString *frapPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Appliances"];
    NSArray *ATVPlugins=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:frapPath error:nil];
    NSEnumerator *plugEnum = [ATVPlugins objectEnumerator];
    id plugin;
    float i=0.;
    NSMutableArray *objects=[[NSMutableArray alloc]init];
    NSArray *hidden = [[OverflowSettings preferences] objectForKey:kHiddenArray];
    while ((plugin=[plugEnum nextObject])!=nil) {
        if ([[plugin pathExtension] isEqualToString:@"frappliance"]) {
            if ([hidden containsObject:[plugin lastPathComponent]]) {
                NSBundle *bundle = [NSBundle bundleWithPath:[frapPath stringByAppendingPathComponent:[plugin lastPathComponent]]];
                NSString *name = [[bundle localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
                if ([name length]==0) {
                    name=@"No Name";
                }
                [categories addObject:[BRApplianceCategory categoryWithName:name
                                                                 identifier:plugin
                                                             preferredOrder:i+=1.]];
                
                
                
                
            }
        }
    }
    [categories addObject:SETTINGS_CAT];
    [_applianceCategories release];
    _applianceCategories = [categories copy];
}
- (id)applianceCategories {
	return _applianceCategories;
}

- (id)identifierForContentAlias:(id)contentAlias {
	return @"Overflow";
}


- (BOOL)handleObjectSelection:(id)fp8 userInfo:(id)fp12 {
	return YES;
}

- (id)applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {
    return nil;
}
- (BOOL)handlePlay:(id)play userInfo:(id)info
{
    return YES;
}

- (id)controllerForIdentifier:(id)identifier args:(id)args
{
	
	id menuController = nil;
	
	if ([identifier isEqualToString:SETTINGS_ID]) 
    {
        menuController = [[[OverflowSettings alloc] init] autorelease];
        
        
        
        
    }
    else if([identifier isEqualToString:@"test"])
    {

        
    }
    else {
        NSString *lowtidePath = [[NSBundle mainBundle] bundlePath];
        NSString *frapPath = [[lowtidePath stringByAppendingPathComponent:@"Appliances"] 
                              stringByAppendingPathComponent:identifier];
        NSBundle *b = [NSBundle bundleWithPath:frapPath];
        [b load];
        if (![b isLoaded]) {
            [b load];
        }
        menuController = [[[OFlowMenu alloc]initWithBundle:b] autorelease];
    
}
return menuController;

}

- (id)localizedSearchTitle { return @"Overflow"; }
- (id)applianceName { return @"Overflow"; }
- (id)moduleName { return @"Overflow"; }
- (id)applianceKey { return @"Overflow"; }
@end
