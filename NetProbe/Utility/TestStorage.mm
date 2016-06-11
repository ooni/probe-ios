//
//  TestStorage.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 11/06/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "TestStorage.h"
#define MAX_SIZE 2

@implementation TestStorage

+ (NetworkMeasurement*)get_test{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]){
        //return [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    }
    return nil;
}

+ (void)set_test:(NetworkMeasurement*)test{
    //[[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:test] forKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)get_works{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"works"]){
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"works"]];
    }
    return nil;
}

+ (void)set_works:(NSArray*)works{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:works] forKey:@"works"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)get_push_token{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"]){
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"push_token"];
    }
    return nil;
}

+ (void)set_push_token:(NSString*)push_token{
    [[NSUserDefaults standardUserDefaults] setObject:push_token forKey:@"push_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)get_session{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"session"]){
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
        //return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"session"]];
    }
    return nil;
}

+ (void)set_session:(NSString*)session{
    [[NSUserDefaults standardUserDefaults] setObject:session forKey:@"session"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:session] forKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)checkMessagesDict{
    if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:@"messages"]){
        NSMutableDictionary *cache = [[NSMutableDictionary alloc] init];
        //[cache setObject:[NSNumber numberWithInteger:0] forKey:@"unread"];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"messages"];
    }
}

+ (NSString*)get_last_message_id:(NSString*)work_id{
    [self checkMessagesDict];
    NSDictionary *cache = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"messages"];
    //if ([[cache allKeys] containsObject:work_id]){
    if (cache[work_id]){
        NSArray *messages = [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectForKey:work_id]];
        return [NSString stringWithFormat:@"%@", [[messages lastObject] objectForKey:@"id"]];
    }
    return nil;
}

+ (NSArray*)get_messages:(NSString*)work_id{
    [self checkMessagesDict];
    NSDictionary *cache = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"messages"];
    if ([[cache allKeys]containsObject:work_id]){
        return [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectForKey:work_id]];
    }
    return nil;
}

+ (void)set_messages:(NSArray*)messages forJob:(NSString*)work_id{
    [self checkMessagesDict];
    NSMutableDictionary *cache = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"messages"] mutableCopy];
    if ([[cache allKeys] containsObject:work_id]){
        NSMutableArray *current = [[NSKeyedUnarchiver unarchiveObjectWithData:[cache objectForKey:work_id]] mutableCopy];
        [current addObjectsFromArray:messages];
        [cache setObject:[NSKeyedArchiver archivedDataWithRootObject:current] forKey:work_id];
    }
    else {
        [cache setObject:[NSKeyedArchiver archivedDataWithRootObject:messages] forKey:work_id];
    }
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"messages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)get_unread_messages{
    NSInteger unread = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"works"]){
        NSArray *works =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"works"]];
        for (NSDictionary * current in works)
            if([current objectForKey:@"unread_messages"] && [current objectForKey:@"unread_messages"] != [NSNull null])
                unread += [[current objectForKey:@"unread_messages"] integerValue];
    }
    return unread;
}

+ (NSInteger)get_unread_messages:(NSString*)work_id{
    NSInteger unread = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"works"]){
        NSArray *works =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"works"]];
        for (NSDictionary * current in works)
            if([current objectForKey:@"unread_messages"] && [current objectForKey:@"unread_messages"] != [NSNull null])
                if ([[current objectForKey:@"work_id"] isEqualToString:work_id]) unread += [[current objectForKey:@"unread_messages"] integerValue];
    }
    return unread;
}

+ (void)reset_unread_messages:(NSString*)work_id{
    NSArray *cache =  [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"works"]];
    NSMutableArray *works = [cache mutableCopy];
    for (int i = 0; i < [works count]; i++){
        if ([[[works objectAtIndex:i] objectForKey:@"work_id"] isEqualToString:work_id] && [[works objectAtIndex:i] objectForKey:@"unread_messages"] && [[works objectAtIndex:i] objectForKey:@"unread_messages"] != [NSNull null]){
            NSMutableDictionary *d = [[works objectAtIndex:i] mutableCopy];
            [d setObject:[NSNumber numberWithInteger:0] forKey:@"unread_messages"];
            [works setObject:d atIndexedSubscript:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:works] forKey:@"works"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) cleanAll{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"instagram_data"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"works"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"messages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


 +(float) getCacheSize{
     NSData * data = [NSPropertyListSerialization dataFromPropertyList:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cache"] format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
     float kbytes=[data length]/1024.0;
     NSLog(@"size of yourdictionary: %f", kbytes);
     return kbytes;
 }


@end
