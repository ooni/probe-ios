#import "MiddleBoxesDetailsViewController.h"

@interface MiddleBoxesDetailsViewController ()

@end

@implementation MiddleBoxesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!super.measurement.anomaly){
        [self.statusImage setImage:[UIImage imageNamed:@"tick"]];
        [self.statusImage setTintColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
    }
    else {
        [self.statusImage setImage:[UIImage imageNamed:@"exclamation_point"]];
        [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
    }
    
    if ([self.measurement.name isEqualToString:@"http_invalid_request_line"]){
        if (!super.measurement.anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.NotFound.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.NotFound.Content.Paragraph.1", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.Found.Hero.Title", nil)];
            [self.subtitleLabel setText:[NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.Found.Content.Paragraph.1", nil), NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.Found.Content.Paragraph.2", nil)]];
        }
        Summary *summary = [self.result getSummary];
        NSArray *sent = [summary getSent];
        [self setLabelValue:sent :0 :0];
        [self setLabelValue:sent :1 :0];
        [self setLabelValue:sent :2 :0];
        [self setLabelValue:sent :3 :0];

        NSArray *received = [summary getReceived];
        [self setLabelValue:received :0 :1];
        [self setLabelValue:received :1 :1];
        [self setLabelValue:received :2 :1];
        [self setLabelValue:received :3 :1];
        [self.sentTitleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.YouSent", nil)];
        [self.receivedTitleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPInvalidRequestLine.YouReceived", nil)];
    }
    else if ([self.measurement.name isEqualToString:@"http_header_field_manipulation"]){
        [self.sentReceivedStackView setHidden:YES];
        if (!super.measurement.anomaly){
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.NotFound.Hero.Title", nil)];
            [self.subtitleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.NotFound.Content.Paragraph.1", nil)];
        }
        else {
            [self.titleLabel setText:NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Hero.Title", nil)];
            [self.subtitleLabel setText:[NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Content.Paragraph.1", nil), NSLocalizedString(@"TestResults.Details.Middleboxes.HTTPHeaderFieldManipulation.Found.Content.Paragraph.2", nil)]];
        }
    }
}

- (void)setLabelValue:(NSArray*)arr :(int)idx :(int)column {
    NSString *value = @"";
    if ([arr count] > idx && [arr objectAtIndex:idx]){
        value = [arr objectAtIndex:idx];
    }
    if (idx == 0){
        if (column == 0)
            [self.sent1Label setText:value];
        else
            [self.received1Label setText:value];
    }
    else if (idx == 1){
        if (column == 0)
            [self.sent2Label setText:value];
        else
            [self.received2Label setText:value];
    }
    else if (idx == 2){
        if (column == 0)
            [self.sent3Label setText:value];
        else
            [self.received3Label setText:value];
    }
    else if (idx == 3){
        if (column == 0)
            [self.sent4Label setText:value];
        else
            [self.received4Label setText:value];
    }
}
@end
