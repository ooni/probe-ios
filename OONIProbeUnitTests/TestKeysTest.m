//
//  TestKeysTest.m
//  
//
//  Created by Lorenzo Primiterra on 04/03/2019.
//

#import <XCTest/XCTest.h>
#import "TestKeys.h"
#define BLANK @""

@interface TestKeysTest : XCTestCase

@end

@implementation TestKeysTest
TestKeys *testKeys;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testKeys = [TestKeys new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)whatsappEndpointStatus {
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]);
    testKeys.whatsapp_endpoints_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Failed", nil)]);
    testKeys.whatsapp_endpoints_status = BLANK;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Okay", nil)]);
}

- (void)whatsappWebStatus {
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.whatsapp_web_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_WhatsApp_WebApp_Label_Failed", nil)]);
    testKeys.whatsapp_web_status = BLANK;
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_WhatsApp_WebApp_Label_Okay", nil)]);
}

- (void)whatsappRegistrationStatus {
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.registration_server_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_WhatsApp_Registrations_Label_Failed", nil)]);
    testKeys.registration_server_status = BLANK;
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_WhatsApp_Registrations_Label_Okay", nil)]);
}

- (void)telegramEndpointStatus {
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:true];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:true];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:false];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:false];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Okay", nil)]);
}

- (void)telegramWebStatus {
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.telegram_web_status = BLOCKED;
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_WebApp_Label_Failed", nil)]);
    testKeys.telegram_web_status = BLANK;
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_Telegram_WebApp_Label_Okay", nil)]);
}

- (void)facebookMessengerDns {
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.facebook_dns_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_FacebookMessenger_DNS_Label_Failed", nil)]);
    testKeys.facebook_dns_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_FacebookMessenger_DNS_Label_Okay", nil)]);
}

- (void)facebookMessengerTcp {
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.facebook_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_FacebookMessenger_TCP_Label_Failed", nil)]);
    testKeys.facebook_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NSLocalizedString(@"R.string.TestResults_Details_InstantMessaging_FacebookMessenger_TCP_Label_Okay", nil)]);
}
/*
- (void)upload {
    XCTAssert([[testKeys getUpload] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getUpload] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.upload = 0;
    XCTAssert([[testKeys getUpload] isEqualToString:@"0.00"]);
    testKeys.simple.upload = 10d;
    XCTAssert([[testKeys getUpload] isEqualToString:NSLocalizedString(@""10.0"", nil)]);
}

- (void)uploadUnit {
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.upload = 0d;
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Kbps", nil)]);
    testKeys.simple.upload = 1000d;
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Mbps", nil)]);
    testKeys.simple.upload = 1000d * 1000d;
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Gbps", nil)]);
}

- (void)download {
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.download = 0d;
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
    testKeys.simple.download = 10d;
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@""10.0"", nil)]);
}

- (void)downloadUnit {
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.download = 0d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Kbps", nil)]);
    testKeys.simple.download = 1000d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Mbps", nil)]);
    testKeys.simple.download = 1000d * 1000d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Gbps", nil)]);
}

- (void)ping {
    XCTAssert([[testKeys getPing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getPing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.ping = 0d;
    XCTAssert([[testKeys getPing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)server {
    XCTAssert([[testKeys getServer] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.server_name = BLANK;
    testKeys.server_country = null;
    XCTAssert([[testKeys getServer] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.server_name = null;
    testKeys.server_country = BLANK;
    XCTAssert([[testKeys getServer] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.server_name = BLANK;
    testKeys.server_country = BLANK;
    XCTAssert([[testKeys getServer] isEqualToString:NSLocalizedString(@"BLANK + " - " + BLANK", nil)]);
}

- (void)packetLoss {
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.packet_loss = 0d;
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@""0.000"", nil)]);
    testKeys.advanced.packet_loss = 1d;
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@""100.000"", nil)]);
}

- (void)outOfOrder {
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.out_of_order = 0d;
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
    testKeys.advanced.out_of_order = 1d;
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@""100.0"", nil)]);
}

- (void)averagePing {
    XCTAssert([[testKeys getAveragePing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getAveragePing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.avg_rtt = 0d;
    XCTAssert([[testKeys getAveragePing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)maxPing {
    XCTAssert([[testKeys getMaxPing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getMaxPing] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.max_rtt = 0d;
    XCTAssert([[testKeys getMaxPing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)mss {
    XCTAssert([[testKeys getMSS] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getMSS] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.mss = 0d;
    XCTAssert([[testKeys getMSS] isEqualToString:NSLocalizedString(@""0"", nil)]);
}

- (void)timeouts {
    XCTAssert([[testKeys getTimeouts] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getTimeouts] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.advanced.timeouts = 0d;
    XCTAssert([[testKeys getTimeouts] isEqualToString:NSLocalizedString(@""0"", nil)]);
}

- (void)medianBitrate {
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
    testKeys.simple.median_bitrate = 10d;
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@""10.0"", nil)]);
}

- (void)medianBitrateUnit {
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Kbps", nil)]);
    testKeys.simple.median_bitrate = 1000d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Mbps", nil)]);
    testKeys.simple.median_bitrate = 1000d * 1000d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"R.string.TestResults_Gbps", nil)]);
}

- (void)videoQuality {
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NSLocalizedString(@"R.string.r240p", nil)]);
}

- (void)playoutDelay {
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NSLocalizedString(@"R.string.TestResults_NotAvailable", nil)]);
    testKeys.simple.min_playout_delay = 0d;
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
}
*/
@end
