#import "OONIApi.h"
#import <mkall/MKGeoIPLookup.h>
#import "SettingsUtility.h"
#import "NetworkSession.h"
#import "Url.h"

@implementation OONIApi

+ (void)downloadUrls:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb {
    MKGeoIPLookupTask *task = [[MKGeoIPLookupTask alloc] init];
    [task setTimeout:DEFAULT_TIMEOUT];
    MKGeoIPLookupResults *results = [task perform];
    NSString *cc = @"XX";
    if ([results good])
        cc = [results probeCC];
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

@end
