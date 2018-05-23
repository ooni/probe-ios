#import <UIKit/UIKit.h>
#import "SettingsUtility.h"

@interface WebsiteCategoryTableViewController : UITableViewController {
    NSArray *categories_disabled;
}

@property (nonatomic, strong) NSString *category;

@end
