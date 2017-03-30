//
//  KUUIDetailNewsViewController.h
//  KubsuNews
//
//  Created by Long on 28.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"

@interface KUUIDetailNewsViewController : UIViewController  <KUNewsDetailControllerDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *author;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil news:(KUNewsItem*)aNews dataController:(KUDataController*)dataController;
@end

