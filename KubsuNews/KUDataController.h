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
@end

@interface KUDataController : NSObject <NSURLSessionDelegate>
-(id)initWithDelegate:(id <KUNewsControllerDataSource>)delegate;
-(void)getNews;

@property (nonatomic,weak) id <KUNewsControllerDataSource> delegate;
@end
