//
//  KUUIPersonsTableViewController.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIPersonsTableViewController.h"
#import "KUUIPersonCell.h"
#import "KUUIPersonDetailViewController.h"
@interface KUUIPersonsTableViewController ()

@end
NSString *const CELL_PERSON = @"cell_person";

@implementation KUUIPersonsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    dataController = [KUDataController sharedDataController];

    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUIPersonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_PERSON];
    [self.tableView setRowHeight:88];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataAndUI) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refreshControl];
    
    
    [self reloadDataAndUI];

    [self setTitle:@"Персоналии"];
}

-(void)reloadDataAndUI {
    [refreshControl beginRefreshing];
    [dataController getListPersonsBlock:^(NSArray<KUPersonItem *> * _Nullable aList, NSError * _Nullable error) {
        items = aList;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    }];
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PERSON forIndexPath:indexPath];
    [cell setPersonItem:items[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIPersonDetailViewController *detailView = [[KUUIPersonDetailViewController alloc] initWithPersonItem:items[indexPath.row]];
    [self.navigationController pushViewController:detailView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
