//
//  KUPersonItem.h
//  KubsuNews
//
//  Created by Long on 16.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUPersonItem : NSObject
-(id)initWithDictionary:(NSDictionary*)aDict;
@property (nonatomic,strong,readonly) NSString *idItem;
@property (nonatomic,strong,readonly) NSString *detail;
@property (nonatomic,strong,readonly) NSString *name;
@property (nonatomic,strong,readonly) NSString *seat;
@property (nonatomic,strong,readonly) NSURL *imagePerson;
@end
