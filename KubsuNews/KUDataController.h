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


@protocol KUNewsDetailControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveNewsDetail:(KUNewsItem*)item;
@end

@interface KUDataController : NSObject <NSURLSessionDelegate>
-(void)clearCacheNews;
-(void)getMoreNewsOffset:(NSUInteger)offset;
-(void)getNumberOfNews;

-(void)getFullNews:(KUNewsItem*)item;

@property (nonatomic,weak) id <KUNewsControllerDataSource> delegateNews;
@property (nonatomic,weak) id <KUNewsDetailControllerDataSource> delegateDetailNews;

@end
