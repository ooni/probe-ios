#import "Network.h"

@implementation Network
@dynamic network_name, ip, asn, country_code, network_type;

- (Network*)createOrReturn {
    //[self commit];
    //return self;

    //if any params nil crashes
    SRKQuery *query = [[Network query] where:@"network_name = ? AND ip = ? AND asn = ? AND country_code = ? AND network_type = ?" parameters:@[self.network_name, self.ip, self.asn, self.country_code, self.network_type]];
    if ([query count] > 0){
        //[self dealloc];
        SRKResultSet *networks = [query fetch];
        return [networks objectAtIndex:0];
    }
    else {
        /*
        Network *network = [Network new];
        network.network_name = current.network_name;
        network.ip = current.ip;
        network.asn = current.asn;
        network.country_code = current.country_code;
        network.network_type = current.network_type;
         */
        [self commit];
        return self;
    }
}

@end
