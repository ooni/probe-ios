#import <Foundation/Foundation.h>

@interface Summary : NSObject
/*
 Dict Structure
 test_result: {
 total,
 ok,
 failure,
 blocked
 }
 ndt: {
 //copy "simple" array in test_keys
 upload
 download
 ping
 }
 dash: {
 connect_latency
 median_bitrate
 min_playout_delay
 }
 */

@property NSMutableDictionary *json;

- (id)initFromJson:(NSString*)json;
- (NSString*)getJsonStr;

- (NSString*)getUpload;
- (NSString*)getDownload;
- (NSString*)getPing;
- (NSString*)getVideoQuality;
@end
