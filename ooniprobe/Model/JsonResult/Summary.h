#import <Foundation/Foundation.h>

@interface Summary : NSObject
@property (nonatomic, strong) NSNumber *upload;
@property (nonatomic, strong) NSNumber *download;
@property (nonatomic, strong) NSNumber *ping;
@property (nonatomic, strong) NSNumber *max_rtt;
@property (nonatomic, strong) NSNumber *avg_rtt;
@property (nonatomic, strong) NSNumber *min_rtt;
@property (nonatomic, strong) NSNumber *mss;
@property (nonatomic, strong) NSNumber *retransmit_rate;
@end
