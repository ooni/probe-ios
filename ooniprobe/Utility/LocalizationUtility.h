#import <Foundation/Foundation.h>

@interface LocalizationUtility : NSObject

+ (NSString*)getNameForTest:(NSString*)testName;
+ (NSString*)getMKNameForTest:(NSString*)testName;
+ (NSString*)getDescriptionForTest:(NSString*)testName;
+ (NSString*)getLongDescriptionForTest:(NSString*)testName;
+ (NSString*)getFilterNameForTest:(NSString*)testName;
+ (NSString*)getNameForSetting:(NSString*)settingName;
+ (NSString*)getSingularPluralTemplate:(long)value :(NSString*)locString;
+ (NSString*)getSingularPlural:(long)value :(NSString*)locString;
+ (NSString*)getUrlForTest:(NSString*)testName;
@end
