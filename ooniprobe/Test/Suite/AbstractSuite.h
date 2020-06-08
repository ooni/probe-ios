#import <Foundation/Foundation.h>
#import "Result.h"
#import "AbstractTest.h"
#import "Tests.h"
#import "SettingsUtility.h"
#import "MessageUtility.h"
#import "Url.h"

@interface AbstractSuite : NSObject <MKNetworkTestDelegate>
@property NSString *name;
@property NSString *dataUsage;
@property Result *result;
@property NSMutableArray *testList;
@property int measurementIdx;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

-(id)initSuite:(NSString*)testSuite;
-(void)testEnded:(AbstractTest*)test;
-(void)runTestSuite;
-(NSArray*)getTestList;
-(void)newResult;
-(int)getRuntime;
@end
