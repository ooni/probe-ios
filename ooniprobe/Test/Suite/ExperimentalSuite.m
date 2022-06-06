#import "ExperimentalSuite.h"

@implementation ExperimentalSuite

-(id) init {
    self = [super init];
    if (self) {
        self.dataUsage = NSLocalizedString(@"TestResults.NotAvailable", nil);
        self.name = @"experimental";
    }
    return self;
}

- (NSArray *)getTestList {
    if ([self.testList count] == 0) {
        if (self.autoRUn) {
            [self.testList addObject:[[Experimental alloc] initWithName:@"torsf"]];
            [self.testList addObject:[[Experimental alloc] initWithName:@"vanilla_tor"]];
        } else {
            [self.testList addObject:[[Experimental alloc] initWithName:@"stunreachability"]];
            [self.testList addObject:[[Experimental alloc] initWithName:@"dnscheck"]];
        }
    }
    return super.getTestList;
}

@end
