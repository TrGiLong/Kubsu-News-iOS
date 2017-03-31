//
//  KUInteractionViewControllerProtocol.h
//  KubsuNews
//
//  Created by Giang Long Tran on 27.03.17.
//  Copyright © 2017 darkTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KUInteractionViewControllerProtocol <NSObject>
-(void)viewController:(UIViewController* _Nullable)viewControlle present:(UIViewController*_Nonnull)presentViewController completion:(void (^ __nullable)(void))completion;

@end
