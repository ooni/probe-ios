#import "PESession.h"

@implementation PESession

- (id)initWithConfig:(OONISessionConfig *)config error:(NSError **)error{
    self = [super init];
    if (self) {
        self.session = OonimkallNewSession([config toOonimkallSessionConfig], error);
    }
    return self;
}

- (OONIGeolocateResults*) geolocate:(OONIContext*) ctx error:(NSError **)error{
    OonimkallGeolocateResults *r = [self.session geolocate:ctx.ctx error:error];
    return (r != nil) ? ([[OONIGeolocateResults alloc] initWithResults:r]) : nil;
}

- (void) maybeUpdateResources:(OONIContext*) ctx error:(NSError **)error{
    [self.session maybeUpdateResources:ctx.ctx error:error];
}

- (OONIContext*) newContext{
    return [self newContextWithTimeout:-1];
}

- (OONIContext*) newContextWithTimeout:(long)timeout{
    return [[OONIContext alloc] initWithContext:
            [self.session newContextWithTimeout:timeout]];

}

- (OONISubmitResults*) submit:(OONIContext*) ctx measurement:(NSString*) measurement error:(NSError **)error{
    OonimkallSubmitMeasurementResults *r = [self.session submit:ctx.ctx measurement:measurement error:error];
    return (r != nil) ? ([[OONISubmitResults alloc] initWithResults:r]) : nil;
}

- (OONICheckInResults*) checkIn:(OONIContext*) ctx config:(OONICheckInConfig*) config error:(NSError **)error {
    OonimkallCheckInInfo *r = [self.session checkIn:ctx.ctx config:[config toOonimkallCheckInConfig] error:error];
    return (r != nil) ? ([[OONICheckInResults alloc] initWithResults:r]) : nil;
}

@end
