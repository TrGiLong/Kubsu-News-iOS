//
//  KUUIPersonCell.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIPersonCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation KUUIPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.borderWidth = 0.5f;
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setPersonItem:(KUPersonItem *)anItem {
    [self.headImageView sd_setImageWithURL:anItem.imagePerson];
    [self.nameLabel setText:anItem.name];
    [self.seatLabel setText:anItem.seat];
}


@end
