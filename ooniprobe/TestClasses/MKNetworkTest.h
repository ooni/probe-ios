#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "Measurement.h"
#import "Result.h"
#import "Url.h"
#import "TestUtility.h"
#import "JsonResult.h"
#import "Settings.h"

@class MKNetworkTest;

@protocol MKNetworkTestDelegate <NSObject>
-(void)testEnded:(MKNetworkTest*)test;
@end

@interface MKNetworkTest : NSObject

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property NSString *reportId;
@property Result *result;
@property (nonatomic, strong) NSMutableDictionary *measurements;
@property id<MKNetworkTestDelegate> delegate;
@property Settings *settings;

-(Measurement*)createMeasurementObject;
-(void)onEntry:(JsonResult*)json obj:(Measurement*)measurement;
-(void)runTest;
-(int)getRuntime;
@end
