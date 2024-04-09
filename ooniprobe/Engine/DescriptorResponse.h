#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Nettest : NSObject

@property NSDictionary *backend_options;

@property NSArray<NSString *> *inputs;

@property BOOL is_background_run_enabled;

@property BOOL is_manual_run_enabled;

@property NSDictionary *options;

@property NSString *test_name;

@end


@interface OONIRunDescriptor : NSObject

@property NSString *oonirun_link_id;

@property NSString *name;

@property NSString *short_description;

@property NSString *i_description;

@property NSString *author;

@property NSArray<Nettest *> *nettests;

@property NSDictionary *name_intl;

@property NSDictionary *short_description_intl;

@property NSDictionary *description_intl;

@property NSString *icon;

@property NSString *color;

@property NSString *animation;

@property NSDate *expiration_date;

@property NSDate *date_created;

@property NSDate *date_updated;

@property NSString *revision;

@property bool is_expired;

@end

NS_ASSUME_NONNULL_END
