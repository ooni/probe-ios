#include <sys/sysctl.h>
#import "UIDevice-DeviceInfo.h"

@implementation UIDevice (DeviceInfo)

- (NSString *)getSysInfoByName:(const char *)typeSpecifier
{
    size_t size = 0;
    int ret = sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    if (ret != 0 || size == 0) abort();

    char *answer = malloc(size);
    if (answer == NULL) abort();
    
    ret = sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    if (ret != 0) {
        free(answer);
        abort();
    }
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)modelName {
    static NSString *_modelName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *models = @{
                @"AppleTV2,1": @"Apple TV 2",
                @"AppleTV3,1": @"Apple TV 3",
                @"AppleTV3,2": @"Apple TV 3",
                @"AppleTV5,3": @"Apple TV 4",
                @"AppleTV6,2": @"Apple TV 4K",
                @"iMac21,1": @"iMac (24-inch, M1, 2021)",
                @"iMac21,2": @"iMac (24-inch, M1, 2021)",
                @"iPad1,1": @"iPad",
                @"iPad2,1": @"iPad 2",
                @"iPad2,2": @"iPad 2",
                @"iPad2,3": @"iPad 2",
                @"iPad2,4": @"iPad 2",
                @"iPad2,5": @"iPad mini",
                @"iPad2,6": @"iPad mini",
                @"iPad2,7": @"iPad mini",
                @"iPad3,1": @"iPad 3",
                @"iPad3,2": @"iPad 3",
                @"iPad3,3": @"iPad 3",
                @"iPad3,4": @"iPad 4",
                @"iPad3,5": @"iPad 4",
                @"iPad3,6": @"iPad 4",
                @"iPad4,1": @"iPad Air",
                @"iPad4,2": @"iPad Air",
                @"iPad4,3": @"iPad Air",
                @"iPad4,4": @"iPad mini 2",
                @"iPad4,5": @"iPad mini 2",
                @"iPad4,6": @"iPad mini 2",
                @"iPad4,7": @"iPad mini 3",
                @"iPad4,8": @"iPad mini 3",
                @"iPad4,9": @"iPad mini 3",
                @"iPad5,1": @"iPad mini 4",
                @"iPad5,2": @"iPad mini 4",
                @"iPad5,3": @"iPad Air 2",
                @"iPad5,4": @"iPad Air 2",
                @"iPad6,3": @"iPad Pro (9.7-inch)",
                @"iPad6,4": @"iPad Pro (9.7-inch)",
                @"iPad6,7": @"iPad Pro (12.9-inch)",
                @"iPad6,8": @"iPad Pro (12.9-inch)",
                @"iPad6,11": @"iPad 5",
                @"iPad6,12": @"iPad 5",
                @"iPad7,1": @"iPad Pro 2 (12.9-inch)",
                @"iPad7,2": @"iPad Pro 2 (12.9-inch)",
                @"iPad7,3": @"iPad Pro (10.5-inch)",
                @"iPad7,4": @"iPad Pro (10.5-inch)",
                @"iPad7,5": @"iPad 6",
                @"iPad7,6": @"iPad 6",
                @"iPad7,11": @"iPad 7",
                @"iPad7,12": @"iPad 7",
                @"iPad8,1": @"iPad Pro 3 (11-inch)",
                @"iPad8,2": @"iPad Pro 3 (11-inch)",
                @"iPad8,3": @"iPad Pro 3 (11-inch)",
                @"iPad8,4": @"iPad Pro 3 (11-inch)",
                @"iPad8,5": @"iPad Pro 3 (12.9-inch)",
                @"iPad8,6": @"iPad Pro 3 (12.9-inch)",
                @"iPad8,7": @"iPad Pro 3 (12.9-inch)",
                @"iPad8,8": @"iPad Pro 3 (12.9-inch)",
                @"iPad8,9": @"iPad Pro 4 (11-inch)",
                @"iPad8,10": @"iPad Pro 4 (11-inch)",
                @"iPad8,11": @"iPad Pro 4 (12.9-inch)",
                @"iPad8,12": @"iPad Pro 4 (12.9-inch)",
                @"iPad11,1": @"iPad mini 5",
                @"iPad11,2": @"iPad mini 5",
                @"iPad11,3": @"iPad Air 3",
                @"iPad11,4": @"iPad Air 3",
                @"iPad11,6": @"iPad 8",
                @"iPad11,7": @"iPad 8",
                @"iPad12,1": @"iPad 9",
                @"iPad12,2": @"iPad 9",
                @"iPad13,1": @"iPad Air 4",
                @"iPad13,2": @"iPad Air 4",
                @"iPad13,4": @"iPad Pro 11-inch (3rd generation)",
                @"iPad13,5": @"iPad Pro 11-inch (3rd generation)",
                @"iPad13,6": @"iPad Pro 11-inch (3rd generation)",
                @"iPad13,7": @"iPad Pro 11-inch (3rd generation)",
                @"iPad13,8": @"iPad Pro 12.9-inch (5th generation)",
                @"iPad13,9": @"iPad Pro 12.9-inch (5th generation)",
                @"iPad13,10": @"iPad Pro 12.9-inch (5th generation)",
                @"iPad13,11": @"iPad Pro 12.9-inch (5th generation)",
                @"iPad13,16": @"iPad Air 5",
                @"iPad13,17": @"iPad Air 5",
                @"iPad13,18": @"iPad (10th generation)",
                @"iPad13,19": @"iPad (10th generation)",
                @"iPad14,1": @"iPad mini 6",
                @"iPad14,2": @"iPad mini 6",
                @"iPad14,3": @"iPad Pro 11-inch (4th generation)",
                @"iPad14,4": @"iPad Pro 11-inch (4th generation)",
                @"iPad14,5": @"iPad Pro 12.9-inch (6th generation)",
                @"iPad14,6": @"iPad Pro 12.9-inch (6th generation)",
                @"iPhone1,1": @"iPhone",
                @"iPhone1,2": @"iPhone 3G",
                @"iPhone2,1": @"iPhone 3GS",
                @"iPhone3,1": @"iPhone 4",
                @"iPhone3,2": @"iPhone 4",
                @"iPhone3,3": @"iPhone 4",
                @"iPhone4,1": @"iPhone 4S",
                @"iPhone5,1": @"iPhone 5",
                @"iPhone5,2": @"iPhone 5",
                @"iPhone5,3": @"iPhone 5c",
                @"iPhone5,4": @"iPhone 5c",
                @"iPhone6,1": @"iPhone 5s",
                @"iPhone6,2": @"iPhone 5s",
                @"iPhone7,1": @"iPhone 6 Plus",
                @"iPhone7,2": @"iPhone 6",
                @"iPhone8,1": @"iPhone 6s",
                @"iPhone8,2": @"iPhone 6s Plus",
                @"iPhone8,4": @"iPhone SE",
                @"iPhone9,1": @"iPhone 7",
                @"iPhone9,2": @"iPhone 7 Plus",
                @"iPhone9,3": @"iPhone 7",
                @"iPhone9,4": @"iPhone 7 Plus",
                @"iPhone10,1": @"iPhone 8",
                @"iPhone10,2": @"iPhone 8 Plus",
                @"iPhone10,3": @"iPhone X",
                @"iPhone10,4": @"iPhone 8",
                @"iPhone10,5": @"iPhone 8 Plus",
                @"iPhone10,6": @"iPhone X",
                @"iPhone11,2": @"iPhone XS",
                @"iPhone11,4": @"iPhone XS Max",
                @"iPhone11,6": @"iPhone XS Max",
                @"iPhone11,8": @"iPhone XR",
                @"iPhone12,1": @"iPhone 11",
                @"iPhone12,3": @"iPhone 11 Pro",
                @"iPhone12,5": @"iPhone 11 Pro Max",
                @"iPhone12,8": @"iPhone SE (2nd generation)",
                @"iPhone13,1": @"iPhone 12 mini",
                @"iPhone13,2": @"iPhone 12",
                @"iPhone13,3": @"iPhone 12 Pro",
                @"iPhone13,4": @"iPhone 12 Pro Max",
                @"iPhone14,2": @"iPhone 13 Pro",
                @"iPhone14,3": @"iPhone 13 Pro Max",
                @"iPhone14,4": @"iPhone 13 mini",
                @"iPhone14,5": @"iPhone 13",
                @"iPhone14,6": @"iPhone SE (3rd generation)",
                @"iPhone14,7": @"iPhone 14",
                @"iPhone14,8": @"iPhone 14 Plus",
                @"iPhone15,2": @"iPhone 14 Pro",
                @"iPhone15,3": @"iPhone 14 Pro Max",
                @"iPod1,1": @"iPod touch",
                @"iPod2,1": @"iPod touch 2",
                @"iPod3,1": @"iPod touch 3",
                @"iPod4,1": @"iPod touch 4",
                @"iPod5,1": @"iPod touch 5",
                @"iPod7,1": @"iPod touch 6",
                @"iPod9,1": @"iPod touch 7",
                @"Mac13,1": @"Mac Studio (M1 Max)",
                @"Mac13,2": @"Mac Studio (M1 Ultra)",
                @"Mac14,2": @"MacBook Air (M2, 2022)",
                @"Mac14,3": @"Mac mini (M2, 2023)",
                @"Mac14,5": @"MacBook Pro (M2 Max, 14-inch, 2023)",
                @"Mac14,6": @"MacBook Pro (M2 Max, 16-inch, 2023)",
                @"Mac14,7": @"MacBook Pro (13-inch, M2, 2022)",
                @"Mac14,8": @"Mac Pro (2023)",
                @"Mac14,9": @"MacBook Pro (M2 Pro, 14-inch, 2023)",
                @"Mac14,10": @"MacBook Pro (M2 Pro, 16-inch, 2023)",
                @"Mac14,12": @"Mac mini (M2 Pro, 2023)",
                @"Mac14,13": @"Mac Studio (M2 Max, 2023)",
                @"Mac14,14": @"Mac Studio (M2 Ultra, 2023)",
                @"Mac14,15": @"MacBook Air (15-inch, M2, 2023)",
                @"MacBookAir10,1": @"MacBook Air (M1, 2020)",
                @"MacBookPro17,1": @"MacBook Pro (13-inch, M1, 2020)",
                @"MacBookPro18,1": @"MacBook Pro (16-inch, 2021)",
                @"MacBookPro18,2": @"MacBook Pro (16-inch, 2021)",
                @"MacBookPro18,3": @"MacBook Pro (14-inch, 2021)",
                @"MacBookPro18,4": @"MacBook Pro (14-inch, 2021)",
                @"Macmini9,1": @"Mac mini (M1, 2020)",
                @"VirtualMac2,1": @"Apple Virtual Machine 1",
                @"Watch1,1": @"Apple Watch (38mm)",
                @"Watch1,2": @"Apple Watch (42mm)",
                @"Watch2,3": @"Apple Watch Series 2 (38mm)",
                @"Watch2,4": @"Apple Watch Series 2 (42mm)",
                @"Watch2,6": @"Apple Watch Series 1 (38mm)",
                @"Watch2,7": @"Apple Watch Series 1 (42mm)",
                @"Watch3,1": @"Apple Watch Series 3 (38mm, LTE)",
                @"Watch3,2": @"Apple Watch Series 3 (42mm, LTE)",
                @"Watch3,3": @"Apple Watch Series 3 (38mm)",
                @"Watch3,4": @"Apple Watch Series 3 (42mm)",
                @"Watch4,1": @"Apple Watch Series 4 (40mm)",
                @"Watch4,2": @"Apple Watch Series 4 (44mm)",
                @"Watch4,3": @"Apple Watch Series 4 (40mm, LTE)",
                @"Watch4,4": @"Apple Watch Series 4 (44mm, LTE)",
                @"Watch5,1": @"Apple Watch Series 5 (40mm)",
                @"Watch5,2": @"Apple Watch Series 5 (44mm)",
                @"Watch5,3": @"Apple Watch Series 5 (40mm, LTE)",
                @"Watch5,4": @"Apple Watch Series 5 (44mm, LTE)",
                @"i386": @"Simulator",
                @"x86_64": @"Simulator",
        };
        _modelName = models[self.modelIdentifier] ?: self.modelIdentifier;
    });
    if (_modelName == nil) {
        _modelName = self.modelIdentifier;
    }
    return _modelName;
}

@end
