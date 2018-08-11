#import <Foundation/Foundation.h>
#import "JsonResult.h"

@interface Summary : NSObject

//@property (nonatomic, strong) NSNumber *
@property int total;
@property int ok;
@property int failed;
@property int anomalous;

@property NSMutableDictionary *testKeys;
//@property NSMutableDictionary *json;
//@property TestKeys *testKeys;

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
