// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "TestStorage.h"

@implementation TestStorage

+ (NSArray*)get_tests{
    [self checkTests];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]){
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]];
    }
    return nil;
}

+ (NSArray*)get_tests_rev{
    [self checkTests];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]){
        NSArray* test_array = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]];
        NSArray* reversedArray = [[test_array reverseObjectEnumerator] allObjects];
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for (NetworkMeasurement *test in reversedArray){
            if (!test.running)
                [returnArray addObject:test];
            //if a test is status running and is not the current running test, probably has failed to complete
            else if (![[[Tests currentTests] getTestWithName:test.name].test_id isEqualToNumber:test.test_id])
                [returnArray addObject:test];
        }
        return returnArray;
    }
    return nil;
}

+ (void)add_test:(NetworkMeasurement*)test{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    [cache addObject:test];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)remove_test:(NSNumber*)test_id{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if ([test.test_id isEqualToNumber:test_id]){
            [self removeFile:test.json_file];
            [self removeFile:test.log_file];
            [cache removeObjectAtIndex:i];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return cache;
        }
    }
    return cache;
}

+ (NSArray*)remove_test_atindex:(long)index{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    if ([cache count] > index) {
        NetworkMeasurement* test = [cache objectAtIndex:index];
        [self removeFile:test.json_file];
        [self removeFile:test.log_file];
        [cache removeObjectAtIndex:index];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cache;
}

+ (void)checkTests{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tests"]){
        NSMutableArray *cache = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NetworkMeasurement*)get_test_atindex:(long)index{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    if ([cache count] > index) {
        NetworkMeasurement* test = [cache objectAtIndex:index];
        return test;
    }
    return nil;
}

+ (void)set_completed:(NSNumber*)test_id {
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if ([test.test_id isEqualToNumber:test_id]){
            test.running = FALSE;
            test.entry = TRUE;
            [cache setObject:test atIndexedSubscript:i];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:TRUE] forKey:@"new_tests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
}

+ (void)set_entry:(NSNumber*)test_id{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if ([test.test_id isEqualToNumber:test_id]){
            test.entry = TRUE;
            [cache setObject:test atIndexedSubscript:i];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
}

+ (void)set_anomaly:(NSNumber*)test_id :(int)anomaly{
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if ([test.test_id isEqualToNumber:test_id]){
            test.anomaly = anomaly;
            [cache setObject:test atIndexedSubscript:i];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
}

+ (void)set_viewed:(NSNumber*)test_id {
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if ([test.test_id isEqualToNumber:test_id]){
            test.viewed = TRUE;
            [cache setObject:test atIndexedSubscript:i];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
}

+ (void)set_all_viewed {
    NSMutableArray *cache = [[self get_tests] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [cache objectAtIndex:i];
        if (!test.viewed && !test.running){
            test.viewed = TRUE;
            [cache setObject:test atIndexedSubscript:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cache] forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)remove_all_tests{
    NSArray *to_remove = [self get_tests_rev];
    for (NetworkMeasurement *test in to_remove){
        [self remove_test:test.test_id];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new_tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeFile:(NSString*)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File %@ deleted", fileName);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

+ (BOOL)new_tests{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"new_tests"]){
        return [[[NSUserDefaults standardUserDefaults] objectForKey:@"new_tests"] boolValue];
    }
    return [[NSNumber numberWithBool:FALSE] boolValue];
}

+(float) getCacheSize{
    NSError *err;
    NSData * data = [NSPropertyListSerialization dataWithPropertyList:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cache"] format:NSPropertyListBinaryFormat_v1_0 options:NULL error:&err];
    float kbytes=[data length]/1024.0;
    NSLog(@"size of yourdictionary: %f", kbytes);
    return kbytes;
}

@end
