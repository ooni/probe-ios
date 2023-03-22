#import <Foundation/Foundation.h>

@interface OONIApi : NSObject

+(void)checkIn :(NSString*)runType onSuccess: (void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb;

+(void)getExplorerUrl:(NSString*)report_id withUrl:(NSString*)measurement_url
            onSuccess:(void (^)(NSDictionary*))successcb onError:(void (^)(NSError*))errorcb;

+(void)getExplorerUrl:(NSString*)baseURl
            report_id:(NSString*)report_id
              withUrl:(NSString*)measurement_url
            onSuccess:(void (^)(NSDictionary*))successcb
              onError:(void (^)(NSError*))errorcb;

@end
