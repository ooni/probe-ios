#import <Foundation/Foundation.h>

/**
 * OONIMKTask is an MK-like task run by OONI Probe's engine. The expected usage
 * of this interface like in the following code snippet:
 *
 * <pre>
 *     while (!task.isDone()) {
 *         processEvent(task.waitForNextEvent());
 *     }
 * </pre>
 *
 * We do not necessarily run all tasks using the same backend. Some
 * backends support interrupting a task, others do not. Use the
 * canInterrupt() method to find out whether this is possible. If
 * a task can be interrupted, interrupt() will interrupt it. The task
 * will stop as soon as possible but not necessarily immediately.
 */
@protocol OONIMKTask

/** isDone tells you whether this task has completed. */
- (BOOL) isDone;

/**
 * waitForNextEvent blocks until the next event is available
 * and return returns such event to the caller. The returned
 * event is a NSDictionary with the JSON serialized string
 * that uses the data format specified by Measurement Kit v0.9.0.
 */
- (NSDictionary*) waitForNextEvent:(NSError **)error;

/** canInterrupt returns true if this task can be interrupted. */
- (BOOL) canInterrupt;

/**
 * interrupt will interrupt this task. If the backend does
 * not support interrupting a task, this method does noething.
 */
- (void) interrupt;

@end
