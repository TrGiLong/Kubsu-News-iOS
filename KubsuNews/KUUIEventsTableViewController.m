//
//  KUUIEventsTableViewController.m
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIEventsTableViewController.h"
#import "KUUIEventDetailViewController.h"
#import "KUUIEventsCell.h"

@interface KUUIEventsTableViewController ()

@end

NSString *const CELL_EVENTS = @"cell_events";
#define DEFAULT_HEIGHT_CELL 88
#define PRELOAD_NEWS_BEFORE_ENDING_LIST 5

@implementation KUUIEventsTableViewController {
    NSUInteger numberOfEvents;
    UIRefreshControl *refrestControl;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Мероприятие";
    }
    return self;
}

-(id)initWithDataController:(KUDataController*)aDataController delegate:(id <KUInteractionViewControllerProtocol>)aDelegate {
    self = [super init];
    if (self) {
        self.title = @"Мероприятие";
        
        [self.tableView setRowHeight:88];
        
        dataController = aDataController;
        dataController.delegateEvents = self;
        delegate = aDelegate;
        
        refrestControl = [[UIRefreshControl alloc] init];
        [refrestControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading..."]];
        [refrestControl addTarget:self action:@selector(refrestEvents) forControlEvents:UIControlEventValueChanged];
        [self.tableView setRefreshControl:refrestControl];
        
        
        items = [NSMutableArray array];
        if (dataController != nil) {
            [refrestControl beginRefreshing];
            [self refrestEvents];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KUUIEventsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_EVENTS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_EVENTS forIndexPath:indexPath];
    [cell setEvent:[items objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(void)refrestEvents {
    numberOfEvents = 0;
    [dataController getNumberOfType:KUTypeDataEvents];
}

-(void)KUDataController:(KUDataController *)controller numberOfEvents:(NSUInteger)aNumberOfEvents {
    numberOfEvents = aNumberOfEvents;
    [dataController getMoreOffset:0 forType:KUTypeDataEvents];
}

-(void)KUDataController:(KUDataController *)controller receiveEventsList:(NSArray<KUEventItem *> *)anItems {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KUUIEventDetailViewController *detail = [[KUUIEventDetailViewController alloc] initWithEvent:items[indexPath.row]dataController:dataController];
    if ([delegate respondsToSelector:@selector(viewController:present:completion:)]) {
        [delegate viewController:self present:detail completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if ([items count] < numberOfEvents && (maximumOffset - currentOffset <= DEFAULT_HEIGHT_CELL * PRELOAD_NEWS_BEFORE_ENDING_LIST)) {
        [dataController getMoreOffset:[items count] forType:KUTypeDataEvents];
    }
}
@end
