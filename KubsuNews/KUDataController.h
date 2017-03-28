//
//  KUNewsController.h
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUNewsItem.h"
@class KUDataController;

FOUNDATION_EXPORT NSString *const SERVER_ADRESS;

@protocol KUNewsControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveNewsList:(NSArray <KUNewsItem*>*)items;
-(void)KUDataController:(KUDataController*)controller numberOfNews:(NSUInteger)numberOfNews;
@end

@interface KUDataController : NSObject <NSURLSessionDelegate>
-(void)clearCacheNews;
-(void)getMoreNewsOffset:(NSUInteger)offset;
-(void)getNumberOfNews;

@property (nonatomic,weak) id <KUNewsControllerDataSource> delegateNews;
@end
