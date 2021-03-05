#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>
#import "OONIURLInfo.h"

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
