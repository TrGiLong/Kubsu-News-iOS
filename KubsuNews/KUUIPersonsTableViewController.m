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
    [self setRefreshControl:refreshControl];
    
    
    [self reloadDataAndUI];

    [self setTitle:@"Персоналии"];
}

-(void)reloadDataAndUI {
    [refreshControl beginRefreshing];
    [dataController getListPersonsBlock:^(NSArray<KUPersonItem *> * _Nullable aList, NSError * _Nullable error) {
        items = aList;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self.tableView reloadData];
                [refreshControl endRefreshing];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Произошла ошибка подключения" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [refreshControl endRefreshing];
                }];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
          
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
    if ([items count] == 0) {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text             = @"Нет данных";
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        [noDataLabel setFont:[UIFont systemFontOfSize:18]];
        self.tableView.backgroundView = noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
