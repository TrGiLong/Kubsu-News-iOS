//
//  KUUIFacultyDetailViewController.m
//  KubsuNews
//
//  Created by Long on 13.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIFacultyDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface KUUIFacultyDetailViewController ()

@end

@implementation KUUIFacultyDetailViewController {
    KUFacultyItem *facultyItem;
}

-(id)initWithFacultyItem:(KUFacultyItem *)aFalcutyItem {
    self = [super initWithNibName:@"KUUIFacultyDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        facultyItem = aFalcutyItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headPersonImageView.layer.cornerRadius = self.headPersonImageView.frame.size.width / 2;
    self.headPersonImageView.layer.masksToBounds = YES;
    self.headPersonImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headPersonImageView.layer.borderWidth = 1.5f;
    self.headPersonImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    
    [self.titleLabel setText:facultyItem.title];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:facultyItem.detail];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [facultyItem.detail length])];
    
    [self.detailLabel setAttributedText:attrText];
    [self.namePersonLabel setText:facultyItem.headPersonName];
    [self.headPersonImageView sd_setImageWithURL:facultyItem.headPersonImageURL placeholderImage:[UIImage imageNamed:@"splash_logo"]];
    
    if ([facultyItem.personPhone length] == 0) {
        [self.phoneButton removeFromSuperview];
    }
    
    if ([[facultyItem.officialPageVK absoluteString] length] == 0) {
        [self.vkButton removeFromSuperview];
    }
    
    if ([[facultyItem.officialInstagram absoluteString] length] == 0) {
        [self.instagramButton removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)call:(id)sender {
    if ([facultyItem.personPhone length] > 0) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:facultyItem.personPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (IBAction)openVk:(id)sender {
    [[UIApplication sharedApplication] openURL:facultyItem.officialPageVK];
}

- (IBAction)openInstagram:(id)sender {
    [[UIApplication sharedApplication] openURL:facultyItem.officialInstagram];
}
@end
