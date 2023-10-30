#import "OONIRunSuite.h"
#import "Suite.h"

@implementation OONIRunSuite
- (id)initWithDescriptor:(TestDescriptor *)descriptor {
    self = [super init];
    if (self) {
        self.dataUsage = @"~ 8 MB";
        self.name = @"ooni-run";
        self.descriptor = descriptor;
    }
    return self;
}

- (void)newResult {
    [super newResult];
    self.result.descriptor_id = self.descriptor;
}


- (NSArray *)getTestList {
    if ([self.testList count] == 0) {

        for (NSDictionary *nettest in self.descriptor.nettests) {
            NSString *testName = nettest[@"test_name"];
            // WebConnectivity
            if ([testName isEqualToString:@"web_connectivity"]) {
                WebConnectivity *test = [[WebConnectivity alloc] init];
                test.inputs = nettest[@"inputs"];
                [self.testList addObject:test];
            }

            // Instant Messaging
            // Whatsapp
            else if ([testName isEqualToString:@"whatsapp"]) {
                [self.testList addObject:[[Whatsapp alloc] init]];
            }
            // Telegram
            else if ([testName isEqualToString:@"telegram"]) {
                [self.testList addObject:[[Telegram alloc] init]];
            }
            // FacebookMessenger
            else if ([testName isEqualToString:@"facebook_messenger"]) {
                [self.testList addObject:[[FacebookMessenger alloc] init]];
            }
            // Signal
            else if ([testName isEqualToString:@"signal"]) {
                [self.testList addObject:[[Signal alloc] init]];
            }

            // Circumvention
            // Psiphon
            else if ([testName isEqualToString:@"psiphon"]) {
                [self.testList addObject:[[Psiphon alloc] init]];
            }
            // Tor
            else if ([testName isEqualToString:@"tor"]) {
                [self.testList addObject:[[Tor alloc] init]];
            }
            // RiseupVPN
            else if ([testName isEqualToString:@"riseupvpn"]) {
                [self.testList addObject:[[RiseupVPN alloc] init]];
            }

            // Performance
            // Ndt
            else if ([testName isEqualToString:@"ndt"]) {
                [self.testList addObject:[[NdtTest alloc] init]];
            }
            // Dash
            else if ([testName isEqualToString:@"dash"]) {
                [self.testList addObject:[[Dash alloc] init]];
            }
            // HttpInvalidRequestLine
            else if ([testName isEqualToString:@"http_invalid_request_line"]) {
                [self.testList addObject:[[HttpInvalidRequestLine alloc] init]];
            }
            // HttpHeaderFieldManipulation
            else if ([testName isEqualToString:@"http_header_field_manipulation"]) {
                [self.testList addObject:[[HttpHeaderFieldManipulation alloc] init]];
            }

            // Experimental
            // torsf
            else if ([testName isEqualToString:@"torsf"]) {
                [self.testList addObject:[[Experimental alloc] initWithName:@"torsf"]];
            }
            // vanilla_tor
            else if ([testName isEqualToString:@"vanilla_tor"]) {
                [self.testList addObject:[[Experimental alloc] initWithName:@"vanilla_tor"]];
            }
            // stunreachability
            else if ([testName isEqualToString:@"stunreachability"]) {
                [self.testList addObject:[[Experimental alloc] initWithName:@"stunreachability"]];
            }
            // dnscheck
            else if ([testName isEqualToString:@"dnscheck"]) {
                [self.testList addObject:[[Experimental alloc] initWithName:@"dnscheck"]];
            }
        }
    }
    return super.getTestList;
}



@end
