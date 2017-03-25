//
//  KUNewsItem.m
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUNewsItem.h"
#import "KUDataController.h"

NSString *const THUMBNAILS = @"thumbnails";
NSString *const IMAGES = @"images";

@implementation KUNewsItem
-(id)initWithDictionary:(NSDictionary *)aDictionary {
    self = [super init];
    if (self) {
        _id_item = [aDictionary objectForKey:@"id"];
        _title = [aDictionary objectForKey:@"title"];
        _thumbnailLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/%@/%@",SERVER_ADRESS,THUMBNAILS,self.id_item]];
        _imageLink = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/%@/%@",SERVER_ADRESS,IMAGES,self.id_item]];
        _webLink = [NSURL URLWithString:[aDictionary objectForKey:@"weblink"]];
        _dateTimeInner = [NSDate dateWithTimeIntervalSince1970:[[aDictionary objectForKey:@"timestamp"] doubleValue]];
        _publisher = [aDictionary objectForKey:@"publisher"];
        _category = [aDictionary objectForKey:@"category_name"];
        _colorStr = [aDictionary objectForKey:@"category_bg_color"];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"id = %@ \n title = %@ \n publisher = %@ \n thumbnail link = %@ \n image link = %@",self.id_item, self.title, self.publisher, [self.thumbnailLink absoluteString], [self.imageLink absoluteString]];
}
@end
