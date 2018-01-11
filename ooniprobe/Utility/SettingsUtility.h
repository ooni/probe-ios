#import <Foundation/Foundation.h>

@interface SettingsUtility : NSObject

+ (NSArray*)getSettingsCategories;
+ (NSArray*)getSettingsForCategory:(NSString*)catName;
+ (NSString*)getTypeForSetting:(NSString*)setting;

+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;

+ (NSArray*)getAutomaticTestsEnabled;
+ (NSArray*)addRemoveAutomaticTest:(NSString*)test_name;

+ (NSArray*)getSitesCategories;

+ (NSArray*)getSitesCategoriesEnabled;
+ (void)addRemoveSitesCategory:(NSString*)category_name;

+ (NSArray*)getSettingsForTest:(NSString*)test_name;

+ (BOOL)getSettingWithName:(NSString*)setting_name;
@end
