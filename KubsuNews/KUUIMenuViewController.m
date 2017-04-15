//
//  KUUIMenuViewController.m
//  KubsuNews
//
//  Created by Long on 08.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIMenuViewController.h"

#import "KUMainViewController.h"
#import "KUUINavigationController.h"
#import "KUUILeftViewController.h"

@interface KUUIMenuViewController () {
    KUMainViewController *newsAndEvents;
    KUUINavigationController *newsAndEventsNav;
    
    KUUILeftViewController *leftViewController;
}

@end

@implementation KUUIMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    newsAndEvents = [[KUMainViewController alloc] init];
//    newsAndEventsNav = [[KUUINavigationController alloc] initWithRootViewController:newsAndEvents];
//    
//    [self setRootViewController:newsAndEventsNav];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
