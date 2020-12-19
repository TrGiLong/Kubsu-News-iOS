//
//  KUUIDepartmentDetailViewController.h
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUInfomationModel.h"
@interface KUUIDepartmentDetailViewController : UIViewController

-(id)initWithDepartmentItem:(KUDepartmentItem*)aDepartmentItem;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPersonImageView;
@property (weak, nonatomic) IBOutlet UILabel *namePersonLabel;
- (IBAction)call:(id)sender;
- (IBAction)openVk:(id)sender;
- (IBAction)openInstagram:(id)sender;

@property (weak, nonatomic) IBOutlet UIStackView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *vkButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@end
