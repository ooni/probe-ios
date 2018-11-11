#import <Foundation/Foundation.h>

@interface SettingsUtility : NSObject

+ (NSArray*)getSettingsCategories;
+ (NSArray*)getSettingsForCategory:(NSString*)categoryName;
+ (NSString*)getTypeForSetting:(NSString*)setting;

+ (NSArray*)getAutomaticTestsEnabled;
+ (NSArray*)addRemoveAutomaticTest:(NSString*)testName;

+ (NSString*)getVerbosity;

+ (NSArray*)getSitesCategories;

+ (NSArray*)getSitesCategoriesDisabled;
+ (void)addRemoveSitesCategory:(NSString*)categoryName;
+ (long)getNumberCategoriesEnabled;

+ (NSArray*)getSettingsForTest:(NSString*)testName :(BOOL)includeAll;

+ (BOOL)getSettingWithName:(NSString*)settingName;

+ (NSString*)get_push_token;

+ (void)set_push_token:(NSString*)push_token;

@end
