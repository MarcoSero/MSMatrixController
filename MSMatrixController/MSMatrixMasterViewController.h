// MSMatrixMasterViewController.h
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


#import <Foundation/Foundation.h>
#import "UIViewController+MSMatrixController.h"

@protocol MSMatrixControllerDelegate <NSObject>
@optional
- (void)willMoveToViewController:(UIViewController *)viewController atPosition:(Position)position;
- (void)didMoveToViewController:(UIViewController *)viewController atPosition:(Position)position;
@end

@interface MSMatrixMasterViewController : UIViewController

@property(weak, nonatomic) id <MSMatrixControllerDelegate> delegate;
@property(weak, readonly, nonatomic) UIViewController *visibleViewController;
@property(strong, readonly, nonatomic) NSArray *viewControllers;

- (id)initWithFrame:(CGRect)frame;

- (void)setControllers:(NSArray *)controllers;

- (void)moveLeftAnimated:(BOOL)animated;

- (void)moveRightAnimated:(BOOL)animated;

- (void)moveUpAnimated:(BOOL)animated;

- (void)moveDownAnimated:(BOOL)animated;

- (void)moveLeftAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;

- (void)moveRightAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;

- (void)moveUpAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;

- (void)moveDownAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;

- (UIViewController *)getControllerAtPosition:(Position)position;

@end