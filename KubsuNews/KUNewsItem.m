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

-(void)appendDetail:(NSDictionary *)aDictionary {
    _detail = [aDictionary objectForKey:@"body"];
}
-(NSUInteger)hash {
    return self.id_item.hash;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super init];
    if (self) {
        _id_item = [aDecoder decodeObjectForKey:@"id"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _thumbnailLink = [aDecoder decodeObjectForKey:@"thumbnailLink"];
        _imageLink = [aDecoder decodeObjectForKey:@"imageLink"];
        _webLink = [aDecoder decodeObjectForKey:@"webLink"];
        _dateTimeInner = [aDecoder decodeObjectForKey:@"dateTimeInner"];
        _publisher = [aDecoder decodeObjectForKey:@"publisher"];
        _category = [aDecoder decodeObjectForKey:@"category"];
        _colorStr = [aDecoder decodeObjectForKey:@"colorStr"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id_item forKey:@"id"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.thumbnailLink forKey:@"thumbnailLink"];
    [aCoder encodeObject:self.imageLink forKey:@"imageLink"];
    [aCoder encodeObject:self.webLink forKey:@"webLink"];
    [aCoder encodeObject:self.dateTimeInner forKey:@"dateTimeInner"];
    [aCoder encodeObject:self.publisher forKey:@"publisher"];
    [aCoder encodeObject:self.category forKey:@"category"];
    [aCoder encodeObject:self.colorStr forKey:@"colorStr"];
}

@end
