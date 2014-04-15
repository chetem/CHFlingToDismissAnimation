//
//  CHFlingToDismissAnimationController.m
//  CHFlingingViewController
//
//  Created by Chris Hetem on 4/14/14.
//  Copyright (c) 2014 croberth. All rights reserved.
//

#import "CHFlingToDismissAnimationController.h"

//if no animationDuration set, fall back to default 0.5
#define DURATION	(self.animationDuration > 0) ? self.animationDuration : 0.5


@implementation CHFlingToDismissAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return DURATION;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	//get toViewController and fromViewController from transition context
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	//set the finalFrame to use the frame of the 'toViewController'
	//(i.e. the view that will show after dismissal)
	CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
	
	//get container view from context
	UIView *containerView = [transitionContext containerView];
	
	//set frame of 'toViewController' to be it's final frame too, since it's not moving
	//also set alpha for cooler effects
	toViewController.view.frame = finalFrame;
	toViewController.view.alpha = 0.5;
	
	//add 'toViewController' to container view and send it to back so it is ready to view after dismissal
	[containerView addSubview:toViewController.view];
	[containerView sendSubviewToBack:toViewController.view];
	
	//create rotation animation
	CGAffineTransform rotation = fromViewController.view.transform;
	rotation = [self useRandomRotation];
	
	//create a snapshot of imageview to use for the animation
	UIView *snapShotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
	snapShotView.frame = fromViewController.view.frame;
	
	//remove actual view controller since we're animating the snapshot
	[fromViewController.view removeFromSuperview];
	
	//get the final frame of where you want the snapshot to end up after the animation is complete
	CGRect snapShotViewFinalFrame = CGRectOffset(snapShotView.frame, 0, -(snapShotView.frame.size.height));
	
	//add snap shot of image view to container view
	[containerView addSubview:snapShotView];
	
	//animate with key frames
	[UIView animateKeyframesWithDuration:DURATION
								   delay:0.0
								 options:UIViewKeyframeAnimationOptionCalculationModeLinear
							  animations:^{
								  //add key frame to fade out view controller view
								  [UIView addKeyframeWithRelativeStartTime:0.0
														  relativeDuration:0.2
																animations:^{
																	fromViewController.view.alpha = 0.0;
																}];
								  //add key frame to move and rotate image view (snap shot)
								  [UIView addKeyframeWithRelativeStartTime:0.0
														  relativeDuration:1.0
																animations:^{
																	snapShotView.frame = snapShotViewFinalFrame;
																	snapShotView.transform = CGAffineTransformConcat(snapShotView.transform, rotation);
																	toViewController.view.alpha = 1.0;
																}];
								  
							  } completion:^(BOOL finished) {
								  [snapShotView removeFromSuperview];
								  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
							  }];
}

//creates a random rotation value
-(CGAffineTransform)useRandomRotation
{
	CGAffineTransform rotation;
	int randomInt = arc4random_uniform(3);
	
	switch (randomInt) {
		case 0:
			rotation = CGAffineTransformMakeRotation(M_PI_2);
			break;
		case 1:
			rotation = CGAffineTransformMakeRotation((-1)*M_PI_2);
			break;
		case 2:
			rotation = CGAffineTransformMakeRotation(M_PI_4);
			break;
		case 3:
			rotation = CGAffineTransformMakeRotation((-1)*M_PI_4);
			break;
		default:
			break;
	}
	
	return rotation;
}

@end

