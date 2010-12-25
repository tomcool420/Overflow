//
//  OFlowMenu.m
//  Untitled
//
//  Created by Thomas Cool on 10/21/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

#import "OFlowMenu.h"


@implementation OFlowMenu

- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return ((long)[_items count]);}

- (id)itemForRow:(long)row					{ 
    if (row>=[_items count])
        return nil;
    return [_items objectAtIndex:row];
}

- (id)titleForRow:(long)row					
{ 
    return [[self itemForRow:row] text];
}



-(id)initWithBundle:(NSBundle *)bundle
{
    if((self = [super init]) != nil)
    {
        [bundle load];
        [[self list] setDatasource:self];
        NSString *name = [[bundle localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
        [self setListTitle:name];
        principalClass=[[[bundle principalClass] alloc] init];
        NSArray * a = [principalClass applianceCategories];
        for (BRApplianceCategory * cat in a) {
            NSString *title = [cat name];
            NSString *iden = [cat identifier];
            SMFMenuItem *item = [SMFMenuItem menuItem];
            [item setTitle:title];
            [_items addObject:item];
            [_options addObject:iden];
        }
        
        
    }
    return self;
}

- (void)itemSelected:(long)selected
{
    if (selected<[_items count]) {
        BRController *ctrl = [principalClass controllerForIdentifier:[_options objectAtIndex:selected] args:nil];
        [[self stack] pushController:ctrl];
        
    }
}
-(void)dealloc
{
    [principalClass release];
    [super dealloc];
}
@end
