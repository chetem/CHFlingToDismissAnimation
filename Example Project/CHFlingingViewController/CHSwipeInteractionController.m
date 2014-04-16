//
//  CHSwipeInteractionController.m
//  CHFlingingViewController
//
//  Created by Chris Hetem on 4/14/14.
//  Copyright (c) 2014 croberth. All rights reserved.
//

#import "CHSwipeInteractionController.h"

@implementation CHSwipeInteractionController
{
	BOOL _shouldCompleteTransition;
	UIViewController *_viewController;
}

-(void)wireToViewController:(UIViewController *)viewController
{
	_viewController = viewController;
	[self prepareGestureRecognizerInView:viewController.view];
}

-(void)prepareGestureRecognizerInView:(UIView *)view
{
	UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
	[view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
	return 1-self.percentComplete;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
	CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
	
	switch (gestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:{
			//start an interactive transition
			self.interactionInProgress = YES;
			
			self.threshold = (self.threshold > 0) ? self.threshold : 0.25;
			
			[_viewController dismissViewControllerAnimated:YES completion:nil];
		}
			break;
			
		case UIGestureRecognizerStateChanged:{
			//compute the current position
			CGFloat fraction = -(translation.y / 300.0);
			fraction = fminf(fmaxf(fraction, 0.0), 1.0);
			
			//complete transition?
			_shouldCompleteTransition = (fraction > self.threshold) ? YES : NO;
			
			//update the animation
			[self updateInteractiveTransition:fraction];
			break;
		}
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			//finish or cancel
			self.interactionInProgress = NO;
			if(!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
				[self cancelInteractiveTransition];
			}else{
				[self finishInteractiveTransition];
			}
			break;
			
			
		default:
			break;
	}
}


@end
