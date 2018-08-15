#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Network : SRKObject

@property (strong, nonatomic) NSString *network_name;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSString *asn;
@property (strong, nonatomic) NSString *country_code;

@end
