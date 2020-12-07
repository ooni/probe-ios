#import <Foundation/Foundation.h>

@interface Options : NSObject
@property (nonatomic, strong) NSNumber *max_runtime;
@property (nonatomic, strong) NSNumber *no_collector;
@property (nonatomic, strong) NSString *software_name;
@property (nonatomic, strong) NSString *software_version;
@property (nonatomic, strong) NSString *probe_services_base_url;
@end
