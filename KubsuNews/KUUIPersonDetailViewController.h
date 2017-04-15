//
//  KUUIPersonDetailViewController.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUPersonItem.h"

@interface KUUIPersonDetailViewController : UIViewController {
    KUPersonItem *personItem;
}

-(id)initWithPersonItem:(KUPersonItem*)aPersonItem;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailLabel;

@end
