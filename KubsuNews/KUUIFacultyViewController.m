//
//  KUUIFacultyViewController.m
//  KubsuNews
//
//  Created by Giang Long Tran on 10.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIFacultyViewController.h"
#import "KUUIFacultyCell.h"
#import "KUUIFacultyDetailViewController.h"
@interface KUUIFacultyViewController () {
    NSArray <UIColor*> *colors;
}

@end

NSString *const CELL_FACULTY = @"cell_faculty";

@implementation KUUIFacultyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    colors = @[[UIColor colorWithRed:0.53 green:0.83 blue:0.49 alpha:1.0],
               [UIColor colorWithRed:0.88 green:0.51 blue:0.51 alpha:1.0],
               [UIColor colorWithRed:0.40 green:0.20 blue:0.60 alpha:1.0],
               [UIColor colorWithRed:0.91 green:0.83 blue:0.38 alpha:1.0],
               [UIColor colorWithRed:0.13 green:0.65 blue:0.94 alpha:1.0],
               [UIColor colorWithRed:0.25 green:0.76 blue:0.50 alpha:1.0],
               [UIColor colorWithRed:0.92 green:0.59 blue:0.31 alpha:1.0],
               [UIColor colorWithRed:0.95 green:0.66 blue:0.63 alpha:1.0]];
    
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];

    dataController = [KUDataController sharedDataController];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUIFacultyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_FACULTY];
    [self.tableView setRowHeight:88];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDataAndUI) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refreshControl];
    
    [refreshControl beginRefreshing];
    [self reloadDataAndUI];

}



-(void)reloadDataAndUI {

    [dataController getListFacultyBlock:^(NSArray<KUFacultyItem *> *anItems) {
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
    KUUIFacultyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_FACULTY forIndexPath:indexPath];
    [cell setFacultyItem:items[indexPath.row]];
    
    NSUInteger selectColor = indexPath.row;
    while (selectColor >= [colors count]) {
        selectColor -= [colors count];
    }
    [cell.circleColor setBackgroundColor:colors[selectColor]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIFacultyDetailViewController *detailView = [[KUUIFacultyDetailViewController alloc] initWithFacultyItem:items[indexPath.row]];
    [self.navigationController pushViewController:detailView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
