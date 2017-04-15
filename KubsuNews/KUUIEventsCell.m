//
//  KUUIEventsCell.m
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIEventsCell.h"
#import "NSDate+Utilities.h"
@implementation KUUIEventsCell {
    NSDateFormatter *outDateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    outDateFormatter = [[NSDateFormatter alloc] init];
    [outDateFormatter setDateFormat:@"dd MMMM yyyy 'в' HH:mm"];
    
    
    [self.status setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEvent:(KUEventItem *)item {
    [self.title setText:item.title];
    [self.place setText:item.placeName];
    
    [self.dateStart setText:[outDateFormatter stringFromDate:item.startDate]];
    if (item.cancel) {
        [self.status setText:@"отменено"];
        [self.status setBackgroundColor:[UIColor grayColor]];
    } else {
        if ([item.startDate isInPast]) {
            if ([item.endDate isInFuture]) {
                [self.status setText:@"идёт"];
                [self.status setBackgroundColor:[UIColor colorWithRed:0.95 green:0.61 blue:0.07 alpha:1.0]];
            } else {
                [self.status setText:@"прошло"];
                [self.status setBackgroundColor:[UIColor grayColor]];
            }
        } else if ([item.startDate isToday]) {
            [self.status setText:@"сегодня"];
            [self.status setBackgroundColor:[UIColor orangeColor]];
        } else {
            if ([item.startDate isTomorrow]) {
                [self.status setText:@"завтра"];
                [self.status setBackgroundColor:[UIColor colorWithRed:0.10 green:0.71 blue:1.00 alpha:1.0]];
                
            } else {
                [self.status setText:@"скоро"];
                [self.status setBackgroundColor:[UIColor colorWithRed:0.00 green:0.69 blue:0.42 alpha:1.0]];
            }
            
        }
    }
}

@end
