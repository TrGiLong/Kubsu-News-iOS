//
//  KUUIDepartmentDetailViewController.m
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIDepartmentDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface KUUIDepartmentDetailViewController ()

@end

@implementation KUUIDepartmentDetailViewController {
    KUDepartmentItem *departmentItem;
}
-(id)initWithDepartmentItem:(KUDepartmentItem *)aDepartmentItem {
    self = [super initWithNibName:@"KUUIDepartmentDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        departmentItem = aDepartmentItem;
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
    
    [self.titleLabel setText:departmentItem.title];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:departmentItem.detail];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [departmentItem.detail length])];
    
    [self.detailLabel setAttributedText:attrText];
    [self.namePersonLabel setText:departmentItem.headPersonName];
    [self.headPersonImageView sd_setImageWithURL:departmentItem.headPersonImageURL placeholderImage:[UIImage imageNamed:@"splash_logo"]];
    
    if ([departmentItem.personPhone length] == 0) {
        [self.phoneButton removeFromSuperview];
    }
    
    if ([[departmentItem.officialPageVK absoluteString] length] == 0) {
        [self.vkButton removeFromSuperview];
    }
    
    if ([[departmentItem.officialInstagram absoluteString] length] == 0) {
        [self.instagramButton removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)call:(id)sender {
    if ([departmentItem.personPhone length] > 0) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:departmentItem.personPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (IBAction)openVk:(id)sender {
    [[UIApplication sharedApplication] openURL:departmentItem.officialPageVK];
}

- (IBAction)openInstagram:(id)sender {
    [[UIApplication sharedApplication] openURL:departmentItem.officialInstagram];
}
@end
