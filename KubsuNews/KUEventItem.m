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
@end
