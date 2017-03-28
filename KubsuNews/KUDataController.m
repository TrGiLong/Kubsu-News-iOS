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
    NSMutableData *receiveDataOfNews;
    NSMutableData *receiveDataForNumberNews;
    NSURLSessionDataTask *newsDataTask;
    NSURLSessionDataTask *numberOfNewsTask;
    
    NSOperationQueue *queue;
    
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
#define TIME_STAMP [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]
NSString *const ITEMS = @"items";
NSString *const COUNT = @"count";
NSString *const CLIENT = @"kubsu_app";
NSString *const PLATFORM = @"kubsu_app";
NSString *const NUM = @"20";
NSString *const CASE_NEWS = @"0";
NSString *const SERVER_ADRESS = @"77.246.159.212";

-(void)getNumberOfNews {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,COUNT,CLIENT,PLATFORM,TIME_STAMP,CASE_NEWS,VERSION];
    
    NSURLSessionDataTask *dataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr]];
    [dataTask resume];
}

-(void)getMoreNewsOffset:(NSUInteger)offset {
    if (newsDataTask == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,ITEMS,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,CASE_NEWS,VERSION];
        
        newsDataTask = [sessionNews dataTaskWithURL:[NSURL URLWithString:urlStr]];
        [newsDataTask resume];
    }
}

-(void)clearCacheNews {
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    if (session == sessionNews) {
        if (dataTask == newsDataTask) {
            receiveDataOfNews = nil;
            receiveDataOfNews = [[NSMutableData alloc] init];
            [receiveDataOfNews setLength:0];
        } else if (dataTask == numberOfNewsTask) {
            receiveDataForNumberNews = nil;
            receiveDataForNumberNews = [[NSMutableData alloc] init];
            [receiveDataForNumberNews setLength:0];
        }

    }

    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (session == sessionNews) {
        if (session == sessionNews) {
            if (dataTask == newsDataTask) {
                [receiveDataOfNews appendData:data];
            } else if (dataTask == numberOfNewsTask) {
                [receiveDataForNumberNews appendData:data];
            }
        }
    }
}

NSString *const ITEMS_PARSE = @"ITEMS";
NSString *const COUNT_PARSE = @"COUNT";
NSString *const RESULT_PARSE = @"RESULT";
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        // Handle error
    } else {
        if (session == sessionNews) {

            NSError *tempError;
            NSDictionary* response=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:receiveDataOfNews options:kNilOptions error:&tempError];
            if (task == newsDataTask) {
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                    [[response objectForKey:ITEMS_PARSE] count] > 0) {
                    [self.delegateNews KUDataController:self receiveNewsList:[self parseListNews:response]];
                }
                newsDataTask = nil;
            } else if (task == numberOfNewsTask) {
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                    [[response objectForKey:ITEMS_PARSE] count] > 0) {
                    [self.delegateNews KUDataController:self numberOfNews:[[[response objectForKey:COUNT_PARSE] objectForKey:RESULT_PARSE] unsignedIntegerValue]];
                }
                numberOfNewsTask = nil;
            }
        }
    }
}

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
@end
