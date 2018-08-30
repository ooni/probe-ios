#import <Foundation/Foundation.h>

@interface Options : NSObject
@property (nonatomic, strong) NSString *geoip_asn_path;
@property (nonatomic, strong) NSString *geoip_country_path;
@property (nonatomic, strong) NSNumber *max_runtime;
@property (nonatomic) int no_collector;
@property (nonatomic) int save_real_probe_asn;
@property (nonatomic) int save_real_probe_cc;
@property (nonatomic) int save_real_probe_ip;
@property (nonatomic, strong) NSString *software_name;
@property (nonatomic, strong) NSString *software_version;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSNumber *port;
@property (nonatomic) int all_endpoints;
@end
