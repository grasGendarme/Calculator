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
/*
+(NSString *)descriptionOfProgram:(id)program
{
    NSString *theDescription;
    id topOfStack = [program lastObject]; //à passer en arg à la fonction descriptionOfTopOfStack
    
    
    // j'écris une fonction helper qui donne le type du dernier objet du stack
    
    //description du stack d'une belle manière :

     a. 3 E 5 E 6 E 7 + * - should display as 3 - (5 * (6 + 7)) or an even cleaner
     output would be 3 - 5 * (6 + 7).
     b. 3 E 5 + sqrt should display as sqrt(3 + 5).
     c. 3 sqrt sqrt should display as sqrt(sqrt(3)).
     d. 3 E 5 sqrt + should display as 3 + sqrt(5).
     e. π r r * * should display as π * (r * r) or, even better, π * r * r.
     f. a a * b b * + sqrt would be, at best, sqrt(a * a + b * b).
 
 A implementer avec via une autre méthode récursive + des helpers pour savoir ce qu'il y sur le stack 

    return theDescription;
}

+(id)descriptionOfTopOfStack:(id)topOfStack
{
    id whatItIs;
    //si c'est une opération, il faut se réappeller suivant le nombre d'operands nécessaires et envoyer le résultat à afficher à descriptionOfProgram (un NSString *)
    if([topOfStack isKindOfClass:[NSString class]]) 
    {
        //OMG c'est un opérateur (more checks needed)
        //[self descriptionOfTopOfStack:
    }
    // et si c'est un nombre...
    else if([topOfStack isKindOfClass:[NSNumber class]])
    {
        
    }

}
*/


+(id)popTopOfProgram:(id)program
{
    id topOfStack;
    if([program isKindOfClass:[NSArray class]]) //the argument has to be an array
    {
        topOfStack = [program lastObject];
        [program removeLastObject];
        
        if([self isOperator:topOfStack])
        {
            if([self howManyOperandsFor:topOfStack]==2)
            {
                //créer un NSString contenant le vieux nombre qu'on poppe, le topOfStack, et le nouveau nombre
                [self popTopOfProgram:program];
            }
    
        }
        else
        {
            
        }
    }
    return topOfStack;
}


/*
+(NSString *)descriptionOfTopOfProgram:(id)theThing
{

}
*/

// this class method returns a (NSString *) that describe the content of the stack, in a nice way.
// e.g. 3 E 4 +  -->> (3 + 4) = 7
+(NSString *)descriptionOfProgram:(id)program
{
    NSString *theFullDescription;
        

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
