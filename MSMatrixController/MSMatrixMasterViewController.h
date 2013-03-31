//
//  Created by marco on 29/03/13.
//
//
//


#import <Foundation/Foundation.h>
#import "UIViewController+MSMatrixController.h"

@protocol MSMatrixControllerDelegate <NSObject>
@optional
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

@end