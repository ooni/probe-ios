#import "OldTestStorage.h"

@implementation OldTestStorage

/*
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

-(void)removeAllFiles{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // create directory named "test"
    [[NSFileManager defaultManager] createDirectoryAtPath:[documentDirPath stringByAppendingPathComponent:@"json"] withIntermediateDirectories:YES attributes:nil error:nil];
    // retrieved all directories
    NSLog(@"%@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirPath error:nil]);
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirPath error:nil];
    BOOL isDir = NO;
    for (NSString *path in paths) {
        if ([fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
            // path is directory
        }
    }
}
*/

@end
