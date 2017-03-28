//
//  KUInteractionViewControllerProtocol.h
//  KubsuNews
//
//  Created by Giang Long Tran on 27.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KUInteractionViewControllerProtocol <NSObject>
-(void)viewController:(UIViewController*)viewControlle present:(UIViewController*)presentViewController completion:(void (^ __nullable)(void))completion;

@end
