#import <Foundation/Foundation.h>

@interface Value : NSObject
@property (nonatomic, strong) NSNumber *key;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *percentage;
@property (nonatomic, strong) NSString *json_str;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSString *report_id;
@property (nonatomic, strong) NSString *probe_ip;
@property (nonatomic, strong) NSString *probe_asn;
@property (nonatomic, strong) NSString *probe_cc;
@property (nonatomic, strong) NSString *probe_network_name;
@property (nonatomic, strong) NSNumber *downloaded_kb;
@property (nonatomic, strong) NSNumber *uploaded_kb;
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) NSString *failure;
@property (nonatomic, strong) NSString *orig_key;

@end
