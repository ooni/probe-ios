// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*Include header from test*/
#include <measurement_kit/ooni.hpp>
#include <measurement_kit/nettests.hpp>

#include <measurement_kit/common.hpp>

@interface NetworkMeasurement : NSObject {
    NSString *geoip_asn;
    NSString *geoip_country;
    NSString *ca_cert;
    bool include_ip;
    bool include_asn;
    bool include_cc;
    bool upload_results;
    NSString *collector_address;
}

@property NSString *name;

@property NSNumber *test_id;
@property float progress;

@property NSString *json_file;
@property NSString *log_file;
@property BOOL completed;
@property mk::Settings options;

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
