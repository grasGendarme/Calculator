//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Louis on 3/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) pushOperand:(double)operand;
-(double) performOperation:(NSString *) operation;

@end
