//
//  Oboarding3ViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/12/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <PopupKit/PopupView.h>

@interface Oboarding3ViewController : UIViewController {
    UIView *quizView;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
