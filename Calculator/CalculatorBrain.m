//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack
{
    if (!_operandStack)
        _operandStack=[[NSMutableArray alloc] init]; //lazy instantiation
    return _operandStack;
}

-(void) pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double)popOperand
{
    NSNumber *operand = [self.operandStack lastObject];
    if (operand) [self.operandStack removeLastObject];
    return [operand doubleValue];
}


-(double) performOperation:(NSString *) operation
{
    
    double result = 0 ;
    
    if([operation isEqualToString:@"+"]) 
    {
        result = [self popOperand] + [self popOperand];
    }
    else if([operation isEqualToString:@"-"])
    {
        result = [self popOperand];
        result = [self popOperand] - result;
    }
    else if([operation isEqualToString:@"*"])
    {
        result = [self popOperand] * [self popOperand];
    }
    
    else if ([operation isEqualToString:@"/"])
    {
        result = [self popOperand];
        result = [self popOperand] / result ;
    }
    
    else if ([operation isEqualToString:@"sin"])
    {
        result = sin([self popOperand]);
    }
    
    else if ([operation isEqualToString:@"cos"])
    {
        result = cos([self popOperand]);
    }
    
    else if ([operation isEqualToString:@"tan"])
    {
        result = tan([self popOperand]);
    }
    
    else if ([operation isEqualToString:@"pi"])
    {
        result = M_PI;
    }
    
    [self pushOperand:result];
    
    return result;
}

-(void) clearOperandStack 
{
    [self.operandStack removeAllObjects];
    [self.operandStack addObject:[NSNumber numberWithDouble:0.0]];
}



@end
