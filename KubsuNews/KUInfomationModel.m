//
//  KUFacultyItem.m
//  KubsuNews
//
//  Created by Long on 13.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUInfomationModel.h"
#import "KUDataController.h"


@implementation KUInfomationModel

-(id)initWithDictionary:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        _id_item = [aDict objectForKey:@"id"];
        _title = [aDict objectForKey:@"title"];
        _initials = aDict[@"initials"];
        _logoImageURL = [NSURL URLWithString:aDict[@"logo_image"]];
        _detail = aDict[@"description"];
        _headPersonImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/images/static/faculties/%@",SERVER_ADRESS,aDict[@"head_person_photo"]]];
        _officialPageVK = [NSURL URLWithString:aDict[@"official_page_vk"]];
        _officialInstagram = [NSURL URLWithString:aDict[@"official_page_instagram"]];
        _personPhone = aDict[@"phone"];
        _headPersonName = aDict[@"head_person_name"];
    }
    return self;
}

-(NSUInteger)hash {
    return self.id_item.hash;
}
@end

@implementation KUFacultyItem

@end

@implementation KUDepartmentItem {
    
}

-(id)initWithDictionary:(NSDictionary *)aDict {
    self = [super initWithDictionary:aDict];
    if (self) {
        self.headPersonImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/images/static/departments/%@",SERVER_ADRESS,aDict[@"head_person_photo"]]];
        _thumbnailLink =[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/informer/thumbnails/static/departments/%@",SERVER_ADRESS,aDict[@"thumbnail"]]];
    }
    return self;
}
@end
