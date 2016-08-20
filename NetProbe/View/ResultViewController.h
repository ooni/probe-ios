//
//  ResultViewController.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 22/07/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ResultViewController : UIViewController <UIActionSheetDelegate> 

@property (nonatomic, strong)NSString *json_file;
@property (nonatomic, strong) WKWebView *webView;

@end
