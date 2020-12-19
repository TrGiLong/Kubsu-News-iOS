//
//  KUUIFavouriteCell.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUFavouriteItem.h"
@interface KUUIFavouriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLetterLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateAdding;
-(void)setFavouriteItem:(KUFavouriteItem*)item;
@end
