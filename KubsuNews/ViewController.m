//
//  ViewController.m
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "ViewController.h"

#import "KUUINewsTableViewController.h"
@interface ViewController ()

@end

@implementation ViewController {
    KUUINewsTableViewController *newsTableView;
    KUDataController *dataController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataController = [[KUDataController alloc] initWithDelegate:self];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (newsTableView == nil) {
        newsTableView = [[KUUINewsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [newsTableView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:newsTableView.view];
        
        
        [dataController getNews];
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)KUDataController:(KUDataController*)controller receiveNewsList:(NSArray <KUNewsItem*>*)items {
    [newsTableView setItems:items];
}
@end
