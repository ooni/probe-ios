#import <Foundation/Foundation.h>

//DASHSummary and NDT5Summary
@interface Simple : NSObject
@property (nonatomic, strong) NSNumber *upload;
@property (nonatomic, strong) NSNumber *download;
@property (nonatomic, strong) NSNumber *ping;
@property (nonatomic, strong) NSNumber *median_bitrate;
@property (nonatomic, strong) NSNumber *min_playout_delay;
@end
