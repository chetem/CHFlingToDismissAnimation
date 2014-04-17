CHFlingToDismissAnimation
=========================

Dismisses a ViewController with a finger flick up. Also supports interactive finger swipes.

Getting Started:
---------------
- Drag and drop the animation files into your project.
- In the view controller doing the presenting, create a class instance of both `CHFlingToDismissAnimation` and `CHSwipeInteractionController`, and in your `-init` function allocate them by calling `[CHFlingToDismissAnimation new]` and `[CHSwipeInteractionController new]`, respectively. Make sure this class contains the appropriate imports.
- Then, when presenting your next view controller, wire your swipeInteractionController to your next view controller by calling `-wireToViewController:`, passing in the view controller you will be presenting.
- In your current View Controller, you must adhere to the `UIViewControllerTransitioningDelegate`. Then set your current view controller as the delegate of the view controller your are presenting, like so: 
```objective-c
MyNextViewController *viewController = [[MyNextViewController alloc] init]; //instance of your next view controller
[_swipeInteractionController wireToViewController:viewController] //wire to your swipe interaction
viewController.transitioningDelegate = self;  //set transitioning delegate
[self presentViewController:viewController animated:YES completion:nil];  //present next view controller
```
- Implement the `UIViewControllerTransitioningDelegate` methods, returning your `_flingToDimissAnimation` instance and `_swipeInteraction` instance in the appropriate delegate methods, like so:
```objective-c
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	return _flingToDismissAnimation;
}

- (id <UIViewControllerInteractiveTransitioning>) interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
	return _swipeInteraction.interactionInProgress ? _swipeInteraction : nil;
}
```
NOTE: Since we're only using the animations for dismissing a view controller, we only need to implement the dismissal delegate methods.

####Optional Steps:
You can also set the `animationDuration` property of the `CHFlingToDismissAnimation` instance and the `threshold` property of the `CHSwipeInteractionController`. The `animationDuration` property is just that, the duration for which the dismiss animation will take to complete. If none is set, it defaults to 0.75 seconds. The `threshold` property is the threshold for which the dismiss animation decides whether or not to complete. It is used as a percentage of dismissal completion and should be a number between 0 and 1. If none is set, it defaults to 0.25. So that means if 25% of the dismiss animation has completed, it will finish dismissing. Otherwise, it will cancel the dismissal. This property only comes into play when using the interactive functionality of the animation. If you set these properties, they must be set prior to presenting your next view controller, like so:

```objective-c
MyNextViewController *viewController = [[MyNextViewController alloc] init];
[_swipeInteractionController wireToViewController:viewController]
_swipeInteractionController.threshold = 0.3;	//set the swipe interaction percentage threshold
_flingToDismissAnimation.animationDuration = 1.25;	//set the dismissal animation duration
viewController.transitioningDelegate = self;
[self presentViewController:viewController animated:YES completion:nil];
```

####Additional Info:
The animation pushes the dismissing view controller up off the screen while also rotating and fading out. It randomly selects between 4 different rotations, varying in degree and direction. 

![alt text](https://github.com/chetem/CHFlingToDismissAnimation/raw/master/Screen%20Shots/Photo%2077.png "Screen Shot 1")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![alt text](https://github.com/chetem/CHFlingToDismissAnimation/raw/master/Screen%20Shots/Photo%2078.png "Screen Shot 2")


