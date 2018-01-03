#import "Result.h"

@implementation Result

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.uniqueId = [[NSDate date] timeIntervalSince1970];
    self.done = false;
    return self;
}

-(void)save{
    NSLog(@"uniqueId %ld", self.uniqueId);
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"json %@", self.json);
}

@end
