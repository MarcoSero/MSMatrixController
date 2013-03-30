//
//  Created by marco on 30/03/13.
//
//
//


#import "UIViewController+MSMatrixController.h"
#import "MSMatrixMasterViewController.h"
#import <objc/runtime.h>

static char kRow;
static char kCol;
static char kPosition;
static char kMasterViewController;
static char kLeftViewController;
static char kRightViewController;
static char kTopViewController;
static char kBottomViewController;

@implementation UIViewController (MSMatrixController)

#pragma mark - Setters

- (void)setRow:(NSInteger)row
{
  objc_setAssociatedObject(self, &kRow, @(row), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  Position newPosition = self.position;
  newPosition.row = row;
  self.position = newPosition;
}

- (void)setCol:(NSInteger)col
{
  objc_setAssociatedObject(self, &kCol, @(col), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  Position newPosition = self.position;
  newPosition.col = col;
  self.position = newPosition;
}

- (void)setPosition:(Position)position
{
  NSValue *valuePosition = [NSValue value:&position withObjCType:@encode(Position)];
  objc_setAssociatedObject(self, &kPosition, valuePosition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMasterViewController:(UIViewController *)masterViewController
{
  objc_setAssociatedObject(self, &kMasterViewController, masterViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
  objc_setAssociatedObject(self, &kLeftViewController, leftViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
  objc_setAssociatedObject(self, &kRightViewController, rightViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setTopViewController:(UIViewController *)topViewController
{
  objc_setAssociatedObject(self, &kTopViewController, topViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setBottomViewController:(UIViewController *)bottomViewController
{
  objc_setAssociatedObject(self, &kBottomViewController, bottomViewController, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Getters

- (NSInteger)row
{
  return [objc_getAssociatedObject(self, &kRow) integerValue];
}

- (NSInteger)col
{
  return [objc_getAssociatedObject(self, &kCol) integerValue];
}

- (Position)position
{
  Position p;
  [objc_getAssociatedObject(self, &kPosition) getValue:&p];
  return p;
}

- (MSMatrixMasterViewController *)masterViewController
{
  return objc_getAssociatedObject(self, &kMasterViewController);
}

- (UIViewController *)leftViewController
{
  return objc_getAssociatedObject(self, &kLeftViewController);
}

- (UIViewController *)rightViewController
{
  return objc_getAssociatedObject(self, &kRightViewController);
}

- (UIViewController *)topViewController
{
  return objc_getAssociatedObject(self, &kTopViewController);
}

- (UIViewController *)bottomViewController
{
  return objc_getAssociatedObject(self, &kBottomViewController);
}



@end