//
//  UIForLumberjack.m
//  ooniprobe
//
//  Created by Norbel Ambanumben on 06/09/2022.
//  Copyright © 2022 OONI. All rights reserved.
//

#import "UIForLumberjack.h"


NSString *const LogCellReuseIdentifier = @"LogCell";

@interface UIForLumberjack () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) UITableView *tableView;

@property(nonatomic) NSMutableArray *messages;
@property(nonatomic) NSMutableSet *messagesExpanded;
@property(nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation UIForLumberjack

#pragma mark - Class Methods

+ (UIForLumberjack *)sharedInstance {
    static UIForLumberjack *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIForLumberjack alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init; {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.messages = [NSMutableArray array];
    self.messagesExpanded = [NSMutableSet set];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LogCellReuseIdentifier];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.8f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm:ss:SSS"];

    return self;
}

#pragma mark - DDLogger

@synthesize logFormatter;

- (void)logMessage:(DDLogMessage *)logMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_messages addObject:logMessage];

        if (_tableView.superview == nil) {return;}

        BOOL scroll = NO;
        if (_tableView.contentOffset.y + _tableView.bounds.size.height >= _tableView.contentSize.height)
            scroll = YES;


        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_messages.count - 1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];

        if (scroll) {
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LogCellReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *messageText = [self textOfMessageForIndexPath:indexPath];
    CGFloat const messageMargin = 10.0;
    return ceil([messageText boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width - 30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [self fontOfMessage]} context:nil].size.height + messageMargin);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"Hide Log" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor colorWithRed:59 / 255.0 green:209 / 255.0 blue:65 / 255.0 alpha:1];
    [closeButton addTarget:self action:@selector(hideLog) forControlEvents:UIControlEventTouchUpInside];
    return closeButton;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *index = @(indexPath.row);
    if ([_messagesExpanded containsObject:index]) {
        [_messagesExpanded removeObject:index];
    } else {
        [_messagesExpanded addObject:index];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Private Methods

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDLogMessage *message = _messages[indexPath.row];

    switch (message.flag) {
        case DDLogFlagError:
            cell.textLabel.textColor = [UIColor redColor];
            break;

        case DDLogFlagWarning:
            cell.textLabel.textColor = [UIColor orangeColor];
            break;

        case DDLogFlagDebug:
            cell.textLabel.textColor = [UIColor greenColor];
            break;

        case DDLogFlagVerbose:
            cell.textLabel.textColor = [UIColor blueColor];
            break;

        default:
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
    }

    cell.textLabel.text = [self textOfMessageForIndexPath:indexPath];
    cell.textLabel.font = [self fontOfMessage];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor clearColor];
}

- (NSString *)textOfMessageForIndexPath:(NSIndexPath *)indexPath {
    DDLogMessage *message = _messages[indexPath.row];
    if ([_messagesExpanded containsObject:@(indexPath.row)]) {
        return [NSString stringWithFormat:@"[%@] %@:%lu [%@]", [_dateFormatter stringFromDate:message.timestamp], message.file, (unsigned long) message.line, message.function];
    } else {
        return [NSString stringWithFormat:@"[%@] %@", [_dateFormatter stringFromDate:message.timestamp], message.message];
    }
}

- (UIFont *)fontOfMessage {
    return [UIFont boldSystemFontOfSize:9];
}

#pragma mark - Public Methods

- (void)showLogInView:(UIView *)view {
    [view addSubview:self.tableView];
    UITableView *tv = self.tableView;
    tv.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)]];
}

/*- (void)hideLog {
    [self.tableView removeFromSuperview];
}*/

- (void)clearLog {
    [_messages removeAllObjects];
    [_messagesExpanded removeAllObjects];
    [self.tableView reloadData];
}

@end
