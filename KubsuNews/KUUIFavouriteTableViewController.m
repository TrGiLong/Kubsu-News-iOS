//
//  KUUIFavouriteTableViewController.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIFavouriteTableViewController.h"
#import "KUUIFavouriteCell.h"
#import "KUUIDetailNewsViewController.h"
#import "KUUIEventDetailViewController.h"
@interface KUUIFavouriteTableViewController () {
    NSArray <UIColor*> *colors;
}

@end
#define CELL @"favourite"
@implementation KUUIFavouriteTableViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    dataController = [KUDataController sharedDataController];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUIFavouriteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL];
    [self.tableView setRowHeight:88];
    
    self.title = @"Избранное";
    
    colors = @[[UIColor colorWithRed:0.53 green:0.83 blue:0.49 alpha:1.0],
               [UIColor colorWithRed:0.88 green:0.51 blue:0.51 alpha:1.0],
               [UIColor colorWithRed:0.40 green:0.20 blue:0.60 alpha:1.0],
               [UIColor colorWithRed:0.91 green:0.83 blue:0.38 alpha:1.0],
               [UIColor colorWithRed:0.13 green:0.65 blue:0.94 alpha:1.0],
               [UIColor colorWithRed:0.25 green:0.76 blue:0.50 alpha:1.0],
               [UIColor colorWithRed:0.92 green:0.59 blue:0.31 alpha:1.0],
               [UIColor colorWithRed:0.95 green:0.66 blue:0.63 alpha:1.0]];

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    items = [dataController listFavouriteByData];
    [self.tableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    [cell setFavouriteItem:items[indexPath.row]];
    NSUInteger selectColor = indexPath.row;
    
    while (selectColor >= [colors count]) {
        selectColor -= [colors count];
    }
    [cell.circleView setBackgroundColor:colors[selectColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *detailVC;
    if ([items[indexPath.row].item isKindOfClass:[KUNewsItem class]]) {
        KUNewsItem *itemNews = (KUNewsItem*)items[indexPath.row].item;
        detailVC = [[KUUIDetailNewsViewController alloc] initWithNibName:@"KUUIDetailNewsViewController" bundle:[NSBundle mainBundle] news:itemNews dataController:dataController];
    } else if ([items[indexPath.row].item isKindOfClass:[KUEventItem class]]) {
        detailVC = [[KUUIEventDetailViewController alloc] initWithEvent:(KUEventItem*)items[indexPath.row].item dataController:dataController];
    }
     [self.navigationController pushViewController:detailVC animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
