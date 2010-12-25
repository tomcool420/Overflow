//
//  OverflowSettings.h
//  Overflow2
//
//  Created by Thomas Cool on 10/20/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Backrow/BRMediaMenuController.h>
#import "../Headers/SMFramework.h"
@class SMFPreferences;


@interface OverflowSettings : BRMediaMenuController {
	int padding[128];
    NSMutableArray *    _items;
    NSMutableArray *    _titles;
    NSMutableArray *    _paths;
    NSMutableArray *    _it;
	NSMutableArray *	_options;
}
-(void)reloadtitles;
+(SMFPreferences *)preferences;
@end
