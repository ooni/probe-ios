#import <Foundation/Foundation.h>


@interface TestDescriptor : NSObject

@property NSString *name;
@property NSString *short_description;
@property NSString *full_description;
@property NSString *icon;
@property NSString *dataUsage;
@property NSString *author;
@property BOOL archived;
@property BOOL enabled;


@end