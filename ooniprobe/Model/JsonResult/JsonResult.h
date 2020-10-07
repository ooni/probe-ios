#import <Foundation/Foundation.h>
#import "ObjectMapper.h"
#import "InCodeMappingProvider.h"
#import "NSObject+ObjectMapper.h"
#import "TestKeys.h"
#import "InCodeMappingProvider.h"

@interface JsonResult : NSObject
@property (nonatomic, strong) NSDate *test_start_time;
@property (nonatomic, strong) NSDate *measurement_start_time;
@property (nonatomic, strong) NSNumber *test_runtime;
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) NSString *report_id;
@property (nonatomic, strong) TestKeys *test_keys;
@end

