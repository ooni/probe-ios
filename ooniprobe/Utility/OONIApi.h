#import <Foundation/Foundation.h>

@interface OONIApi : NSObject

+ (void)downloadUrls:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb;
+ (void)downloadUrls:(NSString*)baseUrl
           onSuccess:(void (^)(NSArray*))successcb
             onError:(void (^)(NSError*))errorcb;
+ (void)downloadJson:(NSString*)urlStr onSuccess:(void (^)(NSDictionary*))successcb
             onError:(void (^)(NSError*))errorcb;
+(void)getExplorerUrl:(NSString*)report_id withUrl:(NSString*)measurement_url
            onSuccess:(void (^)(NSString*))successcb onError:(void (^)(NSError*))errorcb;
+ (void)getExplorerUrl:(NSString*)baseURl
             report_id:(NSString*)report_id
               withUrl:(NSString*)measurement_url
             onSuccess:(void (^)(NSString*))successcb
               onError:(void (^)(NSError*))errorcb;
+ (void)checkReportId:(NSString*)baseUrl
            reportId:(NSString*)report_id
           onSuccess:(void (^)(BOOL))successcb
              onError:(void (^)(NSError*))errorcb;
+(void)checkReportId:(NSString*)report_id
            onSuccess:(void (^)(BOOL))successcb onError:(void (^)(NSError*))errorcb;

@end
