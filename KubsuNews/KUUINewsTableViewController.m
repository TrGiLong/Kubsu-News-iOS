//
//  KUUINewsTableViewController.m
//  KubsuNews
//
//  Created by Long on 25.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUINewsTableViewController.h"
#import "KUUITableViewNewsCell.h"
#import "KUUIDetailNewsViewController.h"

@interface KUUINewsTableViewController ()

@end

NSString *const CELL_NEWS_ITEM = @"CELL_NEWS_ITEM";
#define DEFAULT_HEIGHT_CELL 88
#define PRELOAD_NEWS_BEFORE_ENDING_LIST 5

@implementation KUUINewsTableViewController {
    UIRefreshControl *refrestControl;
    id <KUInteractionViewControllerProtocol> delegate;
    NSUInteger numberOfNews;
    
}

-(id)initWithDataController:(KUDataController *)dataController delegate:(id)aDelegate {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Новости";
        
        _dataController = dataController;
        dataController.delegateNews = self;
        delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUITableViewNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_NEWS_ITEM];
    
    refrestControl = [[UIRefreshControl alloc] init];
    [refrestControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..."]];
    [refrestControl addTarget:self action:@selector(refrestNews) forControlEvents:UIControlEventValueChanged];
    [self.tableView setRefreshControl:refrestControl];
    
    items = [NSMutableArray array];
    if (self.dataController != nil) {
        [self refrestNews];
    }
}

-(void)setDataController:(KUDataController *)dataController {
    dataController.delegateNews = self;
    _dataController = dataController;
    [self refrestNews];
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
    if ([delegate conformsToProtocol:@protocol(KUInteractionViewControllerProtocol)]) {
        KUNewsItem *itemNews = [items objectAtIndex:indexPath.row];
        KUUIDetailNewsViewController *detailVC = [[KUUIDetailNewsViewController alloc] initWithNibName:@"KUUIDetailNewsViewController" bundle:[NSBundle mainBundle] news:itemNews dataController:self.dataController];
        if ([delegate conformsToProtocol:@protocol(KUInteractionViewControllerProtocol)]) {
            [delegate viewController:self present:detailVC completion:nil];
    
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)KUDataController:(KUDataController *)controller numberOfNews:(NSUInteger)anNumberOfNews {
    numberOfNews = anNumberOfNews;
    [self.dataController getMoreOffset:0 forType:KUTypeDataNews];
}

-(void)KUDataController:(KUDataController *)controller receiveNewsList:(NSArray<KUNewsItem *> *)anItems {
    if ([anItems count] > 0) {
        
        if ([refrestControl isRefreshing]) {
            [items removeAllObjects];
            [items addObjectsFromArray:anItems];
            [self.tableView reloadData];
            [refrestControl endRefreshing];
        } else {
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
}

-(void)refrestNews {
    numberOfNews = 0;
    [self.dataController getNumberOfType:KUTypeDataNews];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ([items count] < numberOfNews && (maximumOffset - currentOffset <= DEFAULT_HEIGHT_CELL * PRELOAD_NEWS_BEFORE_ENDING_LIST)) {
        [self.dataController getMoreOffset:[items count] forType:KUTypeDataNews];
    }
}
@end
