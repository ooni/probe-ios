#import "OONIApi.h"
#import "Engine.h"
#import "SettingsUtility.h"
#import "NetworkSession.h"
#import "Url.h"
#import "VersionUtility.h"
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
    // TODO(aanorbel): here we need to configure whether we're running
    // using battery power, whether we're on WiFi, and the runType.
    OONICheckInResults *result = [session checkIn:ooniContext config:config error:&error];
    // TODO(bassosimone, aanorbel): we should not call a callback given
    // that the above call is a synchronous function call.
    [self checkInCallback:result error:error
                            onSuccess:successcb onError:errorcb];
}

+ (void)checkInCallback:(OONICheckInResults *)result
                    error:(NSError *)error
                    onSuccess:(void (^)(NSArray*))successcb
                    onError:(void (^)(NSError*))errorcb {
    if (error != nil) {
        errorcb(error);
        return;
    }
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (OONIURLInfo* current in result.webConnectivity.urls) {
        // TODO(aanorbel): here we should reinstate previous code that
        // we used to run when invoking the URL lists API.
        //
        // See https://github.com/ooni/probe-ios/pull/510/files#diff-778171c3ece2309e94151a02eca6a0c7e42070d7bdaf691618f8806f52baefeeL72
        [urls addObject:current.url];
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
