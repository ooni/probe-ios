#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <measurement_kit/common.hpp>
#import "TestLists.h"

@interface NetworkMeasurement : NSObject {
    NSString *geoip_asn;
    NSString *geoip_country;
    bool include_ip;
    bool include_asn;
    bool include_cc;
    bool upload_results;
    NSNumber *max_runtime;
    NSString *software_version;
}

@property NSString *name;

@property NSNumber *test_id;
@property float progress;

@property NSString *json_file;
@property NSString *log_file;

//TODO restructure with an object when we will have multiple test list
@property NSArray *inputs;

@property BOOL running;
@property BOOL viewed;
@property BOOL entry;
@property int anomaly;
@property BOOL max_runtime_enabled;

@property mk::Settings options;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

-(void) run;
@end


@interface HTTPInvalidRequestLine : NetworkMeasurement
@end

@interface DNSInjection : NetworkMeasurement
@end

@interface TCPConnect : NetworkMeasurement
@end

@interface WebConnectivity : NetworkMeasurement
@end

@interface NdtTest : NetworkMeasurement
@end

@interface HttpHeaderFieldManipulation : NetworkMeasurement
@end

@interface Dash : NetworkMeasurement
@end

@interface Whatsapp : NetworkMeasurement
@end

@interface Telegram : NetworkMeasurement
@end

@interface FacebookMessenger : NetworkMeasurement
@end
