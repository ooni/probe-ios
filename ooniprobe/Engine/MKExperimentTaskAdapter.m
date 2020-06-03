#import "MKExperimentTaskAdapter.h"

@implementation MKExperimentTaskAdapter

- (id)initWithTask:(MKAsyncTask*)task {
    self = [super init];
    if (self) {
        self.task = task;
    }
    return self;
}

- (BOOL) canInterrupt {
    return false;
}

- (void) interrupt {
    [self.task interrupt];
}

- (BOOL) isDone {
    return self.task.done;
}

- (NSString*) waitForNextEvent {
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.task.waitForNextEvent options:0 error:&err];
    if (err)
        return nil;
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
