#import <Foundation/Foundation.h>

@interface Url : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *categoryCode;

-(id) initWithUrl:(NSString*)url category:(NSString*)categoryCode;
@end
