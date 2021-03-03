#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

@interface OONIURLInfo : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *category_code;
@property (nonatomic, strong) NSString *country_code;

- (id) initWithURLInfo:(OonimkallURLInfo*)urlInfo;

@end

@interface OONICheckInInfoWebConnectivity : NSObject

- (id) initWithURLInfo:(OonimkallCheckInInfoWebConnectivity*)r;

@property (nonatomic, strong) NSString *reportID;
@property (nonatomic, strong) NSMutableArray *urls;

@end

/** CheckInInfo contains the return test objects from the checkin API. */
@interface OONICheckInResults : NSObject

- (id) initWithResults:(OonimkallCheckInInfo*)r;

@property (nonatomic, strong) OONICheckInInfoWebConnectivity* webConnectivity;

@end
