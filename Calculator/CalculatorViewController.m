//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// more comment to test a github push from xcode

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingSomething;
@property (nonatomic, strong) CalculatorBrain *brain;

@property (weak, nonatomic) IBOutlet UIButton *dotButton;
@property (weak, nonatomic) IBOutlet UIButton *fractionOfPiButton;
@property (weak, nonatomic) IBOutlet UILabel *history;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfTypingSomething = _userIsInTheMiddleOfTypingSomething;
@synthesize brain = _brain;

@synthesize dotButton = _dotButton;
@synthesize fractionOfPiButton = _fractionOfPiButton;

@synthesize history = _history;



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
    self.fractionOfPiButton.enabled=YES;
    if(self.userIsInTheMiddleOfTypingSomething)
    {
        [self enterPressed];
    }
    double result = [self.brain performOperation:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];

}
- (IBAction)clearButtonPressed 
{
    [self.brain clearOperandStack];
    self.fractionOfPiButton.enabled=YES;
    self.display.text = @"0";
    self.history.text = @"";
}


- (IBAction)PiFractionPressed 
{
    self.display.text = [self.brain PiFraction:[self.display.text doubleValue]];
    self.fractionOfPiButton.enabled=NO;
}





- (void)viewDidUnload {
    [self setDotButton:nil];
    [self setHistory:nil];
    [self setFractionOfPiButton:nil];
    [super viewDidUnload];
}
@end
