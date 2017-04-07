//
//  KUUIEventDetailViewController.m
//  KubsuNews
//
//  Created by Giang Long Tran on 02.04.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import "KUUIEventDetailViewController.h"
#import <EventKit/EventKit.h>
@interface KUUIEventDetailViewController ()

@end

@implementation KUUIEventDetailViewController {
    KUEventItem *eventItem;
    KUDataController *dataController;
    
    NSMutableSet *favouriteNews;
    NSMutableSet *favouriteEvent;
}

-(id)initWithEvent:(KUEventItem*)item dataController:(KUDataController*)aDataController {
    self = [super init];
    if (self) {
        eventItem = item;
        dataController = aDataController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:eventItem.title];
    
    NSDateFormatter *dateFormatterOut = [[NSDateFormatter alloc] init];
    [dateFormatterOut setDateFormat:@"dd MMMM yyyy 'в' HH:mm"];
    
    [self.startDateLabel setText:[NSString stringWithFormat:@"Начало: %@", [dateFormatterOut stringFromDate:eventItem.startDate]]];
    [self.endingDateLabel setText:[NSString stringWithFormat:@"Окончание: %@", [dateFormatterOut stringFromDate:eventItem.endDate]]];
    
    [self.placeLabel setText:eventItem.placeName];
    [self.adressButton setTitle:eventItem.placeAdress forState:UIControlStateNormal];
    
    [self.personLabel setText:[eventItem.person length] == 0 ? @"Нет информация" : eventItem.person];
    [self.phoneNumberButton setTitle:[eventItem.phoneNumber length] == 0 ? @"Нет информация" : eventItem.phoneNumber forState:UIControlStateNormal];
    
    if (eventItem.detail == nil) {
        [self.detailLabel setText:@" "];
        
        [dataController getFullEvent:eventItem completion:^(KUEventItem *item) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.detailLabel setText:item.detail];
                [self.loadingDetailActivity stopAnimating];
            });
        }];
    } else {
        [self.loadingDetailActivity stopAnimating];
        [self.detailLabel setText:eventItem.detail];
    }
    
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToCalendar)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.detailDateTimeLabelView addGestureRecognizer:tapGestureRecognizer];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)favorite {

}

-(void)addToCalendar {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = eventItem.title;
        event.startDate = eventItem.startDate; //today
        event.endDate = eventItem.endDate;  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    }];
}

-(void)share {
    NSString *textShare = [NSString stringWithFormat:@"%@\n%@\nОтправлено через #информер_осо",eventItem.title,eventItem.link.absoluteString];;
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAirDrop,UIActivityTypeCopyToPasteboard]; //Exclude whichever aren't relevant
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)phoneClick:(id)sender {
    if ([eventItem.phoneNumber length] > 0) {
        NSString *phoneNumber = [@"tel://" stringByAppendingString:eventItem.phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    
}

- (IBAction)openLink:(id)sender {
    [[UIApplication sharedApplication] openURL:eventItem.link];
}
- (IBAction)adressClick:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@,%@&zoom=14",eventItem.lat,eventItem.lng]]];
    }
}
@end
