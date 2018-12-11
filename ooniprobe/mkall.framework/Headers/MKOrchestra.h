// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.
#ifndef MKOrchestra_h
#define MKOrchestra_h

#import <Foundation/Foundation.h>

@interface MKOrchestraResult : NSObject

-(BOOL)good;

-(NSData *)getLogs;

-(void)deinit;

@end  // interface MKOrchestraResult

@interface MKOrchestraClient : NSObject

-(id)init;

-(void)setAvailableBandwidth:(NSString *)value;

-(void)setDeviceToken:(NSString *)value;

-(void)setLanguage:(NSString *)value;

-(void)setNetworkType:(NSString *)value;

-(void)setPlatform:(NSString *)value;

-(void)setProbeASN:(NSString *)value;

-(void)setProbeCC:(NSString *)value;

-(void)setProbeFamily:(NSString *)value;

-(void)setProbeTimezone:(NSString *)value;

-(void)setRegistryURL:(NSString *)value;

-(void)setSecretsFile:(NSString *)value;

-(void)setSoftwareName:(NSString *)value;

-(void)setSoftwareVersion:(NSString *)value;

-(void)addSupportedTest:(NSString *)value;

-(void)setTimeout:(int64_t)timeout;

-(MKOrchestraResult *)sync;

-(void)deinit;

@end  // interface MKOrchestraClient

#endif /* MKOrchestra_h */
