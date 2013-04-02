// UIViewController+MSMatrixController.m
//
// Copyright (c) 2013 Marco Sero (http://www.marcosero.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "UIViewController+MSMatrixController.h"
#import "MSMatrixMasterViewController.h"
#import <objc/runtime.h>

static char kRow;
static char kCol;
static char kPosition;
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

- (MSMatrixMasterViewController *)matrixViewController
{
  UIViewController *iterator = self.parentViewController;
  while (iterator) {
    if ([iterator isKindOfClass:[MSMatrixMasterViewController class]]) {
      return (MSMatrixMasterViewController *)iterator;
    } else if (iterator.parentViewController && iterator.parentViewController != iterator) {
      iterator = iterator.parentViewController;
    } else {
      iterator = nil;
    }
  }
  return nil;
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