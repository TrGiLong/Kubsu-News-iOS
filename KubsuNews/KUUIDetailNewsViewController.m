//
//  KUUIDetailNewsViewController.m
//  KubsuNews
//
//  Created by Long on 28.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIDetailNewsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <GSKStretchyHeaderView/GSKStretchyHeaderView.h>
@interface KUUIDetailNewsViewController  ()

@end

@implementation KUUIDetailNewsViewController 
{
    GSKStretchyHeaderView *headerView;
    UIImageView *imageView;
    KUNewsItem *news;
    
    KUDataController *dataController;
    UIActivityIndicatorView *activityIndicator;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil news:(KUNewsItem *)aNews dataController:(KUDataController *)aDataController{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        news = aNews;
        dataController = aDataController;
        dataController.delegateDetailNews = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerView = [[GSKStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 200)];
    headerView.minimumContentHeight = 0;
    [self.scrollView addSubview:headerView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    [imageView sd_setImageWithURL:news.imageLink];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImage:[UIImage imageNamed:@"splash_logo"]];
    [headerView addSubview:imageView];
    
    
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];

    
    [self.titleLabel setText:news.title];
    [self.author setText:[NSString stringWithFormat:@"Опубликовал(а) %@,\nчлен Пресс-центра ОСО КубГУ",news.publisher]];
    
    if (news.detail == nil) {
        [self setDetailText:@" "];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(CGRectGetMidX(self.detailTextView.bounds), self.detailTextView.bounds.size.height/2);
        [self.detailTextView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [dataController getFullNews:news];
        
    } else {
        [self setDetailText:news.detail];
    }
   

}

-(void)KUDataController:(KUDataController *)controller receiveNewsDetail:(KUNewsItem *)itemNews {
    [self setDetailText:itemNews.detail];
    dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    });
}

-(void)setDetailText:(NSString*)aText {
    NSMutableAttributedString *attributedText = [[[NSAttributedString alloc] initWithData:[aText dataUsingEncoding:NSUTF8StringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                       documentAttributes:nil error:nil] mutableCopy];
    [self fixFontSizeForAttributeString:attributedText increase:5];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.detailTextView setAttributedText:attributedText];
    });
}

-(void)favorite {
    
}

-(void)share {
    NSString *textShare = [NSString stringWithFormat:@"%@\n%@\nОтправлено через #информер_осо",news.title,news.webLink.absoluteString];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard]; //Exclude whichever aren't relevant
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    dataController.delegateDetailNews = nil;
}

-(void)fixFontSizeForAttributeString:(NSMutableAttributedString*)attrib increase:(CGFloat)incSize {
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            NSLog(@"%@ %f",oldFont.fontName,oldFont.pointSize);
            
            [attrib removeAttribute:NSFontAttributeName range:range];
            [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:oldFont.pointSize + incSize] range:range];
        }
    }];
    [attrib endEditing];
}

@end

