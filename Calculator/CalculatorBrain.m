//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;


-(NSMutableArray *)programStack
{
    if (!_programStack) _programStack=[[NSMutableArray alloc] init]; //lazy instantiation
    return _programStack;
}

-(id)program
{
    return [self.programStack copy];
}

+(id)popTopOfProgram:(id)program
{
    id topOfStack;
    if([program isKindOfClass:[NSArray class]]) //the argument has to be an array
    {
        topOfStack = [program lastObject];
        if(topOfStack) [program removeLastObject];
    }
    return topOfStack; //the return is an operand or an operator
}

// this class method returns a (NSString *) that describe the content of the stack, in a nice way.
// e.g. 3 E 4 +  -->> (3 + 4) = 7
+(NSString *)descriptionOfProgram:(id)program
{
    NSString *theFullDescription;
    id stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    id topOfStack = [self popTopOfProgram:stack];
    if([self isOperator:topOfStack])
    {
        //le sommet du stack est un opérateur: réappeller top of stack le nombre de fois nécessaires
        //nombre donné par  +(int)howManyOperandsFor:(NSString *)operator
        int numberOfRequiredOperands = [self howManyOperandsFor:topOfStack];
        if(numberOfRequiredOperands == 2)
        {
            //fourrer popOff... , "TopOfStack", popOff dans theFullDescription (avec des parenthèses):
            //TODO : parenthèses
            [theFullDescription stringByAppendingString:[self popTopOfProgram:stack]];
            [theFullDescription stringByAppendingString:topOfStack];
            [theFullDescription stringByAppendingString:[self popTopOfProgram:stack]];
        }
        else if (numberOfRequiredOperands == 1)
        {
            //fourrer topOfStack,  popOff dans theFullDescirption
            [theFullDescription stringByAppendingString:topOfStack];
            [theFullDescription stringByAppendingString:[self popTopOfProgram:stack]];
        }
        else if (numberOfRequiredOperands)
        {
            //fourrer juste l'opérateur
            [theFullDescription stringByAppendingString:topOfStack];
        }
        
    }
    return theFullDescription;
}



//some helper method
+(int)howManyOperandsFor:(NSString *)operator
{
    int result = 0;
    //dictionary contenant les opérateurs et le nombre d'opérands que chacun nécéssite.
    NSDictionary *numberOperandsForOperator = [NSDictionary dictionaryWithObjectsAndKeys:
              @"2", @"+", 
              @"2", @"-",
              @"2", @"*",
              @"2", @"/",
              
              @"1", @"sin",
              @"1", @"cos",
              @"1", @"tan",
              @"1", @"√",
              @"1", @"aTan",
              @"1", @"aSin",
              @"1", @"aCos",
                                        
              @"0", @"π",
                                               
              nil];
    
    result = [[numberOperandsForOperator objectForKey:operator] intValue];
    //retourne le nombre d'opérants nécessaire pour l'operator passé en arg de la fonction
    return result;
}

//some other helper method
+(BOOL)isOperator:(id)theThingWeWantToKnowWhatItIs
{
    NSSet *mysSetOfOperations = [NSSet setWithObjects:@"+", @"-", @"/", @"*", @"sin", @"cos", @"π", @"√", @"aSin", @"aCos", @"aTan", nil];
    if([mysSetOfOperations containsObject:theThingWeWantToKnowWhatItIs])
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

-(void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


-(double)performOperation:(NSString *) operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) //si on a une opération sur le stack
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"tan"]){
            result = tan([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"π"]){
            result = M_PI;
        } else if([operation isEqualToString:@"√"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"aSin"]){
            result = asin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"aCos"]){
            result = acos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"aTan"]){
            result = atan([self popOperandOffProgramStack:stack]);
        }
    }
    return result;

}

+(double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}


-(void) clearOperandStack 
{
    [self.programStack removeAllObjects];
    [self.programStack addObject:[NSNumber numberWithDouble:0.0]];
}

-(NSString *) PiFraction:(double)number
{
    return [NSString stringWithFormat:@"%g * π", (number / M_PI)];
}

@end
