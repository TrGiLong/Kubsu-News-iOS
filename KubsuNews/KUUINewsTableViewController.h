//
//  KUUINewsTableViewController.h
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KUNewsItem.h"
@interface KUUINewsTableViewController : UITableViewController {
    NSArray <KUNewsItem*> *items;
}

-(void)setItems:(NSArray <KUNewsItem*>*) anItems;

@end
