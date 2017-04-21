//
//  KUEventItem.m
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUEventItem.h"
#import "KUDataController.h"

@implementation KUEventItem

-(id)initWithDictionary:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
        [inDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        _idItem = [aDict objectForKey:@"id"];
        _title = [aDict objectForKey:@"title"];
        _startDate = [inDateFormatter dateFromString:[aDict objectForKey:@"start_datetime"]];
        _endDate = [inDateFormatter dateFromString:[aDict objectForKey:@"end_datetime"]];
        _placeAdress = [aDict objectForKey:@"place_addr"];
        _placeName = [aDict objectForKey:@"place_name"];
        _lat = [aDict objectForKey:@"lat"];
        _lng = [aDict objectForKey:@"lng"];
        _link = [NSURL URLWithString:[aDict objectForKey:@"weblink"]];
        _cancel = [[aDict objectForKey:@"canceled"] boolValue];
        _person = [aDict objectForKey:@"person"];
        _phoneNumber = [aDict objectForKey:@"phone"];
    }
    return self;
}
-(void)appendDetail:(NSDictionary *)aDictionary {
    _detail = [aDictionary objectForKey:@"body"];;
}
-(NSUInteger)hash {
    return self.idItem.hash;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super init];
    if (self) {
        _idItem = [aDecoder decodeObjectForKey:@"id"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _startDate = [aDecoder decodeObjectForKey:@"startDate"];
        _endDate = [aDecoder decodeObjectForKey:@"endDate"];
        _placeAdress = [aDecoder decodeObjectForKey:@"placeAdress"];
        _placeName = [aDecoder decodeObjectForKey:@"placeName"];
        _lat = [aDecoder decodeObjectForKey:@"lat"];
        _lng = [aDecoder decodeObjectForKey:@"lng"];
        _person = [aDecoder decodeObjectForKey:@"person"];
        _phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
        _cancel = [[aDecoder decodeObjectForKey:@"cancel"] boolValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idItem forKey:@"id"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.placeAdress forKey:@"placeAdress"];
    [aCoder encodeObject:self.placeName forKey:@"placeName"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.lng forKey:@"lng"];
    [aCoder encodeObject:self.person forKey:@"person"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.cancel] forKey:@"cancel"];
}
@end
