//
//  KUUIPersonDetailViewController.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIPersonDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface KUUIPersonDetailViewController ()

@end

@implementation KUUIPersonDetailViewController

-(id)initWithPersonItem:(KUPersonItem*)aPersonItem {
    self = [super initWithNibName:@"KUUIPersonDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        personItem = aPersonItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.borderWidth = 2.f;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSMutableAttributedString *attributedText = [[[NSAttributedString alloc] initWithData:[personItem.detail dataUsingEncoding:NSUTF8StringEncoding]
                                                                                  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                            NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                       documentAttributes:nil error:nil] mutableCopy];
    [self fixFontSizeForAttributeString:attributedText increase:6];
    [self.nameLabel setText:personItem.name];
    [self.seatLabel setText:personItem.seat];
    [self.headImageView sd_setImageWithURL:personItem.imagePerson];
    [self.detailLabel setAttributedText:attributedText];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fixFontSizeForAttributeString:(NSMutableAttributedString*)attrib increase:(CGFloat)incSize {
    [attrib beginEditing];
    [attrib enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attrib.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            UIFont *oldFont = (UIFont *)value;
            
            [attrib removeAttribute:NSFontAttributeName range:range];
            [attrib addAttribute:NSFontAttributeName value:[oldFont fontWithSize:oldFont.pointSize + incSize] range:range];
        }
    }];
    [attrib endEditing];
    
}
@end
