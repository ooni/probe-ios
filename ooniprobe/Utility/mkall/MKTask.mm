// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.

#import "MKTask.h"

#import "measurement_kit/ffi.h"

@interface MKTask ()

@property mk_task_t *task;

@end  // interface MKTask

// Serialize settings to JSON.
static NSString *marshal_settings(NSDictionary *settings) {
  NSError *error = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:settings
                  options:0 error:&error];
  if (error != nil) return nil;
  // Using initWithData because data is not terminated by zero.
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@implementation MKTask

+ (MKTask *)startNettest:(NSDictionary *)settings {
  NSString *str = marshal_settings(settings);
  if (str == nil) return nil;
  MKTask *task = [MKTask alloc];
  if (task == nil) return nil;
  task.task = mk_nettest_start([str UTF8String]);
  return (task.task != nil) ? task : nil;
}

- (BOOL)isDone {
  return mk_task_is_done(self.task) ? TRUE : FALSE;
}

- (NSDictionary *)waitForNextEvent {
  // In this function we abort() a lot because most error conditions
  // correspond to very bad conditions that should not happen.
  mk_event_t *evp = mk_task_wait_for_next_event(self.task);
  if (evp == NULL) abort();
  const char *s = mk_event_serialize(evp);
  if (s == NULL) abort();
  // Here it's important to specify freeWhenDone because we control
  // the lifecycle of the data object using `eventp`.
  NSData *data = [NSData dataWithBytesNoCopy:(void *)s length:strlen(s)
                  freeWhenDone:NO];
  if (data == nil) abort();
  NSError *error = nil;
  NSDictionary *evinfo = [NSJSONSerialization JSONObjectWithData:data
                          options:0 error:&error];
  if (error != nil) {
    NSLog(@"Failed to parse event: %@", error);
    abort();
  }
  mk_event_destroy(evp);
  return evinfo;
}

- (void)interrupt {
  mk_task_interrupt(self.task);
}

- (void)deinit {
  mk_task_destroy(self.task);
}

@end  // implementation MKTask
