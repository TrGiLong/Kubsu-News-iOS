//
//  KUUIFacultyViewController.h
//  KubsuNews
//
//  Created by Giang Long Tran on 10.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
@interface KUUIFacultyViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSArray <KUFacultyItem*> *items;
    KUDataController *dataController;
    
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
