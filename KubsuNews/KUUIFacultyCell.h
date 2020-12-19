//
//  KUUIFacultyCell.h
//  KubsuNews
//
//  Created by Giang Long Tran on 13.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUInfomationModel.h"
@interface KUUIFacultyCell : UITableViewCell

-(void)setFacultyItem:(KUFacultyItem*)item;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *circleColor;
@property (weak, nonatomic) IBOutlet UILabel *initialsLabel;

@end
