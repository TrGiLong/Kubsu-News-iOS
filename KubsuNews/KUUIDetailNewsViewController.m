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
#import <Vertigo/TGRImageViewController.h>
#import <Vertigo/TGRImageZoomAnimationController.h>
@interface KUUIDetailNewsViewController  () <GSKStretchyHeaderViewStretchDelegate>

@end

NSString *const FAVOURITE = @"Favorite";
NSString *const FAVOURITE_HIGHLIGHT = @"Favourite-highlight";

@implementation KUUIDetailNewsViewController 
{
    GSKStretchyHeaderView *headerView;
    UIImage *loadingImage;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIBarButtonItem *favoriteButton;
    UIBarButtonItem *unFavoriteButton;
    UIBarButtonItem *shareButton;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil news:(KUNewsItem *)aNews dataController:(KUDataController *)aDataController{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        news = aNews;
        dataController = aDataController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    headerView = [[GSKStretchyHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 200)];
    headerView.minimumContentHeight = 0;
    headerView.userInteractionEnabled = YES;
    headerView.stretchDelegate = self;
    [self.scrollView addSubview:headerView];
    
    // Loading image
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)]];
    
    loadingImage = [UIImage imageNamed:@"splash_logo"];
    [imageView setImage:loadingImage];
    
    [imageView sd_setImageWithURL:news.imageLink];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [headerView addSubview:imageView];
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsTable = @{@"imageView":imageView};
    NSArray *htableViewCs = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView(>=0)]-0-|" options:0 metrics:NULL views:viewsTable];
    [headerView addConstraints:htableViewCs];
    
    NSArray *vTextViewCs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(>=0)]-0-|" options:0 metrics:NULL views:viewsTable];
    [headerView addConstraints:vTextViewCs];
    // ========================
    
    favoriteButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:FAVOURITE] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    unFavoriteButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:FAVOURITE_HIGHLIGHT] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    if ([dataController isInFavourite:news]) {
        [self.navigationItem setRightBarButtonItems:@[shareButton,unFavoriteButton]];
    } else {
        [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];
    }
    

    
    [self.titleLabel setText:news.title];
    [self.author setText:[NSString stringWithFormat:@"Опубликовал(а) %@,\nчлен Пресс-центра ОСО КубГУ",news.publisher]];
    
    if (news.detail == nil) {
        [self setDetailText:@" "];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(CGRectGetMidX(self.detailTextView.bounds), self.detailTextView.bounds.size.height/2);
        activityIndicator.hidesWhenStopped = YES;
        [self.detailTextView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [dataController getFullNews:news completion:^(KUNewsItem *item, NSError * _Nullable error) {
            if (!error) {
                [self setDetailText:item.detail];
                [activityIndicator stopAnimating];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Произошла ошибка подключения" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [activityIndicator stopAnimating];
                }];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        
    } else {
        [self setDetailText:news.detail];
    }
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
    if ([dataController isInFavourite:news]) {
        [dataController removeItemFromFavourite:news];
        [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];
    } else {
        [dataController addItemIntoFavourite:news];
        [self.navigationItem setRightBarButtonItems:@[shareButton, unFavoriteButton]];
    }
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
}

-(void)fixFontSizeForAttributeString:(NSMutableAttributedString*)attrib increase:(CGFloat)incSize {
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            
            [attrib removeAttribute:NSFontAttributeName range:range];
            [attrib addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:oldFont.pointSize + incSize] range:range];
        }
    }];
    [attrib endEditing];
    
}

#pragma mark - header

-(void)stretchyHeaderView:(GSKStretchyHeaderView *)headerView didChangeStretchFactor:(CGFloat)stretchFactor {
    
}

#pragma mark - present image
-(void)showImage {
    TGRImageViewController *fullScreenImage = [[TGRImageViewController alloc] initWithImage:imageView.image];
    fullScreenImage.transitioningDelegate = self;
    
    [self presentViewController:fullScreenImage animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:imageView];
    }
    return nil;
}


@end

