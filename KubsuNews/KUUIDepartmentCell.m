//
//  KUUIDepartmentCell.m
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIDepartmentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation KUUIDepartmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.thumbnailView.layer.cornerRadius = self.thumbnailView.frame.size.width / 2;
    self.thumbnailView.layer.masksToBounds = YES;
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailView.layer.borderWidth = 0.5f;
    self.thumbnailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDepartmentItem:(KUDepartmentItem *)anItem {
    [self.titleLabel setText:anItem.title];
    [self.thumbnailView sd_setImageWithURL:anItem.thumbnailLink];
}

@end
