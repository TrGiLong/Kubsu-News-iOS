//
//  KUUIDepartmentViewController.m
//  KubsuNews
//
//  Created by Long on 15.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIDepartmentViewController.h"
#import "KUUIDepartmentCell.h"
#import "KUUIDepartmentDetailViewController.h"
@interface KUUIDepartmentViewController ()

@end

NSString *const CELL_DEPARTMENT = @"cell_department";


@implementation KUUIDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    dataController = [KUDataController sharedDataController];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUIDepartmentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_DEPARTMENT];
    [self.tableView setRowHeight:88];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataAndUI) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refreshControl];
    
    [self reloadDataAndUI];

    [self setTitle:@"Подразделения"];
}



-(void)reloadDataAndUI {
    [refreshControl beginRefreshing];
    [dataController getListDepartmentBlock:^(NSArray<KUDepartmentItem *> *anItems, NSError *error) {
        items = anItems;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_DEPARTMENT forIndexPath:indexPath];
    [cell setDepartmentItem:items[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIDepartmentDetailViewController *detailView = [[KUUIDepartmentDetailViewController alloc] initWithDepartmentItem:items[indexPath.row]];
    [self.navigationController pushViewController:detailView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
