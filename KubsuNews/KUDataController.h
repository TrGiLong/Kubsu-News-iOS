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
#import "KUPersonItem.h"
#import "KUInfomationModel.h"
#import "KUFavouriteItem.h"
@class KUDataController;

FOUNDATION_EXPORT NSString *const SERVER_ADRESS;

typedef NS_ENUM(NSInteger, KUTypeData) {
    KUTypeDataNews,
    KUTypeDataEvents
};

@protocol KUNewsControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveNewsList:(NSArray <KUNewsItem*>*)items;
-(void)KUDataController:(KUDataController*)controller numberOfNews:(NSUInteger)numberOfNews;
-(void)KUDataController:(KUDataController*)controller newsError:(NSError*)error;
@end

@protocol KUEventsControllerDataSource <NSObject>
-(void)KUDataController:(KUDataController*)controller receiveEventsList:(NSArray <KUEventItem*>*)items;
-(void)KUDataController:(KUDataController*)controller numberOfEvents:(NSUInteger)numberOfEvents;
-(void)KUDataController:(KUDataController*)controller eventError:(NSError*)error;
@end

@interface KUDataController : NSObject <NSURLSessionDelegate>

+ (id)sharedDataController;

-(void)clearCache:(KUTypeData)aType;
-(NSArray*)getOldForTypeData:(KUTypeData)aType;

-(void)getMoreOffset:(NSUInteger)offset forType:(KUTypeData)aType;
-(void)getNumberOfType:(KUTypeData)aType;

-(void)getFullNews:(KUNewsItem*)item completion:(void (^ __nullable)(KUNewsItem*, NSError* _Nullable error))completion;
-(void)getFullEvent:(KUEventItem*)event completion:(void (^ __nullable)(KUEventItem*, NSError* _Nullable error))completion;

-(void)getListFacultyBlock:(void (^ __nullable)(NSArray <KUFacultyItem*> * _Nullable aList, NSError* _Nullable error))completion;
-(void)getListDepartmentBlock:(void (^ __nullable)(NSArray<KUDepartmentItem *> * _Nullable aList, NSError* _Nullable error))completion;
-(void)getListPersonsBlock:(void (^ __nullable)(NSArray<KUPersonItem *> * _Nullable aList, NSError* _Nullable error))completion;

-(void)addItemIntoFavourite:(NSObject*)anItem;
-(void)removeItemFromFavourite:(NSObject*)anItem;
-(BOOL)isInFavourite:(NSObject*)anItem;
-(NSArray<KUFavouriteItem*>*)listFavouriteByData;

@property (nonatomic,weak) id <KUNewsControllerDataSource> delegateNews;
@property (nonatomic,weak) id <KUEventsControllerDataSource> delegateEvents;

@end
