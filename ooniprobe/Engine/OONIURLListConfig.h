#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/** URLListConfig contains configuration for fetching the URL list. */
@interface OONIURLListConfig : NSObject

/** Categories to query for (empty means all) */
@property (nonatomic, strong) NSArray *categories;

/** CountryCode is the optional country code */
@property (nonatomic, strong) NSString *countryCode;

/** Max number of URLs (<= 0 means no limit) */
@property (nonatomic) long limit;

- (OonimkallURLListConfig*) toOonimkallURLListConfig;

@end
