//
//  BrowserViewController.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 23/06/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
    int urlIndex;
    NSError *lastError;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSArray *urlList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *openMirrorButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;

@end
