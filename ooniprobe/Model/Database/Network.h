#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Network : SRKObject

@property (strong, nonatomic) NSString *network_name;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *asn;
@property (strong, nonatomic) NSString *country_code;
@property (strong, nonatomic) NSString *network_type;

+ (Network*)checkExistingNetworkWithAsn:(NSString*)asn networkName:(NSString*)network_name ip:(NSString*)ip cc:(NSString*)country_code networkType:(NSString*)network_type;
- (NSString*)getAsn;
- (NSString*)getNetworkName;
- (NSString*)getNetworkNameOrAsn;
- (NSString*)getCountry;
@end
