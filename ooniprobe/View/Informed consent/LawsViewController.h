//
//  LawsViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 15/01/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedButton.h"

@interface LawsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;


@end
