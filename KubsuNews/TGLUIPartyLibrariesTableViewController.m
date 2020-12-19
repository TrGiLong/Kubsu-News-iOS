//
//  TGLUIPartyLibrariesTableViewController.m
//  KubsuNews
//
//  Created by Long on 18.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "TGLUIPartyLibrariesTableViewController.h"
#import "TGLUIPartyLicenseCell.h"
@interface TGLUIPartyLibrariesTableViewController ()

@end

@implementation TGLUIPartyLibrariesTableViewController {
    NSDictionary *libraries;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    libraries = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Libraries_License" ofType:@"plist"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TGLUIPartyLicenseCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [libraries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[libraries allKeys] objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TGLUIPartyLicenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.licenseLabel setText:[libraries objectForKey:[[libraries allKeys] objectAtIndex:indexPath.section]]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
