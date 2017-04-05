//
//  KUNewsController.h
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUNewsItem.h"
#import "KUEventItem.h"
@class KUDataController;

FOUNDATION_EXPORT NSString *const SERVER_ADRESS;

typedef NS_ENUM(NSInteger, KUTypeData) {
    KUTypeDataNews,
    KUTypeDataEvents
};

@protocol KUNewsControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveNewsList:(NSArray <KUNewsItem*>*)items;
-(void)KUDataController:(KUDataController*)controller numberOfNews:(NSUInteger)numberOfNews;
@end

@protocol KUEventsControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveEventsList:(NSArray <KUEventItem*>*)items;
-(void)KUDataController:(KUDataController*)controller numberOfEvents:(NSUInteger)numberOfEvents;
@end



@protocol KUNewsDetailControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveNewsDetail:(KUNewsItem*)item;
@end

@interface KUDataController : NSObject <NSURLSessionDelegate>
-(void)clearCache:(KUTypeData)aType;
-(NSArray*)getOldForTypeData:(KUTypeData)aType;
-(void)getMoreOffset:(NSUInteger)offset forType:(KUTypeData)aType;
-(void)getNumberOfType:(KUTypeData)aType;

-(void)getFullNews:(KUNewsItem*)item;

-(void)getFullEvent:(KUEventItem*)event completion:(void (^ __nullable)(KUEventItem*))completion;

@property (nonatomic,weak) id <KUNewsControllerDataSource> delegateNews;
@property (nonatomic,weak) id <KUEventsControllerDataSource> delegateEvents;
@property (nonatomic,weak) id <KUNewsDetailControllerDataSource> delegateDetailNews;

@end
