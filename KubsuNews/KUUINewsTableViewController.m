//
//  KUUINewsTableViewController.m
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUINewsTableViewController.h"
#import "KUUITableViewNewsCell.h"
@interface KUUINewsTableViewController ()

@end

NSString *const CELL_NEWS_ITEM = @"CELL_NEWS_ITEM";
#define DEFAULT_HEIGHT_CELL 88
#define PRELOAD_NEWS_BEFORE_ENDING_LIST 5

@implementation KUUINewsTableViewController {
    UIRefreshControl *refrestControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUITableViewNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_NEWS_ITEM];
    
    refrestControl = [[UIRefreshControl alloc] init];
    [refrestControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..."]];
    [refrestControl addTarget:self action:@selector(refrestNews) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refrestControl];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    items = [NSMutableArray array];
}

-(void)setDataController:(KUDataController *)dataController {
    dataController.delegateNews = self;
    _dataController = dataController;
    [dataController getMoreNewsOffset:0];
}

-(void)refrestNews {
    [self.dataController refrestNews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_HEIGHT_CELL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUITableViewNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_NEWS_ITEM forIndexPath:indexPath];
    [cell setNewsItem:[items objectAtIndex:indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)KUDataController:(KUDataController *)controller receiveNewsList:(NSArray<KUNewsItem *> *)anItems {
    if ([anItems count] > 0) {
        
        NSMutableArray <NSIndexPath*> *listRows = [NSMutableArray arrayWithCapacity:[anItems count]];
        for (NSInteger row = [items count]; row < [anItems count] + [items count]; row++) {
            [listRows addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        [items addObjectsFromArray:anItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:listRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];

        });
    }
}

-(void)KUDataController:(KUDataController *)controller refrestNews:(NSArray<KUNewsItem *> *)anItems {
    [items removeAllObjects];
    [items addObjectsFromArray:anItems];
    [self.tableView reloadData];
    [refrestControl endRefreshing];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= DEFAULT_HEIGHT_CELL * PRELOAD_NEWS_BEFORE_ENDING_LIST) {
        [self.dataController getMoreNewsOffset:[items count]];
    }
}
@end
