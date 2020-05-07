#import <Foundation/Foundation.h>

@interface OONIApi : NSObject

+ (void)downloadUrls:(void (^)(NSArray*))successcb onError:(void (^)(NSError*))errorcb;
+ (void)downloadJson:(NSString*)urlStr onSuccess:(void (^)(NSDictionary*))successcb
             onError:(void (^)(NSError*))errorcb;

@end
