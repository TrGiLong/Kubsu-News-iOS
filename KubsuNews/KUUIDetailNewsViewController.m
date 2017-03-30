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
    [headerView addSubview:imageView];

    
    [self.titleLabel setText:news.title];
    [self.author setText:news.publisher];
    
    [dataController getFullNews:news];
}

-(void)KUDataController:(KUDataController *)controller receiveNewsDetail:(KUNewsItem *)itemNews {
    
    NSMutableAttributedString *attributedText = [[[NSAttributedString alloc] initWithData:[itemNews.detail dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                               documentAttributes:nil error:nil] mutableCopy];
    [self fixFontSizeForAttributeString:attributedText increase:5];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.detailTextView setAttributedText:attributedText];
    });
    
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

