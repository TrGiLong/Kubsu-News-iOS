//
//  KUUIEventsCell.h
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUEventItem.h"
@interface KUUIEventsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *dateStart;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;

@property (weak, nonatomic) IBOutlet UIImageView *calendarIcon;
-(void)setEvent:(KUEventItem*)item;
@end
