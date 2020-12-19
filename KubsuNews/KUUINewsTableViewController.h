//
//  KUUINewsTableViewController.h
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KUDataController.h"
#import "KUInteractionViewControllerProtocol.h"
@interface KUUINewsTableViewController : UITableViewController <KUNewsControllerDataSource> {
    NSMutableArray <KUNewsItem*> *items;
    
}

-(id)initWithDataController:(KUDataController*)dataController delegate:(id <KUInteractionViewControllerProtocol>)delegate;

@property (nonatomic,strong) KUDataController *dataController;

@end
