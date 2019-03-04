//
//  TestKeysTest.m
//  
//
//  Created by Lorenzo Primiterra on 04/03/2019.
//

#import <XCTest/XCTest.h>
#import "TestKeys.h"
#define BLANK @""
#define NOT_AVAILABLE NSLocalizedString(@"TestResults.NotAvailable", nil)

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

- (void)testWhatsappEndpointStatus {
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NOT_AVAILABLE]);
    testKeys.whatsapp_endpoints_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Failed", nil)]);
    testKeys.whatsapp_endpoints_status = BLANK;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Okay", nil)]);
}

- (void)testWhatsappWebStatus {
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NOT_AVAILABLE]);
    testKeys.whatsapp_web_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Failed", nil)]);
    testKeys.whatsapp_web_status = BLANK;
    XCTAssert([[testKeys getWhatsappWebStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Okay", nil)]);
}

- (void)testWhatsappRegistrationStatus {
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NOT_AVAILABLE]);
    testKeys.registration_server_status = BLOCKED;
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Failed", nil)]);
    testKeys.registration_server_status = BLANK;
    XCTAssert([[testKeys getWhatsappRegistrationStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Okay", nil)]);
}

- (void)testTelegramEndpointStatus {
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NOT_AVAILABLE]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:true];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:true];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:false];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Failed", nil)]);
    testKeys.telegram_http_blocking = [NSNumber numberWithBool:false];
    testKeys.telegram_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getTelegramEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Okay", nil)]);
}

- (void)testTelegramWebStatus {
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NOT_AVAILABLE]);
    testKeys.telegram_web_status = BLOCKED;
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Failed", nil)]);
    testKeys.telegram_web_status = BLANK;
    XCTAssert([[testKeys getTelegramWebStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Okay", nil)]);
}

- (void)testFacebookMessengerDns {
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NOT_AVAILABLE]);
    testKeys.facebook_dns_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.DNS.Label.Failed", nil)]);
    testKeys.facebook_dns_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getFacebookMessengerDns] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.DNS.Label.Okay", nil)]);
}

- (void)testFacebookMessengerTcp {
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NOT_AVAILABLE]);
    testKeys.facebook_tcp_blocking = [NSNumber numberWithBool:true];
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Failed", nil)]);
    testKeys.facebook_tcp_blocking = [NSNumber numberWithBool:false];
    XCTAssert([[testKeys getFacebookMessengerTcp] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Okay", nil)]);
}

- (void)testUpload {
    XCTAssert([[testKeys getUpload] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getUpload] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.upload = [NSNumber numberWithDouble:0];
    XCTAssert([[testKeys getUpload] isEqualToString:@"0.00"]);
    testKeys.simple.upload = [NSNumber numberWithDouble:10];
    XCTAssert([[testKeys getUpload] isEqualToString:@"10.0"]);
}

- (void)testUploadUnit {
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.upload = [NSNumber numberWithDouble:0];
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"TestResults.Kbps", nil)]);
    testKeys.simple.upload = [NSNumber numberWithDouble:1000];
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"TestResults.Mbps", nil)]);
    testKeys.simple.upload = [NSNumber numberWithDouble:1000*1000];
    XCTAssert([[testKeys getUploadUnit] isEqualToString:NSLocalizedString(@"TestResults.Gbps", nil)]);
}
/*
- (void)testDownload {
    XCTAssert([[testKeys getDownload] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getDownload] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.download = 0d;
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
    testKeys.simple.download = 10d;
    XCTAssert([[testKeys getDownload] isEqualToString:NSLocalizedString(@""10.0"", nil)]);
}

- (void)testDownloadUnit {
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.download = 0d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"TestResults.Kbps", nil)]);
    testKeys.simple.download = 1000d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"TestResults.Mbps", nil)]);
    testKeys.simple.download = 1000d * 1000d;
    XCTAssert([[testKeys getDownloadUnit] isEqualToString:NSLocalizedString(@"TestResults.Gbps", nil)]);
}

- (void)testPing {
    XCTAssert([[testKeys getPing] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getPing] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.ping = 0d;
    XCTAssert([[testKeys getPing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)testServer {
    XCTAssert([[testKeys getServer] isEqualToString:NOT_AVAILABLE]);
    testKeys.server_name = BLANK;
    testKeys.server_country = null;
    XCTAssert([[testKeys getServer] isEqualToString:NOT_AVAILABLE]);
    testKeys.server_name = null;
    testKeys.server_country = BLANK;
    XCTAssert([[testKeys getServer] isEqualToString:NOT_AVAILABLE]);
    testKeys.server_name = BLANK;
    testKeys.server_country = BLANK;
    XCTAssert([[testKeys getServer] isEqualToString:NSLocalizedString(@"BLANK + " - " + BLANK", nil)]);
}

- (void)testPacketLoss {
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.packet_loss = 0d;
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@""0.000"", nil)]);
    testKeys.advanced.packet_loss = 1d;
    XCTAssert([[testKeys getPacketLoss] isEqualToString:NSLocalizedString(@""100.000"", nil)]);
}

- (void)testOutOfOrder {
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.out_of_order = 0d;
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
    testKeys.advanced.out_of_order = 1d;
    XCTAssert([[testKeys getOutOfOrder] isEqualToString:NSLocalizedString(@""100.0"", nil)]);
}

- (void)testAveragePing {
    XCTAssert([[testKeys getAveragePing] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getAveragePing] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.avg_rtt = 0d;
    XCTAssert([[testKeys getAveragePing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)testMaxPing {
    XCTAssert([[testKeys getMaxPing] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getMaxPing] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.max_rtt = 0d;
    XCTAssert([[testKeys getMaxPing] isEqualToString:NSLocalizedString(@""0.0"", nil)]);
}

- (void)testMss {
    XCTAssert([[testKeys getMSS] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getMSS] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.mss = 0d;
    XCTAssert([[testKeys getMSS] isEqualToString:NSLocalizedString(@""0"", nil)]);
}

- (void)testTimeouts {
    XCTAssert([[testKeys getTimeouts] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced = [Advanced new];
    XCTAssert([[testKeys getTimeouts] isEqualToString:NOT_AVAILABLE]);
    testKeys.advanced.timeouts = 0d;
    XCTAssert([[testKeys getTimeouts] isEqualToString:NSLocalizedString(@""0"", nil)]);
}

- (void)testMedianBitrate {
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
    testKeys.simple.median_bitrate = 10d;
    XCTAssert([[testKeys getMedianBitrate] isEqualToString:NSLocalizedString(@""10.0"", nil)]);
}

- (void)testMedianBitrateUnit {
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"TestResults.Kbps", nil)]);
    testKeys.simple.median_bitrate = 1000d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"TestResults.Mbps", nil)]);
    testKeys.simple.median_bitrate = 1000d * 1000d;
    XCTAssert([[testKeys getMedianBitrateUnit] isEqualToString:NSLocalizedString(@"TestResults.Gbps", nil)]);
}

- (void)testVideoQuality {
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.median_bitrate = 0d;
    XCTAssert([[testKeys getVideoQuality([NSNumber numberWithBool:false])] isEqualToString:NSLocalizedString(@"r240p", nil)]);
}

- (void)testPlayoutDelay {
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple = [Simple new];
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NOT_AVAILABLE]);
    testKeys.simple.min_playout_delay = 0d;
    XCTAssert([[testKeys getPlayoutDelay] isEqualToString:NSLocalizedString(@""0.00"", nil)]);
}
*/
@end
