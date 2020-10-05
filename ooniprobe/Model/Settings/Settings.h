#import <Foundation/Foundation.h>
#import "Options.h"
#import "ObjectMapper.h"
#import "NSObject+ObjectMapper.h"
#import "OONIMKTaskConfig.h"

@interface Settings : NSObject <OONIMKTaskConfig>
@property (nonatomic, strong) NSMutableDictionary *annotations;
@property (nonatomic, strong) NSArray *disabled_events;
@property (nonatomic, strong) NSArray *inputs;
@property (nonatomic, strong) NSString *log_level;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *assets_dir;
@property (nonatomic, strong) NSString *state_dir;
@property (nonatomic, strong) NSString *temp_dir;
@property (nonatomic, strong) Options *options;

@end

