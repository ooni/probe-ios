// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.
#ifndef MKGeoIPLookup_h
#define MKGeoIPLookup_h

#import <Foundation/Foundation.h>

@interface MKGeoIPLookupResults : NSObject

-(BOOL)good;

-(double)getBytesSent;

-(double)getBytesRecv;

-(NSString *)getProbeIP;

-(int64_t)getProbeASN;

-(NSString *)getProbeCC;

-(NSString *)getProbeOrg;

-(NSData *)getLogs;

-(void)deinit;

@end  // interface MKGeoIPLookupResults

@interface MKGeoIPLookupSettings : NSObject

-(id)init;

-(void)setTimeout:(int64_t)timeout;

-(MKGeoIPLookupResults *)perform;

-(void)deinit;

@end  // interface MKGeoIPLookupSettings

#endif /* MKGeoIPLookup_h */
