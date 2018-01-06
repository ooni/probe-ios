#import <Foundation/Foundation.h>

@interface SettingsUtility : NSObject

+ (NSArray*)getSettingsCategories;
+ (NSArray*)getSettingsForCategory:(NSString*)catName;
+ (NSString*)getTypeForSetting:(NSString*)setting;

+ (NSArray*)getSettingsForTest:(NSString*)testName;

+ (NSArray*)getSitesCategories;

@end
