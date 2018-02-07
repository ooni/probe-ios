#import "Result.h"

@implementation Result

-(id) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.Id = [[NSDate date] timeIntervalSince1970];
    self.done = false;
    return self;
}

-(void)save{
    NSLog(@"---- START LOGGING RESULT OBJECT----");
    NSLog(@"Id %ld", self.Id);
    NSLog(@"name %@", self.name);
    NSLog(@"startTime %@", self.startTime);
    NSLog(@"endTime %@", self.endTime);
    NSLog(@"summary %@", self.summary);
    NSLog(@"---- END LOGGING RESULT OBJECT----");

}

@end
