#import <Foundation/Foundation.h>
#import <BackgroundTasks/BackgroundTasks.h>
static NSString* taskID = @"org.openobservatory.ooniprobe.autotesting";

@interface BackgroundTask : NSObject

+ (void)configure;
+ (void)checkIn;
+ (void)scheduleCheckIn;
+ (void)cancelCheckIn;
@end
