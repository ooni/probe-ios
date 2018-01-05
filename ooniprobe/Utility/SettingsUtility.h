#import <Foundation/Foundation.h>

@interface SettingsUtility : NSObject

+ (NSArray*)getSettingsCategories;
+ (NSArray*)getSettingsForCategory:(NSString*)catName;
+ (NSArray*)getSettingsForTest:(NSString*)testName;

+ (NSArray*)getSitesCategories;

@end
