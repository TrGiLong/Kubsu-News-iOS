//
//  KUEventItem.h
//  KubsuNews
//
//  Created by Long on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUEventItem : NSObject

-(id)initWithDictionary:(NSDictionary*)aDict;

@property (nonatomic,strong,readonly) NSString *idItem;
@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSDate *startDate;
@property (nonatomic,strong,readonly) NSDate *endDate;
@property (nonatomic,strong,readonly) NSString *placeAdress;
@property (nonatomic,strong,readonly) NSString *placeName;

@property (nonatomic,strong,readonly) NSString *lat;
@property (nonatomic,strong,readonly) NSString *lng;

@property (nonatomic,strong,readonly) NSURL *link;
@property (nonatomic,strong,readonly) NSString *detail;

@property (nonatomic,readonly) BOOL cancel;
@property (nonatomic,strong,readonly) NSString *person;
@property (nonatomic,strong,readonly) NSString *phoneNumber;

@property (nonatomic,strong) NSString *calendarId;


-(void)appendDetail:(NSDictionary*)aDictionary;
@end
