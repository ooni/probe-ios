// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

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
    [cache addObject:[NSKeyedArchiver archivedDataWithRootObject:test]];
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)remove_test:(NSNumber*)test_id{
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectAtIndex:i]];
        if (test.test_id == test_id){
            [self removeFile:test.json_file];
            [self removeFile:test.log_file];
            [cache removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cache;
}

+ (NSArray*)remove_test_atindex:(long)index{
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    if ([cache count] > index) {
        NetworkMeasurement* test = [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectAtIndex:index]];
        [self removeFile:test.json_file];
        [self removeFile:test.log_file];
        [cache removeObjectAtIndex:index];
    }
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return cache;
}

+ (void)checkTests{
    if (![[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"]){
        NSMutableArray *cache = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NetworkMeasurement*)get_test_atindex:(long)index{
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    if ([cache count] > index) {
        NetworkMeasurement* test = [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectAtIndex:index]];
        return test;
    }
    return nil;
}

+ (void)set_completed:(NSNumber*)test_id {
    [self checkTests];
    NSMutableArray *cache = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"tests"] mutableCopy];
    for (int i = 0; i < [cache count]; i++) {
        NetworkMeasurement* test = [NSKeyedUnarchiver unarchiveObjectWithData:[cache objectAtIndex:i]];
        if ([test.test_id isEqualToNumber:test_id]){
            test.completed = TRUE;
            [cache setObject:[NSKeyedArchiver archivedDataWithRootObject:test] atIndexedSubscript:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:@"tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)remove_all_tests{
    //Not used for now
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tests"];
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


+(float) getCacheSize{
    NSData * data = [NSPropertyListSerialization dataFromPropertyList:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cache"] format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    float kbytes=[data length]/1024.0;
    NSLog(@"size of yourdictionary: %f", kbytes);
    return kbytes;
}


@end
