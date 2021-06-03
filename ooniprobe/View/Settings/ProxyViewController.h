#import <UIKit/UIKit.h>
#import "ProxySettings.h"

@interface ProxyViewController : UITableViewController {
    NSArray *items;
    UIToolbar *keyboardToolbar;
    ProxySettings *currentProxy;
}

@end
