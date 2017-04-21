//
//  KUUIDepartmentViewController.h
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
@interface KUUIDepartmentViewController : UITableViewController {
    NSArray <KUDepartmentItem*> *items;
    KUDataController *dataController;
    
    UIRefreshControl *refreshControl;
}

@end
