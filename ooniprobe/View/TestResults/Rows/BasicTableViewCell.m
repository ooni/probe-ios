#import "BasicTableViewCell.h"

@implementation BasicTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    //https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm/4866205
    if(self.imageView.image != nil){
        CGRect cellFrame = self.frame;
        CGRect textLabelFrame = self.textLabel.frame;
        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        CGRect imageViewFrame = self.imageView.frame;

        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = true;
        self.imageView.frame = CGRectMake(20,(self.frame.size.height-32)/2 + 1,32,32);
        self.textLabel.frame = CGRectMake(50 + imageViewFrame.origin.x, textLabelFrame.origin.y, cellFrame.size.width-70 + imageViewFrame.origin.x, textLabelFrame.size.height);
        self.detailTextLabel.frame = CGRectMake(50 + imageViewFrame.origin.x, detailTextLabelFrame.origin.y, cellFrame.size.width-70 + imageViewFrame.origin.x, detailTextLabelFrame.size.height);
    }
}

@end
