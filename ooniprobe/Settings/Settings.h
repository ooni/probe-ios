#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSArray *disabled_events;
@property (nonatomic, strong) NSArray *inputs;
@property (nonatomic, strong) NSString *log_filepath;
@property (nonatomic, strong) NSString *log_level;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *output_filepath;
@property (nonatomic, strong) Options *options;

@end
