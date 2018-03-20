#import <Foundation/Foundation.h>

@interface Url : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *category_code;

-(id) initWithUrl:(NSString*)url category:(NSString*)category_code;
@end
