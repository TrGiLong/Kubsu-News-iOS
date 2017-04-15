//
//  KUUIPersonCell.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUPersonItem.h"
@interface KUUIPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
-(void)setPersonItem:(KUPersonItem*)anItem;
@end
