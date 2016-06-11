//
//  TestStorage.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 11/06/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "TestStorage.h"

@implementation TestStorage

+ (NSArray*)get_tests{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]){
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"tests"];
    }
    return nil;
}

+ (void)add_test:(NetworkMeasurement*)test{
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    [cache addObject:test];
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)remove_test:(int)index{
    //TODO Clean files on disk
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    if ([cache count] > index) [cache removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cache;
}

+ (void)checkTests{
    if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tests"]){
        NSMutableArray *cache = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    }
}

+ (void)remove_all_tests{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(float) getCacheSize{
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cache"] format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    float kbytes=[data length]/1024.0;
    NSLog(@"size of yourdictionary: %f", kbytes);
    return kbytes;
}


@end
