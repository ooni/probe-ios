#import <Foundation/Foundation.h>

@interface Options : NSObject
@property (nonatomic, strong) NSNumber *max_runtime;
@property (nonatomic, strong) NSNumber *no_collector;
@property (nonatomic, strong) NSNumber *save_real_probe_asn;
@property (nonatomic, strong) NSNumber *save_real_probe_cc;
@property (nonatomic, strong) NSNumber *save_real_probe_ip;
@property (nonatomic, strong) NSString *software_name;
@property (nonatomic, strong) NSString *software_version;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSNumber *port;
@property (nonatomic, strong) NSNumber *all_endpoints;
@property (nonatomic, strong) NSNumber *randomize_input;
@property (nonatomic, strong) NSNumber *no_file_report;
@end
