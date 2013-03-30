//
//  Created by marco on 29/03/13.
//
//
//


#import <Foundation/Foundation.h>

@interface MSMatrixMasterViewController : UIViewController

@property (weak, readonly, nonatomic) UIViewController *visibleViewController;
@property (strong, readonly, nonatomic) NSArray *childrenViewControllers;

- (id)initWithFrame:(CGRect)frame;
- (void)setChildren:(NSArray *)children;

@end