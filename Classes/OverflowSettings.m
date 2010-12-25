//
//  OverflowSettingsN.m
//  Overflow
//
//  Created by Thomas Cool on 12/15/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

#import "OverflowSettings.h"

#define PREFS [OverflowSettings preferences]
static NSString * const kHiddenArray  = @"Hidden";
static NSArray * _hidden = nil;
static int _optionsCount = 0;

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
    SMFBaseAsset *a = [[SMFBaseAsset alloc] init];
    [a setCoverArt:[BRImage imageWithPath:[[NSBundle bundleForClass:[OverflowSettings class]] pathForResource:@"overflow" ofType:@"png"]]];
    [a setTitle:[self titleForRow:item]];
    SMFMediaPreview *p = [[SMFMediaPreview alloc] init];
    [p setAsset:a];
    [p setShowsMetadataImmediately:YES];
    [a release];
    return [p autorelease];
}
- (id)itemForRow:(long)row					{ 
    
    
    SMFMenuItem *it = [super itemForRow:row];
    if (row<[_options count])
    {
        
        [it setRightJustifiedText:([_hidden containsObject:[[_options objectAtIndex:row]lastPathComponent]]?@"Overflow":@"Main Menu") 
                   withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
    }
    return it;
}
-(id)init
{
    self=[super init];
    if (self) {
        _optionsCount=0;
        _hidden = [[PREFS objectForKey:kHiddenArray] retain];
        [[self list] setDatasource:self];
        [self setListTitle:@"Overflow Settings"];
        
        SMFMenuItem * result=nil;
        NSString *frapPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Appliances"];
        NSDirectoryEnumerator *iterator = [[NSFileManager defaultManager] enumeratorAtPath:frapPath];
        
        NSString *filePath = nil;
        
        while((filePath = [iterator nextObject])) 
        {
            if([[filePath pathExtension] isEqualToString:@"frappliance"] && ![filePath isEqualToString:@"Overflow.frappliance"]) 
            {
                NSBundle *applianceBundle = [NSBundle bundleWithPath:[frapPath stringByAppendingPathComponent:filePath]];
                NSString *n = [[applianceBundle localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
                if(n)
                {
                    result= [SMFMenuItem menuItem];
                    [result setTitle:n];
                    [_items addObject: result];
                    [_options addObject: [frapPath stringByAppendingPathComponent:filePath]];
                }
            }
            
        }
        [[self list] addDividerAtIndex:[_items count] withLabel:@"Settings"];
        
        result=[SMFMenuItem menuItem];
        [result setDimmed:YES];
        [result setTitle:@"Overflow Settings"];
        [_items addObject:result];
        _optionsCount++;
        
        result=[SMFMenuItem menuItem];
        [result setTitle:@"Restart Lowtide"];
        [_items addObject:result];
        _optionsCount++;
        
        result=[SMFMenuItem menuItem];
        [result setTitle:@"Fix Old Overflow"];
        [_items addObject:result];
        _optionsCount++;
        
        
    }
    return self;
}
- (void)itemSelected:(long)selected
{
    if (selected<[_options count]) {
        NSMutableArray *h = [_hidden mutableCopy];
        if ([h containsObject:[[_options objectAtIndex:selected] lastPathComponent]]) 
        {
            [h removeObject:[[_options objectAtIndex:selected] lastPathComponent]];
        }
        else {
            [h addObject:[[_options objectAtIndex:selected] lastPathComponent]];
        }
        [PREFS setObject:h forKey:kHiddenArray];
        [_hidden release];
        _hidden=[[PREFS objectForKey:kHiddenArray] retain];
        [[self list]reload];
        [(BRMainMenuController *)[[[BRApplicationStackManager singleton]stack] rootController] reloadMainMenu];
    }
    else if(selected<([_options count]+_optionsCount))
    {
        selected-=[_options count];
        if (selected==1) {
            [[BRApplication sharedApplication]terminate];
        }
        if (selected==2) 
        {
            int r=0;
            for (NSString *path in _options) 
            {
                NSString *lp = @"/usr/bin/OverflowHelper";
                NSArray *args = [NSArray arrayWithObjects:@"--show",path,nil];
                NSString *call = [NSString stringWithFormat:@"%@ %@",lp,[args componentsJoinedByString:@" "],nil];
                r+= system([call UTF8String]);
                
            }
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
@end
