//
//  CHFirstViewController.m
//  CHFlingingViewController
//
//  Created by Chris Hetem on 4/16/14.
//  Copyright (c) 2014 croberth. All rights reserved.
//

#import "CHFirstViewController.h"
#import "CHSecondViewController.h"
#import "CHFlingToDismissAnimationController.h"
#import "CHSwipeInteractionController.h"
@interface CHFirstViewController () <UIViewControllerTransitioningDelegate>	//Be sure to include this delegate

@property (weak,nonatomic) IBOutlet UIButton *myButton;

@end

@implementation CHFirstViewController
{
	CHFlingToDismissAnimationController *_flingToDismissAnimation;
	CHSwipeInteractionController *_swipeInteraction;
}

- (id)init {
	self = [super initWithNibName:@"CHFirstViewController" bundle:nil];
	if (self) {
		_flingToDismissAnimation = [CHFlingToDismissAnimationController new];
		_swipeInteraction= [CHSwipeInteractionController new];
	}
	return self;
}

-(IBAction)onGoButton:(id)sender
{
	CHSecondViewController *vc = [[CHSecondViewController alloc]init];
	[_swipeInteraction wireToViewController:vc];
//	_swipeInteraction.threshold = 0.3;	//optional
//	_flingToDismissAnimation.animationDuration = 1.25;	//optional
	vc.transitioningDelegate = self;
	[self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Transitioning Delegate


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	return _flingToDismissAnimation;
}

- (id <UIViewControllerInteractiveTransitioning>) interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
	return _swipeInteraction.interactionInProgress ? _swipeInteraction : nil;
	
}


@end
