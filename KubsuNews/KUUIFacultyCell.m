//
//  KUUIFacultyCell.m
//  KubsuNews
//
//  Created by Giang Long Tran on 13.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIFacultyCell.h"

@implementation KUUIFacultyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.circleColor.layer.cornerRadius = self.circleColor.frame.size.width / 2;
    self.circleColor.layer.masksToBounds = YES;
    self.circleColor.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.initialsLabel setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFacultyItem:(KUFacultyItem *)item {
    [self.titleLabel setText:item.title];
    [self.initialsLabel setText:item.initials];
}

@end
