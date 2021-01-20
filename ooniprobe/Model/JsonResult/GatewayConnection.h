#import <Foundation/Foundation.h>

@interface GatewayConnection : NSObject

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSNumber *port;
@property (nonatomic, strong) NSString *transport_type;

@end
