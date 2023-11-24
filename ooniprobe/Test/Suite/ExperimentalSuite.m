#import "ExperimentalSuite.h"

@implementation ExperimentalSuite

- (id)init {
    self = [super init];
    if (self) {
        self.dataUsage = NSLocalizedString(@"TestResults.NotAvailable", nil);
        self.name = @"experimental";
    }
    return self;
}

- (NSArray *)getTestList {
    if ([self.testList count] == 0) {
        if ([SettingsUtility isExperimentalTestEnabled]) {
            [self.testList addObject:[[Experimental alloc] initWithName:@"stunreachability"]];
            [self.testList addObject:[[Experimental alloc] initWithName:@"dnscheck"]];
            [self.testList addObject:[[Experimental alloc] initWithName:@"riseupvpn"]];
            [self.testList addObject:[[Experimental alloc] initWithName:@"echcheck"]];
            if ([SettingsUtility isLongRunningTestsInForegroundEnabled] || self.autoRun) {
                [self.testList addObject:[[Experimental alloc] initWithName:@"torsf"]];
                [self.testList addObject:[[Experimental alloc] initWithName:@"vanilla_tor"]];
            }
        }
    }
    return super.getTestList;
}

@end
