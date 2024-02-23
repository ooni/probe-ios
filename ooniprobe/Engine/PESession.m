#import "PESession.h"
#import "ObjectMapper.h"
#import "ObjectMappingInfo.h"
#import "InCodeMappingProvider.h"
#import "DescriptorResponse.h"

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

- (DescriptorResponse *)ooniRunFetch:(OONIContext *)ctx id:(long)runId error:(NSError **)error {
    NSString *response = [self.session ooniRunFetch:ctx.ctx ID:runId error:error];

    // TODOD (aanorbel) : Fix error handling
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];

    InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    mapper.mappingProvider = mappingProvider;

    [mappingProvider mapFromDictionaryKey:@"descriptor"
                            toPropertyKey:@"descriptor"
                                 forClass:DescriptorResponse.class
                          withTransformer:^id(id currentNode, id parentNode) {
                              Descriptor *descriptor = [mapper objectFromSource:currentNode toInstanceOfClass:Descriptor.class];
                              descriptor.i_description = currentNode[@"description"];
                              descriptor.name_intl = currentNode[@"name_intl"];
                              descriptor.description_intl = currentNode[@"description_intl"];
                              descriptor.short_description_intl = currentNode[@"short_description_intl"];
                              return descriptor;
                          }];
    return [mapper objectFromSource:dictionary toInstanceOfClass:DescriptorResponse.class];
}

- (OONICheckInResults *)checkIn:(OONIContext *)ctx config:(OONICheckInConfig *)config error:(NSError **)error {
    OonimkallCheckInInfo *r = [self.session checkIn:ctx.ctx config:[config toOonimkallCheckInConfig] error:error];
    return (r != nil) ? ([[OONICheckInResults alloc] initWithResults:r]) : nil;
}

@end
