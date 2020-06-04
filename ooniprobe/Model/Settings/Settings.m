#import "Settings.h"
#import "ReachabilityManager.h"
#import "SettingsUtility.h"
#import "InCodeMappingProvider.h"

@interface ExperimentSettingsAdapter : NSObject <ExperimentSettings>
- (id)initWithJson:(NSString*)json settings:(Settings*)settings;
@property (nonatomic, strong) Settings* settings;
@property (nonatomic, strong) NSString* serialized;
@property (nonatomic, strong) NSDictionary* dictionary;
@end

@implementation ExperimentSettingsAdapter

- (id)initWithJson:(NSString*)json settings:(Settings*)settings {
    self = [super init];
    if (self) {
        self.serialized = json;
        self.settings = settings;
    }
    return self;
}

- (NSString *)serialization {
    return self.serialized;
}

- (NSString *)taskName {
    return self.settings.name;
}

- (NSDictionary *)dictionary {
    return [self.settings getSettingsDictionary];
}


@end

@implementation Settings

- (id)init {
    self = [super init];
    if (self) {
        BOOL include_asn = [SettingsUtility getSettingWithName:@"include_asn"];
        if (include_asn)
            self.annotations = [[NSMutableDictionary alloc] initWithDictionary:@{@"network_type" : [[ReachabilityManager sharedManager] getStatus]}];
        self.disabled_events = @[@"status.queued", @"status.update.websites", @"failure.report_close"];
        self.log_level = [SettingsUtility getVerbosity];
        self.options = [Options new];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.state_dir = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"state"]];
        self.assets_dir = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"assets"]];
        self.temp_dir = NSTemporaryDirectory();
    }
    return self;
}

-(NSDictionary*)getSettingsDictionary{
    ObjectMapper *mapper = [[ObjectMapper alloc] init];
    return [mapper dictionaryFromObject:self];
}

-(NSString*)getSettingsJson{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[self getSettingsDictionary] options:0 error:&err];
    if (!err)
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return nil;
}

-(id<ExperimentSettings>)toExperimentSettings {
    return [[ExperimentSettingsAdapter alloc] initWithJson:[self getSettingsJson] settings:self];
}

@end
