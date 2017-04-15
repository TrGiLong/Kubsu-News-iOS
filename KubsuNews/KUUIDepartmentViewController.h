//
//  KUUIDepartmentViewController.h
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
@interface KUUIDepartmentViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSArray <KUDepartmentItem*> *items;
    KUDataController *dataController;
    
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
