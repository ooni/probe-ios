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

@property int totalMeasurements;
@property int okMeasurements;
@property int failedMeasurements;
@property int blockedMeasurements;

@property NSMutableDictionary *json;

- (id)initFromJson:(NSString*)json;

- (NSString*)getJsonStr;

//NDT
- (NSString*)getUpload;
- (NSString*)getUploadUnit;
- (NSString*)getUploadWithUnit;
- (NSString*)getDownload;
- (NSString*)getDownloadUnit;
- (NSString*)getDownloadWithUnit;
- (NSString*)getPing;

//DASH
- (NSString*)getVideoQuality:(BOOL)shortened;

//HIRL
- (NSArray*)getSent;
- (NSArray*)getReceived;
@end
