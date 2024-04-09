#import "PESession.h"
#import "ObjectMapper.h"
#import "ObjectMappingInfo.h"
#import "InCodeMappingProvider.h"
#import "DescriptorResponse.h"
#import <oonimkall/Oonimkall.h>

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

- (OONIRunDescriptor *)ooniRunFetch:(OONIContext *)ctx id:(long)runId error:(NSError **)error {

    
    OonimkallHTTPRequest *httpRequest = [[OonimkallHTTPRequest alloc] init];
    httpRequest.url = [NSString stringWithFormat:@"https://api.dev.ooni.io/api/v2/oonirun/links/%ld", runId];
    httpRequest.method = @"GET";
    
    OonimkallHTTPResponse *httpResponse = [self.session httpDo:ctx.ctx jreq:httpRequest error:error];

    NSString *response = httpResponse.body;

    // TODOD (aanorbel) : Fix error handling
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];

    InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    mapper.mappingProvider = mappingProvider;
    
    [mappingProvider mapFromDictionaryKey:@"description" toPropertyKey:@"i_description" forClass:OONIRunDescriptor.class];

    return [mapper objectFromSource:dictionary toInstanceOfClass:OONIRunDescriptor.class];
}

- (OONICheckInResults *)checkIn:(OONIContext *)ctx config:(OONICheckInConfig *)config error:(NSError **)error {
    OonimkallCheckInInfo *r = [self.session checkIn:ctx.ctx config:[config toOonimkallCheckInConfig] error:error];
    return (r != nil) ? ([[OONICheckInResults alloc] initWithResults:r]) : nil;
}

@end
