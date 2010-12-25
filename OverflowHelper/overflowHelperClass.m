//
//  overflowHelperClass.m
//  overflow
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "overflowHelperClass.h"
//#include <sys/param.h>
//#include <sys/mount.h>
//#include <stdio.h>
//#include <stdlib.h>


@implementation overflowHelperClass
- (id)init
{
	if((self = [super init]) !=nil) {
        _man = [NSFileManager defaultManager];
        wasWritable=NO;
		
	}

	return self;
}
- (int)toggleFrap:(NSString *)path
{
    NSString *fullPath=[path stringByAppendingPathComponent:@"Info.plist"];
	NSMutableDictionary *infoplist=[[NSDictionary dictionaryWithContentsOfFile:fullPath] mutableCopy];
    //NSLog(@"replacing: %@ with %@",[infoplist objectForKey:@"FRAppliancePreferedOrderValue"],value22);
    float final = [[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue];
//    NSLog(@"starting order: %f",final);
    if (final>=0)
        return [self hideFrap:path];
    if (final<0)
        return [self showFrap:path];
    return 0;
}
- (int)hideFrap:(NSString *)path
{
	NSString *fullPath=[path stringByAppendingPathComponent:@"Info.plist"];
	NSMutableDictionary *infoplist=[[NSDictionary dictionaryWithContentsOfFile:fullPath] mutableCopy];
    float final = [[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue];
    if (final>0)
        final=final*-1.;
    if (final==0)
        final=-0.0000000000002665f;
	[infoplist setValue:[NSNumber numberWithFloat:final] forKey:@"FRAppliancePreferedOrderValue"];
    if ([[infoplist allKeys] containsObject:@"FRPrimaryAppliance"]) {
        [infoplist setValue:[NSNumber numberWithBool:FALSE] forKey:@"FRPrimaryAppliance"];
    }
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
	[infoplist writeToFile:fullPath atomically:YES];
    [infoplist release];
    infoplist=nil;
    infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    if ([[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue]>0) {
        return 1;
    }
//    NSLog(@"newDict: %@",infoplist);
//    NSLog(@"Hidden");
    return 0;
}
- (int)showFrap:(NSString *)path
{
	NSString *fullPath=[path stringByAppendingPathComponent:@"Info.plist"];
	NSMutableDictionary *infoplist=[[NSDictionary dictionaryWithContentsOfFile:fullPath] mutableCopy];
    float final = [[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue];
    if (final==-0.0000000000002665f)
        final=0;
    else if (final<0)
        final=final*-1.;
	[infoplist setValue:[NSNumber numberWithFloat:final] forKey:@"FRAppliancePreferedOrderValue"];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
	[infoplist writeToFile:fullPath atomically:YES];
    [infoplist release];
    infoplist=nil;
    infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    if ([[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue]<0) {
        return 1;
    }
    NSLog(@"Shown");
    return 0;
}
//- (int)isWritable
//{
//	struct statfs statBuf; 
//    
//	if ( statfs("/", &statBuf) == -1 ) 
//	{ 
//		NSLog( @"statfs(\"/\"): %d", errno ); 
//		return ( 1 ); 
//	} 
//	
//	// check mount flags -- do we even need to make a modification ? 
//	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
//	{ 
//		NSLog( @"Root filesystem already writable\n\n" );
//		wasWritable = YES;
//		return ( 0 ); 
//	} 
//	return (1);
//}

//- (BOOL)makeSystemWritable 
//{ 
//	//NSLog(@"%@ %s", self, _cmd);
//	struct statfs statBuf; 
//	
//	//if ( pModified != NULL ) 
//    //		*pModified = NO; 
//	
//	if ( statfs("/", &statBuf) == -1 ) 
//	{ 
//		NSLog( @"statfs(\"/\"): %d", errno ); 
//		return ( NO ); 
//	} 
//	
//	// check mount flags -- do we even need to make a modification ? 
//	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
//	{ 
//		NSLog( @"Root filesystem already writable\n\n" );
//		wasWritable = YES;
//		return ( YES ); 
//	} 
//	
//	// once we get here, we'll need to change things... 
//	// I'd love to use the mount syscall directly, but there doesn't 
//	// seem to be any useful information on the HFS argument block that 
//	// would require, grrr 
//	NSArray * args = [NSArray arrayWithObjects: @"-o", @"rw,remount", 
//                      [NSString stringWithUTF8String: statBuf.f_mntfromname], 
//                      [NSString stringWithUTF8String: statBuf.f_mntonname], nil]; 
//	NSTask * task = [NSTask launchedTaskWithLaunchPath: @"/sbin/mount" 
//											 arguments: args]; 
//	
//	[task waitUntilExit]; 
//	int status = [task terminationStatus]; 
//	if ( status != 0 ) 
//	{ 
//		NSLog( @"Remount as writable returned bad status %d (%#x)", status, status ); 
//		//PostNSError( status, NSPOSIXErrorDomain, 
//        //					 LocalizedError(@"BootFSNotMadeWritable", @"Couldn't make the Boot FS writable"), 
//        //					 [NSString stringWithFormat: @"Error = %ld", status] ); 
//		return ( NO ); 
//	} 
//	
//	//if ( pModified != NULL ) 
//    //		*pModified = YES; 
//	
//	return ( YES ); 
//} 
//
//- (void) makeSystemReadOnly
//{ 
//	//NSLog(@"%@ %s", self, _cmd);
//	struct statfs statBuf; 
//	
//	if ( statfs("/", &statBuf) == -1 ) 
//	{ 
//		NSLog( @"statfs() on root failed, not reverting to read-only\n\n" ); 
//		return; 
//	} 
//	
//	if ( (statBuf.f_flags & MNT_RDONLY) != 0 ) 
//	{ 
//		NSLog( @"Root filesystem already read-only\n\n" ); 
//		return; 
//	} 
//	
//	// again, it'd be nice if we could do this through the mount() 
//	// syscall... 
//	NSArray * args = [NSArray arrayWithObjects: @"-o", @"ro,remount,force", 
//                      [NSString stringWithUTF8String: statBuf.f_mntfromname], 
//                      [NSString stringWithUTF8String: statBuf.f_mntonname], nil]; 
//	NSTask * task = [NSTask launchedTaskWithLaunchPath: @"/sbin/mount" 
//											 arguments: args]; 
//	
//	[task waitUntilExit]; 
//	int status = [task terminationStatus]; 
//	if ( status != 0 ) 
//		NSLog( @"Remount read-only returned bad status %d (%#x)\n\n", status, status ); 
//} 

-(void)dealloc
{
    [_man release];
    [super dealloc];
}
@end
