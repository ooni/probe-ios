#import <Foundation/Foundation.h>

@interface Advanced : NSObject
@property (nonatomic, strong) NSNumber *packet_loss;
@property (nonatomic, strong) NSNumber *avg_rtt;
@property (nonatomic, strong) NSNumber *max_rtt;
@property (nonatomic, strong) NSNumber *mss;
@end
