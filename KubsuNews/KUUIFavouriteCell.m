//
//  KUUIFavouriteCell.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIFavouriteCell.h"

#import "KUNewsItem.h"
#import "KUEventItem.h"
@implementation KUUIFavouriteCell {
    NSDateFormatter *outDateFormatter;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.firstLetterLabel setTextColor:[UIColor whiteColor]];
    
    outDateFormatter = [[NSDateFormatter alloc] init];
    [outDateFormatter setDateFormat:@"dd MMMM yyyy 'в' HH:mm"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFavouriteItem:(KUFavouriteItem *)item {
    if ([item.item isKindOfClass:[KUNewsItem class]]) {
        [self.title setText:((KUNewsItem*)(item.item)).title];
        [self.firstLetterLabel setText:[[((KUNewsItem*)(item.item)).title substringToIndex:1] uppercaseString]];
    } else if ([item.item isKindOfClass:[KUEventItem class]]) {
        [self.title setText:((KUEventItem*)(item.item)).title];
        [self.firstLetterLabel setText:[[((KUEventItem*)(item.item)).title substringToIndex:1] uppercaseString]];
    }
    [self.dateAdding setText:[NSString stringWithFormat:@"Добавлено: %@",[outDateFormatter stringFromDate:item.addingDate]]];
}
@end
