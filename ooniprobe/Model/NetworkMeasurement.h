// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <measurement_kit/common.hpp>

@interface NetworkMeasurement : NSObject {
    NSString *geoip_asn;
    NSString *geoip_country;
    bool include_ip;
    bool include_asn;
    bool include_cc;
    bool upload_results;
    NSString *collector_address;
    NSNumber *max_runtime;
}

@property NSString *name;

@property NSNumber *test_id;
@property float progress;

@property NSString *json_file;
@property NSString *log_file;
@property BOOL running;
@property BOOL viewed;
@property BOOL entry;
@property int anomaly;
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

