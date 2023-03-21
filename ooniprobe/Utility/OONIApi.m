#import "OONIApi.h"
#import "Engine.h"
#import "SettingsUtility.h"
#import "NetworkSession.h"
#import "Url.h"
#import "VersionUtility.h"
#import "ReachabilityManager.h"

#define OONI_API_BASE_URL @"api.ooni.io"

@implementation OONIApi

+ (void)checkIn:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb {
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
    OONIContext *ooniContext = [session newContextWithTimeout:30];
    OONICheckInConfig *config = [[OONICheckInConfig alloc] initWithSoftwareName:SOFTWARE_NAME
                                                                softwareVersion:[VersionUtility get_software_version]
                                                                     categories:[SettingsUtility getSitesCategoriesEnabled]];

    config.charging = [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging;
    config.onWiFi = [[ReachabilityManager sharedManager] isWifi];
    OONICheckInResults *result = [session checkIn:ooniContext config:config error:&error];

    if (error != nil) {
        errorcb(error);
        return;
    }
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (OONIURLInfo* current in result.webConnectivity.urls){
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
        errorcb([NSError errorWithDomain:@"io.ooni.orchestrate"
                                    code:ERR_NO_VALID_URLS
                                userInfo:@{NSLocalizedDescriptionKey:@"Modal.Error.NoValidUrls"
                                           }]);
        return;
    }
    successcb(urls);
}

+ (void)getExplorerUrl:(NSString*)baseURl
             report_id:(NSString*)report_id
               withUrl:(NSString*)measurement_url
             onSuccess:(void (^)(NSDictionary*))successcb
               onError:(void (^)(NSError*))errorcb {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = baseURl;
    components.path = @"/api/v1/raw_measurement";
    NSURLQueryItem *reportIdItem = [NSURLQueryItem
                                    queryItemWithName:@"report_id"
                                    value:report_id];
    //web_connectivity is the only test using input for now
    if (measurement_url != nil){
        NSURLQueryItem *urlItem = [NSURLQueryItem
                                   queryItemWithName:@"input"
                                   value:measurement_url];
        components.queryItems = @[ reportIdItem, urlItem ];
    }
    else
        components.queryItems = @[ reportIdItem ];

    NSURL *url = components.URL;
    NSURLSessionDataTask *downloadTask = [[NetworkSession getSession]
     dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         [self getExplorerUrlCallback:data response:response error:error
                          onSuccess:successcb onError:errorcb];
     }];
    [downloadTask resume];
}

+ (void)getExplorerUrl:(NSString*)report_id
               withUrl:(NSString*)measurement_url
             onSuccess:(void (^)(NSDictionary*))successcb
               onError:(void (^)(NSError*))errorcb {
    [self getExplorerUrl:OONI_API_BASE_URL
               report_id:report_id
                 withUrl:measurement_url
               onSuccess:successcb
                 onError:errorcb];
}

+ (void)getExplorerUrlCallback:(NSData *)data
                    response:(NSURLResponse *)response
                       error:(NSError *)error
                   onSuccess:(void (^)(NSDictionary*))successcb
                     onError:(void (^)(NSError*))errorcb {
    if (error != nil) {
        errorcb(error);
        return;
    }

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        errorcb(error);
        return;
    }
    successcb(dic);
}

@end
