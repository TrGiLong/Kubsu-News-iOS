//
//  KUMainViewController.m
//  KubsuNews
//
//  Created by Giang Long Tran on 27.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUMainViewController.h"
#import "KUUINewsTableViewController.h"
#import <XLPagerTabStrip/FXPageControl.h>
@interface KUMainViewController ()

@end

@implementation KUMainViewController{
    KUUINewsTableViewController *newsTableView;
    KUDataController *dataController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataController = [[KUDataController alloc] init];
    
    newsTableView = [[KUUINewsTableViewController alloc] initWithDataController:dataController delegate:self];
    [newsTableView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:newsTableView.view];
      
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (newsTableView == nil) {
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}

-(void)viewController:(UIViewController *)viewController present:(UIViewController *)presentViewController completion:(void (^)(void))completion {
    [self.navigationController pushViewController:presentViewController animated:YES];
    NSLog(@"%@",viewController.title);
    if (viewController.title !=nil) {
        [presentViewController.navigationItem.backBarButtonItem setTitle:viewController.title];
    }
        if (completion != NULL) {
        completion();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
