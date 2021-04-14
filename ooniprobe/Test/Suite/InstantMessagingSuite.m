#import "InstantMessagingSuite.h"

@implementation InstantMessagingSuite
-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = @"< 1 MB";
        self.name = @"instant_messaging";
    }
    return self;
}


- (NSArray*)getTestList {
    if ([self.testList count] == 0){
        if ([SettingsUtility getSettingWithName:@"test_whatsapp"])
            [self.testList addObject:[[Whatsapp alloc] init]];
        if ([SettingsUtility getSettingWithName:@"test_telegram"])
            [self.testList addObject:[[Telegram alloc] init]];
        if ([SettingsUtility getSettingWithName:@"test_facebook_messenger"])
            [self.testList addObject:[[FacebookMessenger alloc] init]];
        if ([SettingsUtility getSettingWithName:@"test_signal"])
            [self.testList addObject:[[Signal alloc] init]];
    }
    return super.getTestList;
}

@end
