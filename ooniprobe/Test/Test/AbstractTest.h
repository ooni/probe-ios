#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "Measurement.h"
#import "Result.h"
#import "Url.h"
#import "TestUtility.h"
#import "JsonResult.h"
#import "Settings.h"

@class AbstractTest;

@protocol MKNetworkTestDelegate <NSObject>
-(void)testEnded:(AbstractTest*)test;
@end

@interface AbstractTest : NSObject

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property NSString *reportId;
@property Result *result;
@property (nonatomic, strong) NSMutableDictionary *measurements;
@property id<MKNetworkTestDelegate> delegate;
@property Settings *settings;
@property BOOL annotation;
-(id)initTest:(NSString*)testName;
-(Measurement*)createMeasurementObject;
-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement;
-(void)prepareRun;
-(void)runTest;
-(int)getRuntime;
-(void)testEnded;
@end
