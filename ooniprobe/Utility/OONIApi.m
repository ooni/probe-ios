#import "OONIApi.h"
#import "Engine.h"
#import "SettingsUtility.h"
#import "NetworkSession.h"
#import "Url.h"
#import "VersionUtility.h"

@implementation OONIApi

+ (void)downloadUrls:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb {
    NSError *error;
    NSString *cc = @"XX";

    cc = [Engine resolveProbeCCwithSoftwareName:SOFTWARE_NAME
                                          softwareVersion:[VersionUtility get_software_version]
                                                  timeout:DEFAULT_TIMEOUT
                                                    error:&error];
    if (error != nil) {
        //TODO Do we care about the error?
    }
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"orchestrate.ooni.io";
    components.path = @"/api/v1/test-list/urls";
    NSURLQueryItem *ccItem = [NSURLQueryItem
                              queryItemWithName:@"country_code"
                              value:cc];
    if ([[SettingsUtility getSitesCategoriesDisabled] count] > 0){
        NSMutableArray *categories = [NSMutableArray arrayWithArray:[SettingsUtility getSitesCategories]];
        [categories removeObjectsInArray:[SettingsUtility getSitesCategoriesDisabled]];
        NSURLQueryItem *categoriesItem = [NSURLQueryItem
                                          queryItemWithName:@"category_codes"
                                          value:[categories componentsJoinedByString:@","]];
        components.queryItems = @[ ccItem, categoriesItem ];
    }
    else {
        components.queryItems = @[ ccItem ];
    }
    NSURL *url = components.URL;
    NSURLSessionDataTask *downloadTask = [[NetworkSession getSession]
     dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         [self downloadUrlsCallback:data response:response error:error
                                 onSuccess:successcb onError:errorcb];
    }];
    [downloadTask resume];
}

+ (void)downloadUrlsCallback:(NSData *)data
                    response:(NSURLResponse *)response
                    error:(NSError *)error
                    onSuccess:(void (^)(NSArray*))successcb
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
    NSArray *urlsArray = [dic objectForKey:@"results"];
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (NSDictionary* current in urlsArray){
        //List for database
        Url *url = [Url
                    checkExistingUrl:[current objectForKey:@"url"]
                    categoryCode:[current objectForKey:@"category_code"]
                    countryCode:[current objectForKey:@"country_code"]];
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

+ (void)downloadJson:(NSString*)urlStr onSuccess:(void (^)(NSDictionary*))successcb
    onError:(void (^)(NSError*))errorcb {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSessionDataTask *downloadTask = [[NetworkSession getSession]
                                          dataTaskWithURL:url
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              [self downloadJsonCallback:data response:response error:error
                                                               onSuccess:successcb onError:errorcb];
                                          }];
    [downloadTask resume];
}

+ (void)downloadJsonCallback:(NSData *)data
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

+ (void)getExplorerUrl:(NSString*)report_id
               withUrl:(NSString*)measurement_url
             onSuccess:(void (^)(NSString*))successcb
               onError:(void (^)(NSError*))errorcb {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.ooni.io";
    components.path = @"/api/v1/measurements";
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

+ (void)getExplorerUrlCallback:(NSData *)data
                    response:(NSURLResponse *)response
                       error:(NSError *)error
                   onSuccess:(void (^)(NSString*))successcb
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
    NSArray *resultsArray = [dic objectForKey:@"results"];
    /*
     Checking if the array is longer than 1.
     https://github.com/ooni/probe-ios/pull/293#discussion_r302136014
     */
    if ([resultsArray count] != 1 ||
        ![[resultsArray objectAtIndex:0] objectForKey:@"measurement_url"]) {
        errorcb([NSError errorWithDomain:@"io.ooni.api"
                                    code:ERR_JSON_EMPTY
                                userInfo:@{NSLocalizedDescriptionKey:@"Modal.Error.JsonEmpty"
                                           }]);
        return;
    }
    successcb([[resultsArray objectAtIndex:0] objectForKey:@"measurement_url"]);
}

+ (void)checkReportId:(NSString*)report_id
           onSuccess:(void (^)(BOOL))successcb
             onError:(void (^)(NSError*))errorcb{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"api.ooni.io";
    components.path = @"/api/_/check_report_id";
    NSURLQueryItem *reportIdItem = [NSURLQueryItem
                                    queryItemWithName:@"report_id"
                                    value:report_id];
    components.queryItems = @[ reportIdItem ];
    NSURL *url = components.URL;
    NSURLSessionDataTask *downloadTask = [[NetworkSession getSession]
     dataTaskWithURL:url
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         [self checkReportIdCallback:data response:response error:error
                          onSuccess:successcb onError:errorcb];
     }];
    [downloadTask resume];
}

+ (void)checkReportIdCallback:(NSData *)data
                    response:(NSURLResponse *)response
                       error:(NSError *)error
                   onSuccess:(void (^)(BOOL))successcb
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
    BOOL found = [[dic objectForKey:@"found"] boolValue];
    successcb(found);
}

@end
