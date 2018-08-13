#import <Foundation/Foundation.h>

@interface Advanced : NSObject
@property (nonatomic, strong) NSString *packet_loss;
@property (nonatomic, strong) NSString *out_of_order;
@property (nonatomic, strong) NSString *avg_rtt;
@property (nonatomic, strong) NSString *max_rtt;
@property (nonatomic, strong) NSString *mss;
@property (nonatomic, strong) NSString *timeouts;
@end
