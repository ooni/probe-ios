// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.
#ifndef MKTask_h
#define MKTask_h

#import <Foundation/Foundation.h>

@interface MKTask : NSObject

+ (MKTask *)startNettest:(NSDictionary *)data;

- (BOOL)isDone;

- (NSDictionary *)waitForNextEvent;

- (void)interrupt;

- (void)deinit;

@end  // interface MKTask

#endif /* MKTask_h */
