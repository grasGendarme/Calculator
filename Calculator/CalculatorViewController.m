//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
////

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingSomething;
@property (nonatomic, strong) CalculatorBrain *brain;

@property (weak, nonatomic) IBOutlet UIButton *dotButton;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userIsInTheMiddleOfTypingSomething = _userIsInTheMiddleOfTypingSomething;
@synthesize brain =_brain;
@synthesize dotButton = _dotButton;
@synthesize displayLabel = _displayLabel;



-(CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
    
}


- (IBAction)digitPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTypingSomething)
    {
        if([[sender currentTitle] isEqualToString:@"."])
        {
            if([self.display.text rangeOfString:@"."].location == NSNotFound)
            {
                self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
                //et le désactiver....
                self.dotButton.enabled=NO;
             
            }
        }
        else 
        {
            self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
        }
    }
    else 
    {
        self.display.text = [sender currentTitle];
        self.userIsInTheMiddleOfTypingSomething=YES;

    }
}


- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTypingSomething=NO;
    self.dotButton.enabled=YES;
}

- (IBAction)operationPressed:(id)sender 
{

    if(self.userIsInTheMiddleOfTypingSomething)
    {
        [self enterPressed];
    }
    double result = [self.brain performOperation:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)clearButtonPressed 
{
    [self.brain clearOperandStack];
    self.display.text = @"0";
}


- (void)viewDidUnload {
    [self setDotButton:nil];
    [self setDisplayLabel:nil];
    [super viewDidUnload];
}
@end
