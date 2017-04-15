//
//  KUFacultyItem.h
//  KubsuNews
//
//  Created by Long on 13.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUInfomationModel : NSObject {

}

-(id)initWithDictionary:(NSDictionary*)aDict;

@property (nonatomic,strong,readonly) NSString *id_item;
@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSString *initials;
@property (nonatomic,strong,readonly) NSString *detail;
@property (nonatomic,strong,readonly) NSURL *logoImageURL;
@property (nonatomic,strong) NSURL *headPersonImageURL;
@property (nonatomic,strong,readonly) NSString *headPersonName;
@property (nonatomic,strong,readonly) NSURL *officialPageVK;
@property (nonatomic,strong,readonly) NSURL *officialInstagram;
@property (nonatomic,strong,readonly) NSString *personPhone;
@end

@interface KUFacultyItem : KUInfomationModel

@end

@interface KUDepartmentItem : KUInfomationModel {
    
}
@property (nonatomic,strong,readonly) NSURL *thumbnailLink;
@end
