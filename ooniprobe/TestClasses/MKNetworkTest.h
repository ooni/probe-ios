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
#import "Settings.h"

@class MKNetworkTest;

@protocol MKNetworkTestDelegate <NSObject>
-(void)testEnded:(MKNetworkTest*)test;
@end

@interface MKNetworkTest : NSObject

@property mk::Settings options;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property NSString *name;
@property double progress;
@property int idx;
@property Result *result;
@property Measurement *measurement;
@property id<MKNetworkTestDelegate> delegate;
@property int entryIdx;
@property Settings *settings;

-(void)createMeasurementObject;
-(void)initCommon;
-(void)onEntry:(JsonResult*)jsonResult;
-(void)setResultOfMeasurement:(Result *)result;
-(void)runTest;
@end
