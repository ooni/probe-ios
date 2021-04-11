#import <Foundation/Foundation.h>
#import "Tampering.h"
#import "Simple.h"
#import "Advanced.h"
#import "Summary.h"
#import "Server.h"
#import "GatewayConnection.h"
#define BLOCKED @"blocked"
#define BLOCKING @"blocking"

@interface TestKeys : NSObject
@property (nonatomic, strong) NSString *blocking;
@property (nonatomic, strong) NSString *accessible;
@property (nonatomic, strong) NSArray *sent;
@property (nonatomic, strong) NSArray *received;
@property (nonatomic, strong) NSString *failure;
@property (nonatomic, strong) NSString *header_field_name;
@property (nonatomic, strong) NSString *header_field_number;
@property (nonatomic, strong) NSString *header_field_value;
@property (nonatomic, strong) NSString *header_name_capitalization;
@property (nonatomic, strong) NSString *request_line_capitalization;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *server_address;
@property (nonatomic, strong) NSString *server_name;
@property (nonatomic, strong) NSString *server_country;
@property (nonatomic, strong) NSString *whatsapp_endpoints_status;
@property (nonatomic, strong) NSString *whatsapp_web_status;
@property (nonatomic, strong) NSString *registration_server_status;
@property (nonatomic, strong) NSNumber *facebook_tcp_blocking;
@property (nonatomic, strong) NSNumber *facebook_dns_blocking;
@property (nonatomic, strong) NSNumber *telegram_http_blocking;
@property (nonatomic, strong) NSNumber *telegram_tcp_blocking;
@property (nonatomic, strong) NSString *telegram_web_status;
@property (nonatomic, strong) NSString *signal_backend_status;
@property (nonatomic, strong) NSString *signal_backend_failure;
@property (nonatomic, strong) Simple *simple;
@property (nonatomic, strong) Advanced *advanced;
@property (nonatomic, strong) Summary *summary;
@property (nonatomic, strong) Server *server;
@property (nonatomic, strong) Tampering *tampering;
@property (nonatomic, strong) NSNumber *protocol;
//Psiphon
@property (nonatomic, strong) NSNumber * bootstrap_time;
//Tor
@property (nonatomic, strong) NSNumber *dir_port_total;
@property (nonatomic, strong) NSNumber *dir_port_accessible;
@property (nonatomic, strong) NSNumber *obfs4_total;
@property (nonatomic, strong) NSNumber *obfs4_accessible;
@property (nonatomic, strong) NSNumber *or_port_dirauth_total;
@property (nonatomic, strong) NSNumber *or_port_dirauth_accessible;
@property (nonatomic, strong) NSNumber *or_port_total;
@property (nonatomic, strong) NSNumber *or_port_accessible;
//RiseupVPN
@property (nonatomic, strong) NSString *api_failure;
@property (nonatomic, strong) NSNumber *ca_cert_status;
@property (nonatomic, strong) NSArray *failing_gateways;
@property (nonatomic, strong) NSDictionary *transport_status;

- (NSString*)getJsonStr;

//WEB
- (NSString*)getWebsiteBlocking;
    
//WHATSAPP
- (NSString*)getWhatsappEndpointStatus;
- (NSString*)getWhatsappWebStatus;
- (NSString*)getWhatsappRegistrationStatus;
- (UIColor*)getWhatsappEndpointStatusColor;
- (UIColor*)getWhatsappWebStatusColor;
- (UIColor*)getWhatsappRegistrationStatusColor;

//TELEGRAM
- (NSString*)getTelegramEndpointStatus;
- (NSString*)getTelegramWebStatus;
- (UIColor*)getTelegramEndpointStatusColor;
- (UIColor*)getTelegramWebStatusColor;

//FACEBOOK
- (NSString*)getFacebookMessengerDns;
- (NSString*)getFacebookMessengerTcp;
- (UIColor*)getFacebookMessengerDnsColor;
- (UIColor*)getFacebookMessengerTcpColor;

//NDT
- (BOOL)isNdt7;
- (NSString*)getUpload;
- (NSString*)getUploadUnit;
- (NSString*)getUploadWithUnit;
- (NSString*)getDownload;
- (NSString*)getDownloadUnit;
- (NSString*)getDownloadWithUnit;
- (NSString*)getPing;
    
- (NSString*)getServerDetails;
- (NSString*)getPacketLoss;
- (NSString*)getAveragePing;
- (NSString*)getMaxPing;
- (NSString*)getMSS;
    
//DASH
- (NSString*)getVideoQuality:(BOOL)extended;
- (NSString*)getMedianBitrate;
- (NSString*)getMedianBitrateUnit;
- (NSString*)getPlayoutDelay;
    
//HIRL
//- (NSArray*)getSent;
//- (NSArray*)getReceived;

//PSIPHON
- (NSString*)getBootstrapTime;

//TOR
- (NSString*)getBridges;
- (NSString*)getAuthorities;

//RISEUPVPN
- (NSString*)getRiseupVPNApiStatus;
- (NSString*)getRiseupVPNOpenvpnGatewayStatus;
- (NSString*)getRiseupVPNBridgedGatewayStatus;
- (NSString*)getGatewayStatus:(NSString*)transport;
@end

