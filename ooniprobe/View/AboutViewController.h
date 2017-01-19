//
//  AboutViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 19/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "RoundedButton.h"

@interface AboutViewController : UIViewController
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *learnMoreButton;

@end
