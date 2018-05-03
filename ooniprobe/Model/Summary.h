#import <Foundation/Foundation.h>

@interface Summary : NSObject

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

- (NSString*)getServer;
- (NSString*)getPacketLoss;
- (NSString*)getOutOfOrder;
- (NSString*)getAveragePing;
- (NSString*)getMaxPing;
- (NSString*)getMSS;
- (NSString*)getTimeouts;

//DASH
- (NSString*)getVideoQuality:(BOOL)shortened;
- (NSString*)getMedianBitrate;
- (NSString*)getPlayoutDelay;

//HIRL
- (NSArray*)getSent;
- (NSArray*)getReceived;
@end
