//
//  CHSwipeInteractionController.h
//  CHFlingingViewController
//
//  Created by Chris Hetem on 4/14/14.
//  Copyright (c) 2014 croberth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHSwipeInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interactionInProgress;
@property (assign, nonatomic) CGFloat threshold;
-(void)wireToViewController:(UIViewController *)viewController;

@end
