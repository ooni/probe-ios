//
//  NotificationService.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 07/06/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "NotificationService.h"
#include <measurement_kit/ooni.hpp>

@implementation NotificationService

+ (void)registerNotifications:(NSString *)token{
    /*
     "probe_cc": "IT",
     "probe_asn": "AS0",
     "platform": "android",
     "software_name": "ooniprobe-android",
     "software_version": "0.1.1",
     "supported_tests": ["tcp_connect", "web_connectivity"],
     "network_type": "wifi",
     "available_bandwidth": "100",
     "token": "TOKEN_ID"
     */
    
    
    NSLog(@"platform %@", @"iOS");
    NSLog(@"software_name %@", @"ooniprobe-ios");
    NSLog(@"software_version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    
    //a mano o con  [[Tests currentTests].availableNetworkMeasurements];
    NSLog(@"supported_tests %@",[NSArray arrayWithObjects:@"web_connectivity", @"ndt_test", @"http_invalid_request_line", @"http_header_field_manipulation", nil]);
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable)
    {
        //No internet
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"network_type %@", @"WiFi");
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        NSLog(@"network_type %@", @"3G");
    }
    NSLog(@"language %@",[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]);
    //mk::ooni::OrchestratorClient client{};

}

@end
