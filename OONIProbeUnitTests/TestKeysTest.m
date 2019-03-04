//
//  TestKeysTest.m
//  
//
//  Created by Lorenzo Primiterra on 04/03/2019.
//

#import <XCTest/XCTest.h>
#import "TestKeys.h"
#define BLANK = @"";

@interface TestKeysTest : XCTestCase

@end

@implementation TestKeysTest
TestKeys *testKeys;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testKeys = new TestKeys;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)whatsappEndpointStatus {
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]);
    testKeys.whatsapp_endpoints_status = TestKeys.BLOCKED;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Failed", nil)]);
    testKeys.whatsapp_endpoints_status = BLANK;
    XCTAssert([[testKeys getWhatsappEndpointStatus] isEqualToString:NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Okay", nil)]);
}

- (void)whatsappWebStatus {
    Assert.assertEquals(testKeys.getWhatsappWebStatus, R.string.TestResults_NotAvailable);
    testKeys.whatsapp_web_status = TestKeys.BLOCKED;
    Assert.assertEquals(testKeys.getWhatsappWebStatus, R.string.TestResults_Details_InstantMessaging_WhatsApp_WebApp_Label_Failed);
    testKeys.whatsapp_web_status = BLANK;
    Assert.assertEquals(testKeys.getWhatsappWebStatus, R.string.TestResults_Details_InstantMessaging_WhatsApp_WebApp_Label_Okay);
}

- (void)whatsappRegistrationStatus {
    Assert.assertEquals(testKeys.getWhatsappRegistrationStatus, R.string.TestResults_NotAvailable);
    testKeys.registration_server_status = TestKeys.BLOCKED;
    Assert.assertEquals(testKeys.getWhatsappRegistrationStatus, R.string.TestResults_Details_InstantMessaging_WhatsApp_Registrations_Label_Failed);
    testKeys.registration_server_status = BLANK;
    Assert.assertEquals(testKeys.getWhatsappRegistrationStatus, R.string.TestResults_Details_InstantMessaging_WhatsApp_Registrations_Label_Okay);
}

- (void)telegramEndpointStatus {
    Assert.assertEquals(testKeys.getTelegramEndpointStatus, R.string.TestResults_NotAvailable);
    testKeys.telegram_http_blocking = true;
    testKeys.telegram_tcp_blocking = true;
    Assert.assertEquals(testKeys.getTelegramEndpointStatus, R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed);
    testKeys.telegram_http_blocking = true;
    testKeys.telegram_tcp_blocking = false;
    Assert.assertEquals(testKeys.getTelegramEndpointStatus, R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed);
    testKeys.telegram_http_blocking = false;
    testKeys.telegram_tcp_blocking = true;
    Assert.assertEquals(testKeys.getTelegramEndpointStatus, R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Failed);
    testKeys.telegram_http_blocking = false;
    testKeys.telegram_tcp_blocking = false;
    Assert.assertEquals(testKeys.getTelegramEndpointStatus, R.string.TestResults_Details_InstantMessaging_Telegram_Application_Label_Okay);
}

- (void)telegramWebStatus {
    Assert.assertEquals(testKeys.getTelegramWebStatus, R.string.TestResults_NotAvailable);
    testKeys.telegram_web_status = TestKeys.BLOCKED;
    Assert.assertEquals(testKeys.getTelegramWebStatus, R.string.TestResults_Details_InstantMessaging_Telegram_WebApp_Label_Failed);
    testKeys.telegram_web_status = BLANK;
    Assert.assertEquals(testKeys.getTelegramWebStatus, R.string.TestResults_Details_InstantMessaging_Telegram_WebApp_Label_Okay);
}

- (void)facebookMessengerDns {
    Assert.assertEquals(testKeys.getFacebookMessengerDns, R.string.TestResults_NotAvailable);
    testKeys.facebook_dns_blocking = true;
    Assert.assertEquals(testKeys.getFacebookMessengerDns, R.string.TestResults_Details_InstantMessaging_FacebookMessenger_DNS_Label_Failed);
    testKeys.facebook_dns_blocking = false;
    Assert.assertEquals(testKeys.getFacebookMessengerDns, R.string.TestResults_Details_InstantMessaging_FacebookMessenger_DNS_Label_Okay);
}

- (void)facebookMessengerTcp {
    Assert.assertEquals(testKeys.getFacebookMessengerTcp, R.string.TestResults_NotAvailable);
    testKeys.facebook_tcp_blocking = true;
    Assert.assertEquals(testKeys.getFacebookMessengerTcp, R.string.TestResults_Details_InstantMessaging_FacebookMessenger_TCP_Label_Failed);
    testKeys.facebook_tcp_blocking = false;
    Assert.assertEquals(testKeys.getFacebookMessengerTcp, R.string.TestResults_Details_InstantMessaging_FacebookMessenger_TCP_Label_Okay);
}

- (void)upload {
    Assert.assertEquals(testKeys.getUpload(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getUpload(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple.upload = 0d;
    Assert.assertEquals(testKeys.getUpload(c), "0.00");
    testKeys.simple.upload = 10d;
    Assert.assertEquals(testKeys.getUpload(c), "10.0");
}

- (void)uploadUnit {
    Assert.assertEquals(testKeys.getUploadUnit, R.string.TestResults_NotAvailable);
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getUploadUnit, R.string.TestResults_NotAvailable);
    testKeys.simple.upload = 0d;
    Assert.assertEquals(testKeys.getUploadUnit, R.string.TestResults_Kbps);
    testKeys.simple.upload = 1000d;
    Assert.assertEquals(testKeys.getUploadUnit, R.string.TestResults_Mbps);
    testKeys.simple.upload = 1000d * 1000d;
    Assert.assertEquals(testKeys.getUploadUnit, R.string.TestResults_Gbps);
}

- (void)download {
    Assert.assertEquals(testKeys.getDownload(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getDownload(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple.download = 0d;
    Assert.assertEquals(testKeys.getDownload(c), "0.00");
    testKeys.simple.download = 10d;
    Assert.assertEquals(testKeys.getDownload(c), "10.0");
}

- (void)downloadUnit {
    Assert.assertEquals(testKeys.getDownloadUnit, R.string.TestResults_NotAvailable);
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getDownloadUnit, R.string.TestResults_NotAvailable);
    testKeys.simple.download = 0d;
    Assert.assertEquals(testKeys.getDownloadUnit, R.string.TestResults_Kbps);
    testKeys.simple.download = 1000d;
    Assert.assertEquals(testKeys.getDownloadUnit, R.string.TestResults_Mbps);
    testKeys.simple.download = 1000d * 1000d;
    Assert.assertEquals(testKeys.getDownloadUnit, R.string.TestResults_Gbps);
}

- (void)ping {
    Assert.assertEquals(testKeys.getPing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getPing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple.ping = 0d;
    Assert.assertEquals(testKeys.getPing(c), "0.0");
}

- (void)server {
    Assert.assertEquals(testKeys.getServer(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.server_name = BLANK;
    testKeys.server_country = null;
    Assert.assertEquals(testKeys.getServer(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.server_name = null;
    testKeys.server_country = BLANK;
    Assert.assertEquals(testKeys.getServer(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.server_name = BLANK;
    testKeys.server_country = BLANK;
    Assert.assertEquals(testKeys.getServer(c), BLANK + " - " + BLANK);
}

- (void)packetLoss {
    Assert.assertEquals(testKeys.getPacketLoss(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getPacketLoss(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.packet_loss = 0d;
    Assert.assertEquals(testKeys.getPacketLoss(c), "0.000");
    testKeys.advanced.packet_loss = 1d;
    Assert.assertEquals(testKeys.getPacketLoss(c), "100.000");
}

- (void)outOfOrder {
    Assert.assertEquals(testKeys.getOutOfOrder(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getOutOfOrder(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.out_of_order = 0d;
    Assert.assertEquals(testKeys.getOutOfOrder(c), "0.0");
    testKeys.advanced.out_of_order = 1d;
    Assert.assertEquals(testKeys.getOutOfOrder(c), "100.0");
}

- (void)averagePing {
    Assert.assertEquals(testKeys.getAveragePing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getAveragePing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.avg_rtt = 0d;
    Assert.assertEquals(testKeys.getAveragePing(c), "0.0");
}

- (void)maxPing {
    Assert.assertEquals(testKeys.getMaxPing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getMaxPing(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.max_rtt = 0d;
    Assert.assertEquals(testKeys.getMaxPing(c), "0.0");
}

- (void)mss {
    Assert.assertEquals(testKeys.getMSS(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getMSS(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.mss = 0d;
    Assert.assertEquals(testKeys.getMSS(c), "0");
}

- (void)timeouts {
    Assert.assertEquals(testKeys.getTimeouts(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced = new TestKeys.Advanced;
    Assert.assertEquals(testKeys.getTimeouts(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.advanced.timeouts = 0d;
    Assert.assertEquals(testKeys.getTimeouts(c), "0");
}

- (void)medianBitrate {
    Assert.assertEquals(testKeys.getMedianBitrate(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getMedianBitrate(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple.median_bitrate = 0d;
    Assert.assertEquals(testKeys.getMedianBitrate(c), "0.00");
    testKeys.simple.median_bitrate = 10d;
    Assert.assertEquals(testKeys.getMedianBitrate(c), "10.0");
}

- (void)medianBitrateUnit {
    Assert.assertEquals(testKeys.getMedianBitrateUnit, R.string.TestResults_NotAvailable);
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getMedianBitrateUnit, R.string.TestResults_NotAvailable);
    testKeys.simple.median_bitrate = 0d;
    Assert.assertEquals(testKeys.getMedianBitrateUnit, R.string.TestResults_Kbps);
    testKeys.simple.median_bitrate = 1000d;
    Assert.assertEquals(testKeys.getMedianBitrateUnit, R.string.TestResults_Mbps);
    testKeys.simple.median_bitrate = 1000d * 1000d;
    Assert.assertEquals(testKeys.getMedianBitrateUnit, R.string.TestResults_Gbps);
}

- (void)videoQuality {
    Assert.assertEquals(testKeys.getVideoQuality(false), R.string.TestResults_NotAvailable);
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getVideoQuality(false), R.string.TestResults_NotAvailable);
    testKeys.simple.median_bitrate = 0d;
    Assert.assertEquals(testKeys.getVideoQuality(false), R.string.r240p);
}

- (void)playoutDelay {
    Assert.assertEquals(testKeys.getPlayoutDelay(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple = new TestKeys.Simple;
    Assert.assertEquals(testKeys.getPlayoutDelay(c), c.getString(R.string.TestResults_NotAvailable));
    testKeys.simple.min_playout_delay = 0d;
    Assert.assertEquals(testKeys.getPlayoutDelay(c), "0.00");
}

@end
