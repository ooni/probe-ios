#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProxyProtocol) {
  NONE,
  PSIPHON,
  SOCKS5,
  HTTP,
  HTTPS
};

@interface ProxySettings : NSObject

@property (nonatomic) ProxyProtocol protocol;
@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, strong) NSString *port;

- (void)saveProxy;
- (BOOL)isCustom;
- (NSString*)getProxyString;
+ (BOOL)isIPv6:(NSString*)hostname;
+ (NSString*)getProtocol:(ProxyProtocol) protocol;

@end
