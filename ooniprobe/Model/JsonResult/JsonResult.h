#import <Foundation/Foundation.h>
#import "ObjectMapper.h"
#import "InCodeMappingProvider.h"
#import "NSObject+ObjectMapper.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"
#import "TestKeys.h"
#import "InCodeMappingProvider.h"

@interface JsonResult : NSObject
@property (nonatomic, strong) NSString *probe_asn;
@property (nonatomic, strong) NSString *probe_cc;
@property (nonatomic, strong) NSDate *test_start_time;
@property (nonatomic, strong) NSDate *measurement_start_time;
@property (nonatomic, strong) NSNumber *test_runtime;
@property (nonatomic, strong) NSString *probe_ip;
@property (nonatomic, strong) NSString *report_id;
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) TestKeys *test_keys;
@end

