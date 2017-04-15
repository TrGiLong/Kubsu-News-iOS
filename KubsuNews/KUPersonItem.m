//
//  KUPersonItem.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUPersonItem.h"
#import "KUDataController.h"
@implementation KUPersonItem
-(id)initWithDictionary:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        _idItem = aDict[@"id"];
        _name = aDict[@"name"];
        _seat = aDict[@"seat"];
        _detail = aDict[@"description"];
        _imagePerson = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/images/static/persons/%@",SERVER_ADRESS,aDict[@"image"]]];
        
    }
    return self;
}

-(NSUInteger)hash {
    return self.idItem.hash;
}
@end
