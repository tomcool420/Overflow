//
//  OFlowMenu.h
//  Untitled
//
//  Created by Thomas Cool on 10/21/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMFramework/SMFramework.h>

@interface OFlowMenu : SMFMediaMenuController {
	int padding[64];
    NSMutableArray *    _identifiers;
    id                  principalClass;
}
-(id)initWithBundle:(NSBundle *)bundle;
@end
