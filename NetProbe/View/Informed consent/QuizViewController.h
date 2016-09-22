//
//  QuizViewController.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 16/09/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *firstQuestion;
    NSArray *secondQuestion;
    NSArray *headers;
    long firstAnswer;
    long secondAnswer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
