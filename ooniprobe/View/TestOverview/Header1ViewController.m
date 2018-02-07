#import "Header1ViewController.h"

@interface Header1ViewController ()

@end

@implementation Header1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLine:self.view2];
    [self addLine:self.view3];
    [self addLine:self.view4];

/*
 UIView *LineView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-5, 0, 1, self.view.frame.size.height)]; // customize the frame what u need
 [LineView setBackgroundColor:[UIColor whiteColor]]; //customize the color
 [self.view1 addSubview:LineView];
 

    CGFloat sortaPixel = 1 / [UIScreen mainScreen].scale;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sortaPixel)];
    
    line.userInteractionEnabled = NO;
    line.backgroundColor = self.backgroundColor;
    
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.view1 addSubview:line];
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
*/
}

-(void)addLine:(UIView*)view{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.frame.size.height)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
}
@end
