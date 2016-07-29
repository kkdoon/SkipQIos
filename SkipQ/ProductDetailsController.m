//
//  ProductDetailsController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ProductDetailsController.h"
#import "WalmartProductModel.h"

@interface ProductDetailsController ()

@end

@implementation ProductDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _labelProductName.text = _obj.productName;
    _labelRating.text = [NSString stringWithFormat:@"%@/5",@([_obj.rating doubleValue]).stringValue];
    _labelPrice.text = [NSString stringWithFormat:@"$%@",@([_obj.price doubleValue]).stringValue];
    _labelQuantity.text = @"1";
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@",@([_obj.price doubleValue]).stringValue];
    //Downloading product image
    [_obj.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:_obj.imageUrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            _imageProduct.image = [[UIImage alloc] initWithData:data];            
            // pass the img to your imageview
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)quantityValueChanged:(id)sender {
    //_labelQuantity.text = [NSString stringWithFormat:@"%f", _stepperQuantity.value];
    double price = [[[_labelPrice.text componentsSeparatedByString:@"$"] objectAtIndex:1] doubleValue];
    double quantity = _stepperQuantity.value;
    double totalPrice = price * quantity;
    _labelQuantity.text = @(quantity).stringValue;
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
}
@end
