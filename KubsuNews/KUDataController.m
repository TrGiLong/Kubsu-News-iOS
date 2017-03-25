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
    
    NSOperationQueue *queue;
    
}

-(id)initWithDelegate:(id <KUNewsControllerDataSource>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
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
NSString *const DATA_TYPE = @"items";
NSString *const CLIENT = @"kubsu_app";
NSString *const PLATFORM = @"kubsu_app";
NSString *const NUM = @"10";
NSString *const NEWS = @"0";
NSString *const SERVER_ADRESS = @"77.246.159.212";

-(void)getNews {
    NSString *formatURLStr = [NSString stringWithFormat:@"http://%@/informer/get.php?datatype=%@&client=%@&platform=%@&num=%@&offset=10&timestamp=1490178283&case=%@&version=%@",SERVER_ADRESS,DATA_TYPE,CLIENT,PLATFORM,NUM,NEWS,VERSION];
    NSLog(@"%@",formatURLStr);

    NSURLSessionDataTask *dataTask = [sessionListNews dataTaskWithURL:[NSURL URLWithString:formatURLStr]];
    [dataTask resume];
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
            if ([self.delegate respondsToSelector:@selector(KUDataController:receiveNewsList:)]) {
                [self.delegate KUDataController:self receiveNewsList:[self parseListNews:response]];
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
