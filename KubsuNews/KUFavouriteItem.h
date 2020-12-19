//
//  KUFavouriteItem.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUFavouriteItem : NSObject <NSCoding>
+(instancetype)item:(id)anItem;
-(id)initWithItem:(id)anItem;
@property (nonatomic,strong,readonly) NSObject *item;
@property (nonatomic,strong,readonly) NSDate *addingDate;
@end
