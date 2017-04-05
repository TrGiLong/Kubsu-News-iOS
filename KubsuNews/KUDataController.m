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
    
    NSOperationQueue *queue;
    
    NSArray *cache_list_news;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionNews = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return self;
}

//#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define VERSION @"1080"
#define TIME_STAMP [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]
NSString *const ITEMS = @"items";
NSString *const COUNT = @"count";
NSString *const CLIENT = @"kubsu_app";
NSString *const PLATFORM = @"ios";
NSString *const NUM = @"20";
NSString *const CASE_NEWS = @"0";
NSString *const CASE_EVENTS = @"1";
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

#pragma mark - news

-(void)getNumberOfNews {
    if (numberOfNewsTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,COUNT,CLIENT,PLATFORM,TIME_STAMP,CASE_NEWS,VERSION];
        
        numberOfNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)]) {
                NSString *value = [[dataDict objectForKey:COUNT_PARSE] objectForKey:RESULT_PARSE];
                [self.delegateNews KUDataController:self numberOfNews:[value integerValue]]; //unsigned value here. Fix next
                numberOfNewsTask = nil;
            }
        }];
        [numberOfNewsTask resume];
    }
}

-(void)getMoreNewsOffset:(NSUInteger)offset {
    if (newsDataTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,CASE_NEWS,VERSION];
        
        newsDataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                [[dataDict objectForKey:ITEMS_PARSE] count] > 0) {
                [self.delegateNews KUDataController:self receiveNewsList:[self parseListNews:dataDict]];
                newsDataTask = nil;
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

#pragma mark - detail news

NSString *const TEXT = @"text";
NSString *const TEXT_PARSE = @"TEXT";

-(void)getFullNews:(KUNewsItem *)item {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&version=%@&id=%@",SERVER_ADRESS,TEXT,CLIENT,PLATFORM,VERSION,item.id_item]
    ;
    
    NSURLSessionDataTask *detailNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
        [item appendDetail:[[dataDict objectForKey:TEXT_PARSE] firstObject]];
        [self.delegateDetailNews KUDataController:self receiveNewsDetail:item];
        
    }];
    [detailNewsTask resume];
}

#pragma mark - events

-(void)getNumberOfEvents {
    if (numberOfEventsTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,COUNT,CLIENT,PLATFORM,TIME_STAMP,CASE_EVENTS,VERSION];
        
        numberOfEventsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)]) {
                
                NSString *value = [[dataDict objectForKey:COUNT_PARSE] objectForKey:RESULT_PARSE];
                [self.delegateEvents KUDataController:self numberOfEvents:[value integerValue]]; //unsigned value here. Fix next
                numberOfEventsTask = nil;
            }
            
        }];
        [numberOfEventsTask resume];
    }
}

-(void)getMoreEventsOffset:(NSUInteger)offset {
    if (eventsDataTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,CASE_EVENTS,VERSION];
        
        eventsDataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSError *tempError;
            NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
            if ([self.delegateEvents conformsToProtocol:@protocol(KUEventsControllerDataSource)] &&
                [[dataDict objectForKey:ITEMS_PARSE] count] > 0) {
                [self.delegateEvents KUDataController:self receiveEventsList:[self parseListEvents:dataDict]];
                eventsDataTask = nil;
            }
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

-(void)getFullEvent:(KUEventItem *)event completion:(void (^)(KUEventItem *))completion {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&version=%@&id=%@",SERVER_ADRESS,TEXT,CLIENT,PLATFORM,VERSION,event.idItem]
    ;
    
    NSURLSessionDataTask *detailNewsTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *tempError;
        NSDictionary *dataDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&tempError];
        [event appendDetail:[[dataDict objectForKey:TEXT_PARSE] firstObject]];
        
        if (completion != NULL) {
            completion(event);
        }
        
    }];
    [detailNewsTask resume];
}
@end
