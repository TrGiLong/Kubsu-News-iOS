//
//  KUUIEventsTableViewController.h
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDataController.h"
#import "KUInteractionViewControllerProtocol.h"
@interface KUUIEventsTableViewController : UITableViewController <KUEventsControllerDataSource> {
    KUDataController *dataController;
    id <KUInteractionViewControllerProtocol> delegate;
    NSMutableArray <KUEventItem*> *items;
}

-(id)initWithDataController:(KUDataController*)dataController delegate:(id <KUInteractionViewControllerProtocol>)delegate;

@end
