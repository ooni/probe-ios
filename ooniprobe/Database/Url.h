#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Url : SRKObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *category_code;
@property (strong, nonatomic) NSString *country_code;

-(Url*)createOrReturn;
-(id)initWithUrl:(NSString*)url category:(NSString*)categoryCode country:(NSString*)countryCode;

@end
