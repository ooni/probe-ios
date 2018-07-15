#import <Foundation/Foundation.h>
#import "Tampering.h"

@interface Simple
@property (nonatomic, strong) NSNumber *upload;
@property (nonatomic, strong) NSNumber *download;
@property (nonatomic, strong) NSNumber *ping;
@end

@interface Advanced
@property (nonatomic, strong) NSString *packet_loss;
@property (nonatomic, strong) NSString *out_of_order;
@property (nonatomic, strong) NSString *avg_rtt;
@property (nonatomic, strong) NSString *max_rtt;
@property (nonatomic, strong) NSString *mss;
@property (nonatomic, strong) NSString *timeouts;
@end

@interface TestKeys : NSObject
@property (nonatomic) BOOL blocking;
@property (nonatomic, strong) NSString *accessible;
@property (nonatomic, strong) NSString *sent;
@property (nonatomic, strong) NSString *received;
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
@property (nonatomic, strong) NSNumber *median_bitrate;
@property (nonatomic, strong) NSNumber *min_playout_delay;
@property (nonatomic, strong) NSString *whatsapp_endpoints_status;
@property (nonatomic, strong) NSString *whatsapp_web_status;
@property (nonatomic, strong) NSString *registration_server_status;
@property (nonatomic, strong) NSString *facebook_tcp_blocking;
@property (nonatomic, strong) NSString *facebook_dns_blocking;
@property (nonatomic, strong) NSString *telegram_http_blocking;
@property (nonatomic, strong) NSString *telegram_tcp_blocking;
@property (nonatomic, strong) Simple *simple;
@property (nonatomic, strong) Advanced *advanced;
@property (nonatomic, strong) Tampering *tampering;
@end

