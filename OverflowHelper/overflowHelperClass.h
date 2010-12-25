//
//  overflowHelperClass.h
//  overflow
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface overflowHelperClass : NSObject {
    NSFileManager *_man;
    BOOL wasWritable;
}
- (int)hideFrap:(NSString *)path;
- (int)showFrap:(NSString *)path;
- (int)toggleFrap:(NSString *)path;
@end
