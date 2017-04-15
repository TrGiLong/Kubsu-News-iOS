//
//  KUUIPersonsTableViewController.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
@interface KUUIPersonsTableViewController : UITableViewController {
    NSArray <KUPersonItem*> *items;
    KUDataController *dataController;
    UIRefreshControl *refreshControl;
}

@end
