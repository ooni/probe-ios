#import "OONIProbeEngineTaskAdapter.h"

@implementation OONIProbeEngineTaskAdapter

- (id)initWithTask:(OonimkallTask*)task {
    self = [super init];
    if (self) {
        self.task = task;
    }
    return self;
}

- (BOOL) canInterrupt {
    return true;
}

- (void) interrupt {
    [self.task interrupt];
}

- (BOOL) isDone {
    return [self.task isDone];
}

- (NSString*) waitForNextEvent {
    return self.task.waitForNextEvent;
}

@end
