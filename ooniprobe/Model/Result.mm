#import "Result.h"
#import "Measurement.h"

@implementation Result
@dynamic name, startTime, endTime, summary, dataUsageUp, dataUsageDown, done;

/*
-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.Id = [[NSDate date] timeIntervalSince1970];
    self.done = false;
    return self;
}
 */


+ (NSDictionary *)defaultValuesForEntity {
    return @{@"startTime": [NSDate date], @"done" : [NSNumber numberWithBool:FALSE]};
}

- (SRKResultSet*)measurements {
    return [[[Measurement query] whereWithFormat:@"result = %@", self] fetch];
}

-(void)save{
    [self commit];
    NSLog(@"---- START LOGGING RESULT OBJECT----");
    NSLog(@"%@", self);
    /*
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"summary %@", self.summary);
    NSLog(@"dataUsageDown %ld", self.dataUsageDown);
    NSLog(@"dataUsageUp %ld", self.dataUsageUp);
     */
    NSLog(@"---- END LOGGING RESULT OBJECT----");
}

@end
