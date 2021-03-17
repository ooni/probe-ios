#import "WebConnectivity.h"
#import "MessageUtility.h"
#import "OONIApi.h"
#import "ThirdPartyServices.h"
#import "VersionUtility.h"

@implementation WebConnectivity : AbstractTest

-(id) init {
    self = [super init];
    if (self) {
        self.name = @"web_connectivity";
    }
    return self;
}

-(void) runTest {
    [super prepareRun];
    dispatch_async(self.serialQueue, ^{
        if (self.inputs == nil || [self.inputs count] == 0){
            //Download urls and then alloc class
            [OONIApi downloadUrls:^(NSArray *urls) {
                [self setUrls:urls];
                [self setDefaultMaxRuntime];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRuntime" object:nil];
                [super runTest];
            } onError:^(NSError *error) {
                [ThirdPartyServices recordError:@"downloadUrls_error"
                                       reason:@"downloadUrls failed due to an error"
                                     userInfo:[error dictionary]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil];
                [super testEnded];
            }];
        }
        else {
            [self setUrls:self.inputs];
            [super runTest];
        }
    });
}

-(void)onError:(NSError*)error{
    [ThirdPartyServices recordError:@"downloadUrls_error"
                           reason:@"downloadUrls failed due to an error"
                         userInfo:[error dictionary]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil];
    [super testEnded];
}

-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement{
    /*
     null => failed
     false => not blocked
     string (dns, tcp-ip, http-failure, http-diff) => anomalous
     */
    if (json.test_keys.blocking == NULL)
        [measurement setIs_failed:true];
    else
        measurement.is_anomaly = ![json.test_keys.blocking isEqualToString:@"0"];
    [super onEntry:json obj:measurement];
}

/*
 if the option max_runtime is already set in the option and is not MAX_RUNTIME_DISABLED let's use it
 else if the input are sets we calculate 5 seconds per input
 at last we check if max_runtime is enabled, in  that case we use the value in the settings
 
 first two cases : test is already running and with options and/or URL s
 last two cases : get max_runtime saved in the preference
 */
-(int)getRuntime{
    if (self.settings.options.max_runtime != nil &&
        [self.settings.options.max_runtime intValue] > [MAX_RUNTIME_DISABLED intValue]){
        return 30 + [self.settings.options.max_runtime intValue];
    }
    else if (self.settings.inputs != nil)
        return 30 + (int)[self.settings.inputs count] * 5;
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime_enabled"] boolValue]){
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        return 30 + [max_runtime intValue];
    }
    return [MAX_RUNTIME_DISABLED  intValue];
}

-(void)setUrls:(NSArray*)inputs{
    self.settings.inputs = inputs;
    self.inputs = nil;
}

-(void)setDefaultMaxRuntime {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime_enabled"] boolValue]){
        NSNumber *max_runtime = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        self.settings.options.max_runtime = max_runtime;
    }
    else
        self.settings.options.max_runtime = MAX_RUNTIME_DISABLED;
}

@end
