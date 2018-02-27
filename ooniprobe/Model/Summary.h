#import <Foundation/Foundation.h>

@interface Summary : NSObject
/*
 Dict Structure
 stats: {
    total,
    ok,
    failed,
    blocked
 }
 ndt: {
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

@property NSInteger totalMeasurements;
@property NSInteger okMeasurements;
@property NSInteger failedMeasurements;
@property NSInteger blockedMeasurements;

@property NSMutableDictionary *json;

- (id)initFromJson:(NSString*)json;
- (NSString*)getJsonStr;
- (NSString*)getUpload;
- (NSString*)getUploadUnit;
- (NSString*)getDownload;
- (NSString*)getDownloadUnit;
- (NSString*)getPing;
- (NSString*)getVideoQuality:(BOOL)shortened;
@end
