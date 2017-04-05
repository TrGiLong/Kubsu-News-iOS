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
    if ([item.startDate isInPast]) {
        [self.status setText:@"прошло"];
        [self.status setBackgroundColor:[UIColor grayColor]];
    } else if ([item.startDate isToday]) {
        [self.status setText:@"сегодня"];
        [self.status setBackgroundColor:[UIColor orangeColor]];
    } else {
        [self.status setText:@"скоро"];
        [self.status setBackgroundColor:[UIColor colorWithRed:0.53 green:0.83 blue:0.49 alpha:1.0]];
    }
}

@end
