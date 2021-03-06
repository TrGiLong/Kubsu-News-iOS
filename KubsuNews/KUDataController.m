//
//  KUNewsController.m
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUDataController.h"

@implementation KUDataController {
    
    NSURLSession *sessionNews;
    
    NSURLSessionDataTask *newsDataTask;
    NSURLSessionDataTask *numberOfNewsTask;
    
    NSURLSessionDataTask *eventsDataTask;
    NSURLSessionDataTask *numberOfEventsTask;
    
    NSURLSessionDataTask *listFacultyTask;
    NSURLSessionDataTask *listDepartmentsTask;
    NSURLSessionDataTask *listPersonsTask;
    
    NSOperationQueue *queue;
    
    NSArray *cache_list_news;
    
    NSMutableSet <KUFavouriteItem*> *favouriteList;
}

NSString *const FAVOURITE_SET = @"favouriteSet";

-(instancetype)init {
    self = [super init];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionNews = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
        
        NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
        if ([userDf objectForKey:FAVOURITE_SET]) {
            favouriteList = [NSKeyedUnarchiver unarchiveObjectWithData:[userDf objectForKey:FAVOURITE_SET]];
        } else {
            favouriteList = [NSMutableSet set];
        }
        
    }
    return self;
}

-(NSArray<KUFavouriteItem *> *)listFavouriteByData {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"addingDate" ascending:YES];
    return [favouriteList sortedArrayUsingDescriptors:@[sort]];
}


+ (id)sharedDataController {
    static KUDataController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define BUILD [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define TIME_STAMP [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]
NSString *const ITEMS = @"items";
NSString *const COUNT = @"count";
NSString *const CLIENT = @"kubsu_app";
NSString *const PLATFORM = @"ios";
NSString *const NUM = @"20";
NSString *const CASE_NEWS = @"0";
NSString *const CASE_EVENTS = @"1";
NSString *const CASE_FACULTY = @"2";
NSString *const CASE_DEPARTMENT = @"3";
NSString *const CASE_PERSON = @"4";
NSString *const SERVER_ADRESS = @"77.246.159.212";



-(void)getNumberOfType:(KUTypeData)aType {
    switch (aType) {
        case KUTypeDataNews: {
            [self getNumberOfNews];
            break;
        }
        case KUTypeDataEvents: {
            [self getNumberOfEvents];
            break;
        }
    }
}

-(void)getMoreOffset:(NSUInteger)offset forType:(KUTypeData)aType {
    switch (aType) {
        case KUTypeDataNews: {
            [self getMoreNewsOffset:offset];
            break;
        }
        case KUTypeDataEvents: {
            [self getMoreEventsOffset:offset];
            break;
        }
    }
}

#pragma mark - News

-(NSString*)getVersionRequest {
    return [NSString stringWithFormat:@"%ld",(long)([VERSION doubleValue] * 100000 + [BUILD integerValue])];
}

-(void)getNumberOfNews {
    if (numberOfNewsTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,COUNT,CLIENT,PLATFORM,TIME_STAMP,CASE_NEWS,[self getVersionRequest]];
        
        numberOfNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict;
            if (!error) {
                if (data != nil) {
                    dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
                    if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] & !tempError) {
                        NSString *value = [[dataDict objectForKey:COUNT_PARSE] objectForKey:RESULT_PARSE];
                        [self.delegateNews KUDataController:self numberOfNews:[value integerValue]]; //unsigned value here. Fix next
                    } else {
                        [self.delegateNews KUDataController:self newsError:tempError];
                    }
                }
            } else {
                 [self.delegateNews KUDataController:self newsError:error];
            }
            numberOfNewsTask = nil;
        }];
        [numberOfNewsTask resume];
    }
}

-(void)getMoreNewsOffset:(NSUInteger)offset {
    if (newsDataTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,CASE_NEWS,[self getVersionRequest]];
        
        newsDataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict;
            if (!error) {
                if (data != nil) {
                    dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
                    if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                        [[dataDict objectForKey:ITEMS_PARSE] count] > 0 && !tempError) {
                        [self.delegateNews KUDataController:self receiveNewsList:[self parseListNews:dataDict]];
                        newsDataTask = nil;
                    } else {
                        [self.delegateEvents KUDataController:self eventError:error];
                    }
                }
            } else {
                [self.delegateEvents KUDataController:self eventError:error];
            }
        }];
        [newsDataTask resume];
    }
}

-(NSArray *)getOldNews {
    return nil;
}

-(void)clearCacheNews {
    
}

NSString *const ITEMS_PARSE = @"ITEMS";
NSString *const COUNT_PARSE = @"COUNT";
NSString *const RESULT_PARSE = @"result";

-(NSArray<KUNewsItem*>*)parseListNews:(NSDictionary*)dataDict {
    NSMutableArray *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS_PARSE];
    for (NSDictionary *item in items) {
        KUNewsItem *newsItem = [[KUNewsItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}

NSString *const TEXT = @"text";
NSString *const TEXT_PARSE = @"TEXT";

-(void)getFullNews:(KUNewsItem *)item completion:(void (^ _Nullable)(KUNewsItem *, NSError * _Nullable))completion{
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&version=%@&id=%@",SERVER_ADRESS,TEXT,CLIENT,PLATFORM,VERSION,item.id_item]
    ;
    
    NSURLSessionDataTask *detailNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        if (!error) {
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            [item appendDetail:[[dataDict objectForKey:TEXT_PARSE] firstObject]];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(item,nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
        }
    }];
    [detailNewsTask resume];
}

#pragma mark - Events

-(void)getNumberOfEvents {
    if (numberOfEventsTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,COUNT,CLIENT,PLATFORM,TIME_STAMP,CASE_EVENTS,VERSION];
        
        numberOfEventsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            if (data !=nil) {
                NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] && !tempError) {
                    NSString *value = [[dataDict objectForKey:COUNT_PARSE] objectForKey:RESULT_PARSE];
                    [self.delegateEvents KUDataController:self numberOfEvents:[value integerValue]]; //unsigned value here. Fix next
                } else {
                    [self.delegateEvents KUDataController:self eventError:tempError];
                }
            } else if (error) {
                [self.delegateEvents KUDataController:self eventError:error];
            }
            numberOfEventsTask = nil;
        }];
        [numberOfEventsTask resume];
    }
}

-(void)getMoreEventsOffset:(NSUInteger)offset {
    if (eventsDataTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,CASE_EVENTS,[self getVersionRequest]];
        
        eventsDataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict;
            if (data !=nil) {
                dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] && !tempError) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegateEvents KUDataController:self receiveEventsList:[self parseListEvents:dataDict]];
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegateEvents KUDataController:self eventError:tempError];
                    });
                }
            } else if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegateEvents KUDataController:self eventError:error];
                });
            }
            eventsDataTask = nil;
        }];
        [eventsDataTask resume];
    }
}

-(NSArray<KUEventItem*>*)parseListEvents:(NSDictionary*)dataDict {
    NSMutableArray <KUEventItem*> *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS_PARSE];
    for (NSDictionary *item in items) {
        KUEventItem *newsItem = [[KUEventItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}

-(void)getFullEvent:(KUEventItem *)event  completion:(void (^ __nullable)(KUEventItem*, NSError* _Nullable error))completion {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&version=%@&id=%@",SERVER_ADRESS,TEXT,CLIENT,PLATFORM,[self getVersionRequest],event.idItem]
    ;
    
    NSURLSessionDataTask *detailNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        if (!error) {
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            [event appendDetail:[[dataDict objectForKey:TEXT_PARSE] firstObject]];
            
            if (completion != NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(event,error);
                });
            }
        } else {
            completion(nil,error);
        }
        
    }];
    [detailNewsTask resume];
}

#pragma mark - Faculty Item

-(void)getListFacultyBlock:(void (^)(NSArray<KUFacultyItem *> * _Nullable, NSError * _Nullable))completion {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,CASE_FACULTY,[self getVersionRequest]];
    
    listFacultyTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *tempError;
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateEvents conformsToProtocol:@protocol(KUEventsControllerDataSource)] &&
                [[dataDict objectForKey:ITEMS_PARSE] count] > 0) {
                completion([self parseListFaculty:dataDict], nil);
                listFacultyTask = nil;
            }
        } else {
            completion(nil,error);
        }
        
    }];
    [listFacultyTask resume];
    
}

-(NSArray <KUFacultyItem*>*)parseListFaculty:(NSDictionary*)dataDict {
    NSMutableArray <KUFacultyItem*> *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS_PARSE];
    for (NSDictionary *item in items) {
        KUFacultyItem *newsItem = [[KUFacultyItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}

#pragma mark - Department Item


-(void)getListDepartmentBlock:(void (^)(NSArray<KUDepartmentItem *> *, NSError*))completion {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,CASE_DEPARTMENT,[self getVersionRequest]];
    
    listDepartmentsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        if (!error) {
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateEvents conformsToProtocol:@protocol(KUEventsControllerDataSource)] &&
                [[dataDict objectForKey:ITEMS_PARSE] count] > 0) {
                completion([self parseListDepartment:dataDict], error != nil ? error : tempError);
                listDepartmentsTask = nil;
            }
        } else {
            completion(nil, error);
        }
        
    }];
    [listDepartmentsTask resume];

}

-(NSArray <KUDepartmentItem*>*)parseListDepartment:(NSDictionary*)dataDict {
    NSMutableArray <KUDepartmentItem*> *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS_PARSE];
    for (NSDictionary *item in items) {
        KUDepartmentItem *newsItem = [[KUDepartmentItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}
#pragma mark - List Person
-(void)getListPersonsBlock:(void (^)(NSArray<KUPersonItem *> * _Nullable, NSError * _Nullable))completion {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,CASE_PERSON,[self getVersionRequest]];
    
    listPersonsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        if (!error) {
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateEvents conformsToProtocol:@protocol(KUEventsControllerDataSource)] &&
                [[dataDict objectForKey:ITEMS_PARSE] count] > 0) {
                completion([self parseListPerson:dataDict], error != nil ? error : tempError);
                listPersonsTask = nil;
            }
        } else {
            completion(nil,error);
        }
        
    }];
    [listPersonsTask resume];

}

-(NSArray <KUPersonItem*>*)parseListPerson:(NSDictionary*)dataDict {
    NSMutableArray <KUPersonItem*> *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS_PARSE];
    for (NSDictionary *item in items) {
        KUPersonItem *newsItem = [[KUPersonItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}

#pragma mark - Favourite
-(void)addItemIntoFavourite:(NSObject *)anItem {
    [favouriteList addObject:[[KUFavouriteItem alloc] initWithItem:anItem]];
    [self saveFavouriteSet];
}

-(void)removeItemFromFavourite:(NSObject*)anItem {
    [favouriteList removeObject:anItem];
    [self saveFavouriteSet];
}

-(BOOL)isInFavourite:(NSObject *)anItem {
    return [favouriteList containsObject:anItem];
}

-(void)saveFavouriteSet {
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:[NSKeyedArchiver archivedDataWithRootObject:favouriteList] forKey:FAVOURITE_SET];
}
@end
