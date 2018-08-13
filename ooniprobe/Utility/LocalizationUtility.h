#import <Foundation/Foundation.h>

@interface LocalizationUtility : NSObject

+ (NSString*)getNameForTest:(NSString*)testName;
+ (NSString*)getDescriptionForTest:(NSString*)testName;
+ (NSString*)getLongDescriptionForTest:(NSString*)testName;
+ (NSString*)getFilterNameForTest:(NSString*)testName;
+ (NSString*)getNameForSetting:(NSString*)settingName;
+ (NSString*)getSingularPlural:(long)value :(NSString*)locString;
@end
