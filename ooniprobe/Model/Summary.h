#import <Foundation/Foundation.h>

@interface Summary : NSObject

@property int totalMeasurements;
@property int okMeasurements;
@property int failedMeasurements;
@property int anomalousMeasurements;

@property NSMutableDictionary *json;

- (id)initFromJson:(NSString*)json;

- (NSString*)getJsonStr;

//WEB
- (NSString*)getWebsiteBlocking:(NSString*)input;

//WHATSAPP
- (NSString*)getWhatsappEndpointStatus;
- (NSString*)getWhatsappWebStatus;
- (NSString*)getWhatsappRegistrationStatus;

//TELEGRAM
- (NSString*)getTelegramEndpointStatus;
- (NSString*)getTelegramWebStatus;
- (NSString*)getTelegramBlocking;

//FACEBOOK
- (NSString*)getFacebookMessengerDns;
- (NSString*)getFacebookMessengerTcp;
- (NSString*)getFacebookMessengerBlocking;

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
- (NSString*)getVideoQuality:(BOOL)extended;
- (NSString*)getMedianBitrate;
- (NSString*)getMedianBitrateUnit;
- (NSString*)getPlayoutDelay;

//HIRL
- (NSArray*)getSent;
- (NSArray*)getReceived;
@end
