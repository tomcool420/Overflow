//
//  OverflowSettings.m
//  Overflow2
//
//  Created by Thomas Cool on 10/20/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//
#import "OverflowSettings_old.h"
#import "BackRow/BRSimpleMenuItem.h"

#define kSMFApplianceOrderKey   @"FRAppliancePreferedOrderValue"
#define PREFS [OverflowSettings preferences]
static NSString * const kHiddenArray  = @"Hidden";
static NSArray * _hidden = nil;
@implementation OverflowSettings
+(SMFPreferences *)preferences {
    static SMFPreferences *_preferences = nil;
    
    if(!_preferences)
    {
        _preferences = [[SMFPreferences alloc] initWithPersistentDomainName:@"org.tomcool.Overflow"];
        [_preferences registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],kHiddenArray,nil]];

    }
    
    return _preferences;
}
-(id)previewControlForItem:(long)item
{
    BRImageAndSyncingPreviewController *p = [[BRImageAndSyncingPreviewController alloc] init];
    [p setImage:[BRImage imageWithPath:[[NSBundle bundleForClass:[OverflowSettings class]] pathForResource:@"overflow" ofType:@"png"]]];
    return [p autorelease];
}
- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return ((long)[_items count]);}
- (id)itemForRow:(long)row					{ 
    if (row>=[_items count])
        return nil;
    
    SMFMenuItem *it = [_items objectAtIndex:row];
    if (row<[_paths count])
    {

        [it setRightJustifiedText:([_hidden containsObject:[[_paths objectAtIndex:row]lastPathComponent]]?@"Overflow":@"Main Menu") 
                       withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
    }
    return it;}
//- (long)rowForTitle:(id)title				{ return [_titles indexOfObject:title];}
- (id)titleForRow:(long)row					{ 
    if (row>=[_items count]) {
        return nil;
    }
    return [_titles objectAtIndex:row];
}

//{ NSLog(@"%@\n%@",[_items objectAtIndex:row], [[_items objectAtIndex:row] title]);
//                                                    return [[_items objectAtIndex:row] title];}
- (long)defaultIndex			{ return 0;}
+(NSString *)rootMenuLabel
{
    return @"tomcool.overflow.settings";
}
-(id)init
{
    if((self = [super init]) != nil){
        
        [[self list] setDatasource:self];
        [self setListTitle:@"Overflow Settings"];
        [self reloadtitles];
        return self;
    }
    return nil;
}
                    
-(void)reloadtitles
{
    [_items release];
    [_titles release];
    [_paths release];
    [_it release];
    
    _hidden = [[PREFS objectForKey:kHiddenArray] retain];
    
    _items = [[NSMutableArray alloc] init];
    _titles = [[NSMutableArray alloc] init];
    _paths = [[NSMutableArray alloc] init];
    _it = [[NSMutableArray alloc]init];
    [[self list]removeDividers];
    
    SMFMenuItem * result;
    
    
    NSString *lowtidePath = [[NSBundle mainBundle] bundlePath];
    NSString *frapPath = [lowtidePath stringByAppendingPathComponent:@"Appliances"];
    NSDirectoryEnumerator *iterator = [[NSFileManager defaultManager] enumeratorAtPath:frapPath];
    
    NSString *filePath = nil;
    
    while((filePath = [iterator nextObject])) {
        if([[filePath pathExtension] isEqualToString:@"frappliance"] && ![filePath isEqualToString:@"Overflow.frappliance"]) 
        {
            NSBundle *applianceBundle = [NSBundle bundleWithPath:[frapPath stringByAppendingPathComponent:filePath]];
//            NSString *applianceClassName = NSStringFromClass([applianceBundle principalClass]);
            NSString *name = [[applianceBundle localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
            if(name)
            {
                result= [SMFMenuItem menuItem];
                [result setTitle:name];

                [_titles addObject: name];
                [_items addObject: result];
                [_paths addObject: [frapPath stringByAppendingPathComponent:filePath]];
            }
        }
    }
    [[self list] addDividerAtIndex:[_items count] withLabel:@"Settings"];
    result=[SMFMenuItem menuItem];
    [result setDimmed:YES];
    [result setTitle:@"Overflow Settings"];
    [_items addObject:result];
    [_it addObject:[NSNumber numberWithInt:0]];
    
    result=[SMFMenuItem menuItem];
    [result setTitle:@"Restart Lowtide"];
    [_items addObject:result];
    [_it addObject:[NSNumber numberWithInt:1]];
    [_titles addObject:@"Restart Lowtide"];
    
    result=[SMFMenuItem menuItem];
    [result setTitle:@"Fix Old Overflow"];
    [_items addObject:result];
    [_it addObject:[NSNumber numberWithInt:2]];
    [_titles addObject:@"Fix Old Overflow"];
    
    [[self list]reload];
}
- (void)itemSelected:(long)selected
{
    if (selected<[_paths count]) {

        NSMutableArray *h = [_hidden mutableCopy];
        if ([h containsObject:[[_paths objectAtIndex:selected] lastPathComponent]]) 
        {
            [h removeObject:[[_paths objectAtIndex:selected] lastPathComponent]];
        }
        else {
            [h addObject:[[_paths objectAtIndex:selected] lastPathComponent]];
        }
        [PREFS setObject:h forKey:kHiddenArray];
        [_hidden release];
        _hidden=[[PREFS objectForKey:kHiddenArray] retain];
        [[self list]reload];
        [(BRMainMenuController *)[[[BRApplicationStackManager singleton]stack] rootController] reloadMainMenu];
    }
    else if(selected<([_paths count]+[_it count]))
    {
        selected-=[_paths count];
        if ([[_it objectAtIndex:selected] intValue]==1) {
            [[BRApplication sharedApplication] terminate];
        }
        if ([[_it objectAtIndex:selected] intValue]==2) 
        {
            int r=0;
            for (NSString *path in _paths) 
            {
                NSString *lp = @"/usr/bin/OverflowHelper";
                NSArray *args = [NSArray arrayWithObjects:@"--show",path,nil];
                NSString *call = [NSString stringWithFormat:@"%@ %@",lp,[args componentsJoinedByString:@" "],nil];
                r+= system([call UTF8String]);
                if (r==0) {
                    [[self stack]pushController:[BRAlertController alertOfType:0 
                                                                        titled:@"Overflow Fix" primaryText:@"All old overflow changes have been fixed" secondaryText:nil]];
                }
                else
                    [[self stack]pushController:[BRAlertController alertOfType:0 
                                                                        titled:@"Overflow Fix" primaryText:@"All old overflow changes should have been fixed" secondaryText:@"but there was an error"]];
            }
        }
    }

}
-(void)dealloc
{
    [_it release];
//    [_items release];
    [_titles release];
    [_paths release];
    [super dealloc];
}
@end
