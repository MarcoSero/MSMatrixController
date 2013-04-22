//
//  MSDemoViewController.m
//  MSMatrixController
//
//  Created by Marco Sero on 30/03/13.
//  Copyright (c) 2013 Marco Sero. All rights reserved.
//

#import "MSDemoViewController.h"
#import "UIViewController+MSMatrixController.h"
#import "MSMatrixMasterViewController.h"

@interface MSDemoViewController ()
@property(weak, nonatomic) IBOutlet UIButton *goUpButton;
@property(weak, nonatomic) IBOutlet UIButton *goLeftButton;
@property(weak, nonatomic) IBOutlet UIButton *goRightButton;
@property(weak, nonatomic) IBOutlet UIButton *goDownButton;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@end

@implementation MSDemoViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self updateDisplay];
}

- (void)viewDidUnload
{
  [self setPositionLabel:nil];
  [super viewDidUnload];
}

- (IBAction)goLeft:(id)sender
{
  [self.matrixViewController moveLeftAnimated:YES];
}

- (IBAction)goRight:(id)sender
{
  [self.matrixViewController moveRightAnimated:YES];
}

- (IBAction)goUp:(id)sender
{
  [self.matrixViewController moveUpAnimated:YES];
}

- (IBAction)goDown:(id)sender
{
  [self.matrixViewController moveDownAnimated:YES];
}

- (IBAction)insertLeft:(id)sender
{
  UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"position02"];
  newController.row = self.row;
  newController.col = self.col;
  [self.matrixViewController insertController:newController shift:MSShiftHorizontal];
  [self updateDisplay];
  [self.matrixViewController moveLeftAnimated:YES];
}

- (IBAction)insertUp:(id)sender
{
  UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"position02"];
  newController.row = self.row - 1;
  newController.col = self.col;
  [self.matrixViewController insertController:newController shift:MSShiftVertical];
  [self updateDisplay];
  [self.matrixViewController moveUpAnimated:YES];
}

- (IBAction)insertRight:(id)sender
{
  UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"position02"];
  newController.row = self.row;
  newController.col = self.col + 1;
  [self.matrixViewController insertController:newController shift:MSShiftHorizontal];
  [self updateDisplay];
  [self.matrixViewController moveRightAnimated:YES];
}

- (IBAction)insertDown:(id)sender
{
  UIViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"position02"];
  newController.row = self.row + 1;
  newController.col = self.col;
  [self.matrixViewController insertController:newController shift:MSShiftVertical];
  [self updateDisplay];
  [self.matrixViewController moveDownAnimated:YES];
}

- (IBAction)removeTapped:(id)sender
{
  [self.matrixViewController removeController:self shift:MSShiftHorizontal];
}

- (void)updateDisplay
{
  _goLeftButton.hidden = !(BOOL)self.leftViewController;
  _goRightButton.hidden = !(BOOL)self.rightViewController;
  _goUpButton.hidden = !(BOOL)self.topViewController;
  _goDownButton.hidden = !(BOOL)self.bottomViewController;
  self.positionLabel.text = [NSString stringWithFormat:@"%i, %i", self.row, self.col];
}


@end
