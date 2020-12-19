//
//  KUFavouriteItem.m
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUFavouriteItem.h"

@implementation KUFavouriteItem

+(instancetype)item:(id)anItem {
    return [[KUFavouriteItem alloc] initWithItem:anItem];
}

-(id)initWithItem:(id)anItem {
    self = [super init];
    if (self) {
        _item = anItem;
        _addingDate = [NSDate date];
    }
    return self;
}
-(NSUInteger)hash {
    return self.item.hash;
}
-(BOOL)isEqual:(id)object {
    return ((NSObject*)object).hash == self.hash;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self =  [super init];
    if (self) {
        _addingDate = [aDecoder decodeObjectForKey:@"addingDate"];
        _item = [aDecoder decodeObjectForKey:@"item"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.addingDate forKey:@"addingDate"];
    [aCoder encodeObject:self.item forKey:@"item"];
}
@end
