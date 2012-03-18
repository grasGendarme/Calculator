//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) clearOperandStack;
-(void) pushOperand:(double)operand;
-(double) performOperation:(NSString *) operation;
-(NSString *) PiFraction:(double)number;

@property (nonatomic, readonly) id program;

//+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
