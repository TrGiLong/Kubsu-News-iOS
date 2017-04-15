//
//  KUUIDepartmentCell.h
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUInfomationModel.h"
@interface KUUIDepartmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)setDepartmentItem:(KUDepartmentItem*)anItem;
@end
