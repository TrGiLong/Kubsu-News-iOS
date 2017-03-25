//
//  KUUINavigationController.m
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUINavigationController.h"

@interface KUUINavigationController ()

@end

@implementation KUUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0]];
    self.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
