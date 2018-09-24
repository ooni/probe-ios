#import <Foundation/Foundation.h>
#import "Options.h"
#import "ObjectMapper.h"
#import "NSObject+ObjectMapper.h"

@interface Settings : NSObject
@property (nonatomic, strong) NSDictionary *annotations;
@property (nonatomic, strong) NSArray *disabled_events;
@property (nonatomic, strong) NSArray *inputs;
@property (nonatomic, strong) NSString *log_level;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Options *options;

-(NSString*)getSerializedSettings;
@end
