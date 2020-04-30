#import "TestSummaryTableViewCell.h"

@implementation TestSummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResult:(Result*)result andMeasurement:(Measurement*)measurement{
    [self.notUploadedImage setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
    if (measurement.is_uploaded || measurement.is_failed)
        [self.notUploadedImage setHidden:YES];
    else
        [self.notUploadedImage setHidden:NO];
    
    if (measurement.is_failed){
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        [self.statusImage setImage:[UIImage imageNamed:@"error"]];
    }
    else {
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.statusImage setImage:nil];
    }
    if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
        [self.categoryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", measurement.test_name]]];
        if (measurement.is_failed)
            [self.categoryImage setTintColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        else
            [self.categoryImage setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (!measurement.is_anomaly){
            [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
            [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        }
        else {
            [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
            [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        }
    }
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
        if (!measurement.is_anomaly){
            [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
            [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
        }
        else {
            [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
            [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        }
    }
    else if ([result.test_group_name isEqualToString:@"websites"]){
        [self.titleLabel setText:[NSString stringWithFormat:@"%@", measurement.url_id.url]];
        [self.categoryImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category_%@", measurement.url_id.category_code]]];
        if (measurement.is_failed)
            [self.categoryImage setTintColor:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]];
        else
            [self.categoryImage setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
        if (!measurement.is_failed){
            if (!measurement.is_anomaly){
                [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
                [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
            }
            else {
                [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
                [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
            }
        }
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        self.ndtSpaceConstraint.constant = self.frame.size.width/1.8;
        [self setNeedsUpdateConstraints];
        [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
        [self.detail1Image setHidden:NO];
        [self.detail2Image setHidden:NO];
        [self.detail1Label setHidden:NO];
        [self.detail2Label setHidden:NO];
        
        if (measurement.is_failed){
            [self.detail1Image setHidden:YES];
            [self.detail2Image setHidden:YES];
            [self.detail1Label setHidden:YES];
            [self.detail2Label setHidden:YES];
        }
        else {
            if (!measurement.is_anomaly)
                [self.statusImage setImage:nil];
            else
                [self.statusImage setImage:nil];
        }
        if ([measurement.test_name isEqualToString:@"ndt"]){
            TestKeys *testKeysNdt = [measurement testKeysObj];
            [self.stackView2 setHidden:NO];
            [self.detail1Image setImage:[UIImage imageNamed:@"download"]];
            [self.detail1Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self.detail2Image setImage:[UIImage imageNamed:@"upload"]];
            [self.detail2Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self.detail1Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self.detail2Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self setText:[testKeysNdt getDownloadWithUnit] forLabel:self.detail1Label inStackView:self.stackView1];
            [self setText:[testKeysNdt getUploadWithUnit] forLabel:self.detail2Label inStackView:self.stackView2];
        }
        else if ([measurement.test_name isEqualToString:@"dash"]){
            TestKeys *testKeysDash = [measurement testKeysObj];
            [self.stackView2 setHidden:YES];
            [self.detail1Image setImage:[UIImage imageNamed:@"video_quality"]];
            [self.detail1Image setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self.detail1Label setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
            [self setText:[testKeysDash getVideoQuality:YES] forLabel:self.detail1Label inStackView:self.stackView1];
        }
        else if ([measurement.test_name isEqualToString:@"http_invalid_request_line"]
                 || [measurement.test_name isEqualToString:@"http_header_field_manipulation"]){
            [self.titleLabel setText:[LocalizationUtility getNameForTest:measurement.test_name]];
            if (!measurement.is_anomaly){
                [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
                [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green8 alpha:1.0f]];
            }
            else {
                [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
                [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
            }
        }

    }
}

-(void)setText:(NSString*)text forLabel:(UILabel*)label inStackView:(UIStackView*)stackView{
    if (text == nil)
        text = NSLocalizedString(@"TestResults.NotAvailable", nil);
    [label setText:text];
    if ([text isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]){
        [stackView setAlpha:0.3f];
    }
}

@end
