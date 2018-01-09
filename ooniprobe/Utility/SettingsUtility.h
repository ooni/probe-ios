#import <Foundation/Foundation.h>

@interface SettingsUtility : NSObject

+ (NSArray*)getSettingsCategories;
+ (NSArray*)getSettingsForCategory:(NSString*)catName;
+ (NSString*)getTypeForSetting:(NSString*)setting;

+ (NSArray*)getSettingsForTest:(NSString*)testName;

+ (NSDictionary*)getTests;
+ (NSArray*)getTestTypes;

+ (NSArray*)getAutomaticTestsEnabled;
+ (NSArray*)addRemoveAutomaticTest:(NSString*)test_name;

+ (NSArray*)getSitesCategories;

+ (NSArray*)getSitesCategoriesEnabled;
+ (void)addRemoveSitesCategory:(NSString*)category_name;

@end
