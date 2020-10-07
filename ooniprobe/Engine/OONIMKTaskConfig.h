#import <Foundation/Foundation.h>

/**
 * OONIMKTaskConfig is the interface that any settings for MK-like tasks
 * must implement. It allows the engine to discover the name of the task
 * that we want to run and to obtain its serialization.
 */
@protocol OONIMKTaskConfig

/** taskName returns the task name */
- (NSString*) taskName;

/**
 * serialization returns the JSON serialization of the task config, which
 * must be compatible with Measurement Kit v0.9.0 specification.
 */
- (NSString*) serialization;

/**
 * dictionary returns the NSDictionary object of the task config
 */
- (NSDictionary*) dictionary;


@end
