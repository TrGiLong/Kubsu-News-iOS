//
//  KUMainViewController.h
//  KubsuNews
//
//  Created by Giang Long Tran on 27.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUInteractionViewControllerProtocol.h"
#import <GUITabPagerViewController/GUITabPagerViewController.h>
@interface KUMainViewController : GUITabPagerViewController <KUInteractionViewControllerProtocol,GUITabPagerDataSource>

@end
