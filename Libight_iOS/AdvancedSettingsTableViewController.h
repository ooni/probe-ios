//
//  AdvancedSettingsTableViewController.h
//  Libight_iOS
//
//  Created by Lorenzo Primiterra on 05/04/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSettingsTableViewController : UITableViewController <UIAlertViewDelegate>
{
    NSArray *settingsItems;
    UITextField *value;
}

@end
