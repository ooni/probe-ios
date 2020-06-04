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

- (NSDictionary*) waitForNextEvent {
    return self.task.waitForNextEvent;
}

- (NSError*) hasError{
    return nil;
}

@end
