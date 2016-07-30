//
//  ProductDetailsController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ProductDetailsController.h"
#import "WalmartProductModel.h"
#import "ReviewViewController.h"

@interface ProductDetailsController ()

@end

@implementation ProductDetailsController
NSMutableArray *productList;

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

- (IBAction)quantityValueChanged:(id)sender {
    //_labelQuantity.text = [NSString stringWithFormat:@"%f", _stepperQuantity.value];
    double price = [[[_labelPrice.text componentsSeparatedByString:@"$"] objectAtIndex:1] doubleValue];
    double quantity = _stepperQuantity.value;
    double totalPrice = price * quantity;
    _labelQuantity.text = @(quantity).stringValue;
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
}

- (IBAction)reviewCart:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *quantity = [f numberFromString:_labelQuantity.text];
    WalmartProductModel *model = [[WalmartProductModel alloc] initWithParams:_obj.productName:_obj.price:quantity:_obj.imageUrl];
    productList = [NSMutableArray arrayWithObjects: nil];
    [productList addObject:model];
    [self performSegueWithIdentifier:@"reviewCart" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reviewCart"]) {
        ReviewViewController *destViewController = segue.destinationViewController;
        destViewController.productList = productList;
        NSLog(@"%s","Sent!");
    }
}


@end
