#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Url : SRKObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *category_code;
@property (strong, nonatomic) NSString *country_code;

- (id)initWithUrl:(NSString*)url category:(NSString*)categoryCode country:(NSString*)countryCode;
- (id)initWithUrl:(NSString*)url;
+ (Url*)getUrl:(NSString*)url;
+ (Url*)checkExistingUrl:(NSString*)input categoryCode:(NSString*)categoryCode countryCode:(NSString*)countryCode;
+ (Url*)checkExistingUrl:(NSString*)input;

@end
