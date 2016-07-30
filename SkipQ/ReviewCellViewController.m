//
//  ReviewCellViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ReviewCellViewController.h"

@interface ReviewCellViewController ()

@end

@implementation ReviewCellViewController

- (IBAction)changeQuantity:(id)sender {
    double price = [[[_labelPrice.text componentsSeparatedByString:@"$"] objectAtIndex:1] doubleValue];
    double quantity = _stepperQuantity.value;
    double totalPrice = price * quantity;
    _labelQuantity.text = @(quantity).stringValue;
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
}

@end
