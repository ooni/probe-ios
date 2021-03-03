#import "WebConnectivity.h"
#import "MessageUtility.h"
#import "OONIApi.h"
#import "ExceptionUtility.h"
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
    if (self.inputs == nil || [self.inputs count] == 0){
        //Download urls and then alloc class
        NSError *error;
        PESession* session = [[PESession alloc] initWithConfig:
                              [Engine getDefaultSessionConfigWithSoftwareName:SOFTWARE_NAME
                                                              softwareVersion:[VersionUtility get_software_version]
                                                                       logger:[LoggerArray new]]
                                                                        error:&error];
        if (error != nil) {
            return;
        }
        // Updating resources with no timeout because we don't know for sure how much
        // it will take to download them and choosing a timeout may prevent the operation
        // to ever complete. (Ideally the user should be able to interrupt the process
        // and there should be no timeout here.)
        [session maybeUpdateResources:[session newContext] error:&error];
        if (error != nil) {
            return;
        }
        OONIContext *ooniContext = [session newContextWithTimeout:30];
        OONICheckInConfig *config = [[OONICheckInConfig alloc] initWithSoftwareName:SOFTWARE_NAME
                                                                    softwareVersion:[VersionUtility get_software_version]
                                                                         categories:[SettingsUtility getSitesCategoriesEnabled]];
        OONICheckInResults *results = [session checkIn:ooniContext config:config error:&error];
        if (error != nil) {
            [self onError:error];
            return;
        }
        
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (OONIURLInfo* current in results.webConnectivity.urls){
            //List for database
            Url *url = [Url
                        checkExistingUrl:current.url
                        categoryCode:current.category_code
                        countryCode:current.country_code];
            //List for mk
            if (url != nil)
                [urls addObject:url.url];
        }
        if ([urls count] == 0){
            [self onError:[NSError errorWithDomain:@"io.ooni.orchestrate"
                                              code:ERR_NO_VALID_URLS
                                          userInfo:@{NSLocalizedDescriptionKey:@"Modal.Error.NoValidUrls"
                                                     }]];
            return;
        }
        [self setUrls:urls];
        [self setDefaultMaxRuntime];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRuntime" object:nil];
        [super runTest];
        /*
        [OONIApi downloadUrls:^(NSArray *urls) {
            [self setUrls:urls];
            [self setDefaultMaxRuntime];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRuntime" object:nil];
            [super runTest];
        } onError:^(NSError *error) {
            [ExceptionUtility recordError:@"downloadUrls_error"
                                   reason:@"downloadUrls failed due to an error"
                                 userInfo:[error dictionary]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil];
            [super testEnded];
        }];
         */
    }
    else {
        [self setUrls:self.inputs];
        [super runTest];
    }
}

-(void)onError:(NSError*)error{
    [ExceptionUtility recordError:@"downloadUrls_error"
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
