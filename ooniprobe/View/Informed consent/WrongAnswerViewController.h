#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WrongAnswerViewControllerDelegate <NSObject>
-(void)nextQuestion;
-(void)dismissPopup;
@end

@interface WrongAnswerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *goBackButton;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIView *cointainerWindow;
@property (strong, nonatomic) IBOutlet UIButton *closeView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) id<WrongAnswerViewControllerDelegate> delegate;

@end
