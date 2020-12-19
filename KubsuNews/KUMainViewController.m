//
//  KUMainViewController.m
//  KubsuNews
//
//  Created by Giang Long Tran on 27.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUMainViewController.h"
#import "KUUINewsTableViewController.h"
#import "KUUIEventsTableViewController.h"
#import "KUUINavigationController.h"

#import "UIViewController+LGSideMenuController.h"
@interface KUMainViewController ()

@end

@implementation KUMainViewController{
    KUUINewsTableViewController *newsTableView;
    KUUIEventsTableViewController *eventsTableView;
    KUDataController *dataController;
    
    NSArray <UIViewController*> *views;
}

- (void)viewDidLoad {
    dataController = [KUDataController sharedDataController];
    
    self.title = @"Информер ОСО";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
    newsTableView = [[KUUINewsTableViewController alloc] initWithDataController:dataController delegate:self];
    eventsTableView = [[KUUIEventsTableViewController alloc] initWithDataController:dataController delegate:self];
    views = @[newsTableView,eventsTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(leftMene)];
    
    [super viewDidLoad];
    
    [self setDataSource:self]; 
    
}

-(void)leftMene {
    [self showLeftViewAnimated:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

-(void)viewController:(UIViewController *)viewController present:(UIViewController *)presentViewController completion:(void (^)(void))completion {
    [self.navigationController pushViewController:presentViewController animated:YES];
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

#pragma mark - pageView
-(NSInteger)numberOfViewControllers {
    return 2;
}
-(UIViewController *)viewControllerForIndex:(NSInteger)index {
    return views[index];
}

-(NSString *)titleForTabAtIndex:(NSInteger)index {
    return views[index].title;
}

- (UIColor *)tabColor {
    return [UIColor whiteColor];
}
- (UIColor *)tabBackgroundColor {
    return [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
}

- (UIColor *)titleColor {
    return [UIColor whiteColor];
}

-(UIFont *)titleFont {
    return [UIFont systemFontOfSize:17];
}
@end
