#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/** OONICheckInConfig contains configuration for a OONICheckIn. */
@interface OONICheckInConfig : NSObject

/** Charging indicate if the phone is actually charging */
@property (nonatomic) BOOL charging;

/** OnWiFi indicate if the phone is actually connected to a WiFi network */
@property (nonatomic) BOOL onWiFi;

/** Platform of the probe */
@property (nonatomic, strong) NSString*  platform;

/** RunType */
@property (nonatomic, strong) NSString*  runType;

/** softwareName is a mandatory setting specifying the name of
 * the application that is using OONI Probe's engine. */
@property (nonatomic, strong) NSString*  softwareName;

/** softwareVersion is a mandatory setting specifying the version of
 * the application that is using OONI Probe's engine. */
@property (nonatomic, strong) NSString*  softwareVersion;

/** WebConnectivity class contain an array of categories. */
@property (nonatomic, strong) OonimkallCheckInConfigWebConnectivity*  webConnectivity;

- (id) initWithSoftwareName:(NSString*)softwareName
            softwareVersion:(NSString*)softwareVersion
                 categories:(NSArray*)categories
                   charging:(BOOL)charging
                     onWifi:(BOOL)onWifi
                    runType:(NSString*)runType;

- (OonimkallCheckInConfig*) toOonimkallCheckInConfig;

@end
