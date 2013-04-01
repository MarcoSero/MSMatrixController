
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