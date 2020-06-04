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

- (NSDictionary*) waitForNextEvent:(NSError **)error {
    NSData *data = [[self.task waitForNextEvent] dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

@end
