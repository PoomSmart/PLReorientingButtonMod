#import <UIKit/UIKit.h>

#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

static BOOL dragged = YES;
static int orientation;
static float space;

@interface PLReorientingButton : UIButton
@end

@interface PLCameraView
- (void)_setSettingsButtonAlpha:(float)alpha duration:(double)duration;
@end

%hook PLCameraView

- (void)toggleSettings:(id)settings
{
	if (dragged)
		%orig;
}

- (void)_toggleCameraButtonWasPressed:(id)pressed
{
	if (dragged)
		%orig;
}

- (void)flashButtonWillExpand:(id)arg
{
	%orig;
	[self _setSettingsButtonAlpha:1.0 duration:0.0];
}

- (int)_glyphOrientationForCameraOrientation:(int)arg1
{
	if (!IPAD) {
		int r = %orig;
		orientation = r;
		return r;
	}
	return %orig;
}

- (void)_windowWillAnimateRotationToOrientation:(int)orient
{
	if (IPAD) {
		int r = orient;
		orientation = r;
		%orig(r);
		return;
	}
	%orig;
}

%end

%hook PLReorientingButton

- (id)initWithFrame:(CGRect)frame isInButtonBar:(BOOL)buttonBar
{
	self = %orig;
	if (self) {
		[self addTarget:self action:@selector(PLtouchMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
		[self addTarget:self action:@selector(PLfinishedDragging:withEvent:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpInside];
	}
	return self;
}

%new(v@:@:)

- (void)PLfinishedDragging:(UIButton *)button withEvent:(UIEvent *)event
{
	if (![NSStringFromClass([button class]) isEqualToString:@"PLCameraVideoStillCaptureButton"]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
			space = 10.0f + (IPAD ? 2.0f : 0.0f);
			if (orientation == 1 || orientation == 2) {
				if (self.frame.origin.x > [self superview].frame.size.width - self.frame.size.width - space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake([self superview].frame.size.width - self.frame.size.width - space, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
					}];
				}
				else if (self.frame.origin.x < space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(space, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
					}];
				}
				if (self.frame.origin.y > [self superview].frame.size.height - self.frame.size.height - space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(button.frame.origin.x, [self superview].frame.size.height - self.frame.size.height - space, button.frame.size.width, button.frame.size.height);
					}];
				}
				else if (self.frame.origin.y < space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(button.frame.origin.x, space, button.frame.size.width, button.frame.size.height);
					}];
				}
			}
			else if (orientation == 3 || orientation == 4) {
				if (self.frame.origin.x > [self superview].frame.size.height - self.frame.size.width - space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake([self superview].frame.size.height - self.frame.size.width - space, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
					}];
				}
				else if (self.frame.origin.x < space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(space, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
					}];
				}
				if (self.frame.origin.y > [self superview].frame.size.width - self.frame.size.height - space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(button.frame.origin.x, [self superview].frame.size.width - self.frame.size.height - space, button.frame.size.width, button.frame.size.height);
					}];
				}
				else if (self.frame.origin.y < space) {
					[UIView animateWithDuration:0.1 animations:^{
    					self.frame = CGRectMake(button.frame.origin.x, space, button.frame.size.width, button.frame.size.height);
					}];
				}
			}
			dragged = YES;
		});
	}
}

%new(v@:@:)

- (void)PLtouchMoved:(UIButton *)button withEvent:(UIEvent *)event
{
	if (![NSStringFromClass([button class]) isEqualToString:@"PLCameraVideoStillCaptureButton"]) {
		UITouch *touch = [[event touchesForView:button] anyObject];
	
		UIView *view = [self superview];
		CGPoint previousLocation = [touch previousLocationInView:view];
		CGPoint location = [touch locationInView:view];

		CGFloat delta_x = location.x - previousLocation.x;
		CGFloat delta_y = location.y - previousLocation.y;
 	
		self.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
		dragged = NO;
	}
}

%end
