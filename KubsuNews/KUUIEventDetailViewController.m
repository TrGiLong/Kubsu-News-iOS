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

NSString *const FAVOURITE_EVENT = @"Favorite";
NSString *const FAVOURITE_HIGHLIGHT_EVENT = @"Favourite-highlight";


@implementation KUUIEventDetailViewController {
    KUEventItem *eventItem;
    KUDataController *dataController;
    
    UIBarButtonItem *favoriteButton;
    UIBarButtonItem *unFavoriteButton;
    UIBarButtonItem *shareButton;
}

-(id)initWithEvent:(KUEventItem*)item dataController:(KUDataController*)aDataController {
    self = [super initWithNibName:@"KUUIEventDetailViewController" bundle:[NSBundle mainBundle]];
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
    
    [self.personLabel setText:[eventItem.person length] == 0 ? @"Нет информации" : eventItem.person];
    [self.phoneNumberButton setTitle:[eventItem.phoneNumber length] == 0 ? @"Нет информации" : eventItem.phoneNumber forState:UIControlStateNormal];
    
    if (eventItem.detail == nil) {
        [self.detailLabel setText:@" "];
        
        [dataController getFullEvent:eventItem completion:^(KUEventItem *item, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс!" message:@"Произошла ошибка подключения" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.loadingDetailActivity stopAnimating];
                    }];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];

                } else {
                    [self.detailLabel setText:item.detail];
                    [self.loadingDetailActivity stopAnimating];
                }
            });
        }];
    } else {
        [self.loadingDetailActivity stopAnimating];
        [self.detailLabel setText:eventItem.detail];
    }
    
    favoriteButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:FAVOURITE_EVENT] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    unFavoriteButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:FAVOURITE_HIGHLIGHT_EVENT] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
    shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    if ([dataController isInFavourite:eventItem]) {
        [self.navigationItem setRightBarButtonItems:@[shareButton,unFavoriteButton]];
    } else {
        [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];
    }

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToCalendar)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.detailDateTimeLabelView addGestureRecognizer:tapGestureRecognizer];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)favorite {
    if ([dataController isInFavourite:eventItem]) {
        [dataController removeItemFromFavourite:eventItem];
        [self.navigationItem setRightBarButtonItems:@[shareButton,favoriteButton]];
    } else {
        [dataController addItemIntoFavourite:eventItem];
        [self.navigationItem setRightBarButtonItems:@[shareButton, unFavoriteButton]];
    }
}

-(void)addToCalendar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:eventItem.title message:@"Вы хотите добавить в календарь?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отменить" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Добавить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:addAction];
    [self presentViewController:alert animated:YES completion:nil];

    
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
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/maps/place/%@,%@",eventItem.lat,eventItem.lng]]];
    }
}
@end
