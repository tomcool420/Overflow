//
//  overflowHelper.m
//  overflow
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "overflowHelperClass.h"
#include <unistd.h>
#include <sys/types.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	//NSRunLoop *rl = [NSRunLoop currentRunLoop];
	
	//[rl configureAsServer];
    setuid(0);
    setgid(0);
	if (argc < 3){
		printf("Segmentation Fault");
		printf("\n");
        return 2;
    }
		NSString *option = [NSString stringWithUTF8String:argv[1]]; //argument 1
		NSString *value = [NSString stringWithUTF8String:argv[2]]; //argument 2
    int rvalue=0;

    overflowHelperClass *ohc = [[ overflowHelperClass alloc] init]; 
    if ([option isEqualToString:@"--hide"]) {
        rvalue=[ohc hideFrap:value];
    }
    else if ([option isEqualToString:@"--show"])
    {
        rvalue=[ohc showFrap:value];
    }
    else if ([option isEqualToString:@"--toggle"])
    {
        rvalue=[ohc toggleFrap:value];
    }
    [ohc release];
    [pool release];
    return rvalue;
}

