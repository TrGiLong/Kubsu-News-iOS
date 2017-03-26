//
//  KUNewsController.m
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUDataController.h"

@implementation KUDataController : NSObject {
    
    NSURLSession *newsConnection;
    NSMutableData *receiveDataForListNews;
    NSURLSession *sessionListNews;;
    NSURLSessionDataTask *dataTaskNews;
    NSURLSessionDataTask *refrestNews;
    
    NSOperationQueue *queue;
    
}


-(instancetype)init {
    self = [super init];
    if (self) {
        queue = [[NSOperationQueue alloc] init];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionListNews = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    }
    return self;
}

#define VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define TIME_STAMP [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]
NSString *const DATA_TYPE = @"items";
NSString *const CLIENT = @"kubsu_app";
NSString *const PLATFORM = @"kubsu_app";
NSString *const NUM = @"20";
NSString *const NEWS = @"0";
NSString *const SERVER_ADRESS = @"77.246.159.212";

-(void)getNews {
    NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=0&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,DATA_TYPE,CLIENT,PLATFORM,NUM,TIME_STAMP,NEWS,VERSION];

    NSURLSessionDataTask *dataTask = [sessionListNews dataTaskWithURL:[NSURL URLWithString:urlStr]];
    [dataTask resume];
}

-(void)getMoreNewsOffset:(NSUInteger)offset {
    if (dataTaskNews == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%lu&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,DATA_TYPE,CLIENT,PLATFORM,NUM,(unsigned long)offset,TIME_STAMP,NEWS,VERSION];
        
        dataTaskNews = [sessionListNews dataTaskWithURL:[NSURL URLWithString:urlStr]];
        [dataTaskNews resume];
    }
}

-(void)refrestNews {
    if (refrestNews == nil) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=%d&timestamp=%@&case=%@&version=%@",SERVER_ADRESS,DATA_TYPE,CLIENT,PLATFORM,NUM,0,TIME_STAMP,NEWS,VERSION];
        
        refrestNews = [sessionListNews dataTaskWithURL:[NSURL URLWithString:urlStr]];
        [refrestNews resume];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    if (session == sessionListNews) {
        receiveDataForListNews = nil;
        receiveDataForListNews = [[NSMutableData alloc] init];
        [receiveDataForListNews setLength:0];
    }

    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (session == sessionListNews) {
        [receiveDataForListNews appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        // Handle error
    } else {
        if (session == sessionListNews) {
            NSError *tempError;
            NSDictionary* response=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:receiveDataForListNews options:kNilOptions error:&tempError];
            if (task == dataTaskNews) {
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                    [[response objectForKey:ITEMS] count] > 0) {
                    [self.delegateNews KUDataController:self receiveNewsList:[self parseListNews:response]];
                }
                dataTaskNews = nil;
            } else if (task == refrestNews) {
                if ([self.delegateNews conformsToProtocol:@protocol(KUNewsControllerDataSource)] &&
                    [[response objectForKey:ITEMS] count] > 0) {
                    [self.delegateNews KUDataController:self refrestNews:[self parseListNews:response]];
                }
                refrestNews = nil;
            }

        }
    }
}

NSString *const ITEMS = @"ITEMS";

-(NSArray<KUNewsItem*>*)parseListNews:(NSDictionary*)dataDict {
    NSMutableArray *list = [NSMutableArray array];
    NSArray *items = [dataDict objectForKey:ITEMS];
    for (NSDictionary *item in items) {
        KUNewsItem *newsItem = [[KUNewsItem alloc] initWithDictionary:item];
        if (newsItem) {
            [list addObject:newsItem];
        }
    }
    return list;
}
@end
