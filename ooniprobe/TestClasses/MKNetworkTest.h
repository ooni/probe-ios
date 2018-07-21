#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <measurement_kit/common.hpp>
#include <measurement_kit/ooni.hpp>
#include <measurement_kit/nettests.hpp>
#include <measurement_kit/ndt.hpp>

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

#import "SettingsUtility.h"
#import "Measurement.h"
#import "Result.h"
#import "Url.h"
#import "TestUtility.h"
#import "JsonResult.h"

@class MKNetworkTest;

@protocol MKNetworkTestDelegate <NSObject>
-(void)testEnded:(MKNetworkTest*)test;
@end

@interface MKNetworkTest : NSObject

@property mk::Settings options;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property float progress;
@property int idx;
@property Result *result;
@property Measurement *measurement;
@property NSArray *inputs;
@property BOOL max_runtime_enabled;
@property id<MKNetworkTestDelegate> delegate;
@property int entryIdx;

-(void)createMeasurementObject;
-(void)updateCounter;
-(void)initCommon:(mk::nettests::BaseTest&) test;
-(void)onEntry:(JsonResult*)jsonResult;
-(void)updateSummary;
-(void)setResultOfMeasurement:(Result *)result;
-(void)run;
@end
