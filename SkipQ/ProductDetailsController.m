//
//  ProductDetailsController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ProductDetailsController.h"

@interface ProductDetailsController ()

@end

@implementation ProductDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _labelProductName.text = _productName;
    //NSLog(@"%d", _rating);
    //_labelRating.text = [_rating stringValue];
    //_labelRating.text = [NSString stringWithFormat:@"%f", [_rating doubleValue]];
    //_labelPrice.text = [_price stringValue];
    //_labelTotalPrice.text = [_price stringValue];
    _labelRating.text = [NSString stringWithFormat:@"%@/5",@([_rating doubleValue]).stringValue];
    _labelPrice.text = [NSString stringWithFormat:@"$%@",@([_price doubleValue]).stringValue];
    _labelQuantity.text = @"1";
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@",@([_price doubleValue]).stringValue];
    
    /*NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_imageUrl]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
        }*/
    [_imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:_imageUrl];
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
