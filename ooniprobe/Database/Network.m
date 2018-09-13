#import "Network.h"
#import "Result.h"

@implementation Network
@dynamic network_name, ip, asn, country_code, network_type;

+ (Network*)checkExistingAsn:(NSString*)asn name:(NSString*)network_name ip:(NSString*)ip cc:(NSString*)country_code type:(NSString*)network_type {
    SRKQuery *query = [[Network query] where:@"network_name = ? AND asn = ? AND ip = ? AND country_code = ? AND network_type = ?" parameters:@[network_name, asn, ip, country_code, network_type]];
    if ([query count] > 0){
        //[self dealloc];
        SRKResultSet *networks = [query fetch];
        return [networks objectAtIndex:0];
    }
    else {
        Network *network = [Network new];
        network.network_name = network_name;
        network.ip = ip;
        network.asn = asn;
        network.country_code = country_code;
        network.network_type = network_type;
        [network commit];
        return network;
    }
}

- (BOOL)entityWillDelete {
    SRKQuery *query = [[[Result query] where:@"network_id = ?" parameters:@[self]] orderByDescending:@"Id"];
    if ([query count] > 1){
        return NO;
    }
    return YES;
}

@end
