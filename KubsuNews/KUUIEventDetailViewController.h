//
//  KUUIEventDetailViewController.h
//  KubsuNews
//
//  Created by Giang Long Tran on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
#import <BFPaperView/BFPaperView.h>
@interface KUUIEventDetailViewController : UIViewController

-(id)initWithEvent:(KUEventItem*)item dataController:(KUDataController*)dataController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *detailDateTimeLabelView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endingDateLabel;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITextView *detailLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingDetailActivity;

@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
- (IBAction)phoneClick:(id)sender;
- (IBAction)openLink:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIButton *adressButton;
- (IBAction)adressClick:(id)sender;


@end

