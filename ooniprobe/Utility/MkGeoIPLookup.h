// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.
#ifndef MkGeoIPLookup_h
#define MkGeoIPLookup_h

#import <Foundation/Foundation.h>

@interface MkGeoIPLookupResults : NSObject

-(BOOL)good;

-(double)getBytesSent;

-(double)getBytesRecv;

-(NSString *)getProbeIP;

-(int64_t)getProbeASN;

-(NSString *)getProbeCC;

-(NSString *)getProbeOrg;

-(NSData *)getLogs;

-(void)deinit;

@end  // interface MkGeoIPLookupResults

@interface MkGeoIPLookupSettings : NSObject

-(id)init;

-(void)setTimeout:(int64_t)timeout;

-(MkGeoIPLookupResults *)perform;

-(void)deinit;

@end  // interface MkGeoIPLookupSettings

#endif /* MkGeoIPLookup_h */
