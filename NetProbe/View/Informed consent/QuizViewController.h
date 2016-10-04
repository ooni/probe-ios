//
//  QuizViewController.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface QuizViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *firstQuestion;
    NSArray *secondQuestion;
    NSArray *headers;
    long firstAnswer;
    long secondAnswer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
