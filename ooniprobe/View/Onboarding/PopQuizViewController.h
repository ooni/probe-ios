#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>
#import <QuartzCore/QuartzCore.h>
#import "WrongAnswerViewController.h"

@protocol PopQuizViewControllerDelegate <NSObject>
-(void)setQuestion_number:(NSInteger)qn;
@end

@interface PopQuizViewController : UIViewController <WrongAnswerViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *trueButton;
@property (strong, nonatomic) IBOutlet UIButton *falseButton;
@property (strong, nonatomic) IBOutlet UIView *cointainerWindow;
@property (strong, nonatomic) IBOutlet UIButton *closeView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, assign) NSInteger question_number;
@property (nonatomic, weak) id<PopQuizViewControllerDelegate> delegate;

-(void)nextQuestion;
-(void)dismissPopup;

@end
