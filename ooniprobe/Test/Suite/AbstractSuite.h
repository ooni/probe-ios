#import <Foundation/Foundation.h>
#import "Result.h"
#import "AbstractTest.h"
#import "Tests.h"
#import "SettingsUtility.h"
#import "MessageUtility.h"
#import "Url.h"

@interface AbstractSuite : NSObject <MKNetworkTestDelegate>
@property Result *result;
@property NSMutableArray *testList;
@property int measurementIdx;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
-(void)initResult:(Result*)result;
-(void)addTest:(NSString*)testName;
-(void)testEnded:(AbstractTest*)test;
-(void)runTestSuite;
-(int)getRuntime;
@end
