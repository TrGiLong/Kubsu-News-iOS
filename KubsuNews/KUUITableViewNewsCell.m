//
//  KUUITableViewNewsCell.m
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUITableViewNewsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation KUUITableViewNewsCell {
    NSDateFormatter *dateFormatter;
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy в HH:mm"];
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 2;
    self.image.layer.masksToBounds = YES;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setNewsItem:(KUNewsItem *)aNews {
    [self.title setText:aNews.title];
    
    [self.image sd_setImageWithURL:aNews.thumbnailLink placeholderImage:[UIImage imageNamed:@"splash_logo"]];
    
    //Date + tag
    [self.info setText:[dateFormatter stringFromDate:aNews.dateTimeInner]];
    [self.category setText:[NSString stringWithFormat:@" %@ ",aNews.category]];
    [self.category setBackgroundColor:[KUUITableViewNewsCell colorFromHexString:aNews.colorStr]];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
