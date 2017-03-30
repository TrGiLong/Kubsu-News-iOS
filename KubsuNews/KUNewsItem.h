//
//  KUNewsItem.h
//  KubsuNews
//
//  Created by Long on 23.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUNewsItem : NSObject

-(id)initWithDictionary:(NSDictionary*)aDictionary;
-(void)appendDetail:(NSDictionary*)aDictionary;

@property (nonatomic,strong,readonly) NSString *id_item;
@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSString *detail;
@property (nonatomic,strong,readonly) NSURL *thumbnailLink;
@property (nonatomic,strong,readonly) NSURL *imageLink;
@property (nonatomic,strong,readonly) NSURL *webLink;
@property (nonatomic,strong,readonly) NSDate *dateTimeInner;
@property (nonatomic,strong,readonly) NSString *publisher;
@property (nonatomic,strong,readonly) NSString *category;
@property (nonatomic,strong,readonly) NSString *colorStr;

//@property (nonatomic,strong,readonly) NSDate *datetimeDisplayable;
//@property (nonatomic,strong,readonly) NSDate *deadlineDisplayable;

@end
