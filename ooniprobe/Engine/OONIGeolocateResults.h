#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

/** OONIGeolocateResults contains the results of OONIGeolocateTask. */
@interface OONIGeolocateResults : NSObject

/** ASN is the probe ASN. */
@property (nonatomic, strong) NSString* ASN;

/** country is the probe country. */
@property (nonatomic, strong) NSString* country;

/** IP is the probe IP. */
@property (nonatomic, strong) NSString* IP;

/** org is the probe ASN organization. */
@property (nonatomic, strong) NSString* org;

- (id) initWithResults:(OonimkallGeolocateResults*)r;

@end
