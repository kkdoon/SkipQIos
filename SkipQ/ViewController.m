//
//  ViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ViewController.h"
#import "ProductDetailsController.h"
#import "WalmartProductModel.h"

@interface ViewController ()

@end

@implementation ViewController{
  WalmartProductModel *obj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getData:(id)sender {
    NSString *upcCode = _testLabel.text;
    // Send a synchronous request
    NSString *url =  [NSString stringWithFormat:@"%@%@", @"http://api.walmartlabs.com/v1/items?apiKey=29848w8q74kj8q5c54rbkqna&upc=", upcCode];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            NSArray* itemList = allData[@"items"];
            
            for (NSDictionary* item in itemList)
            {
                obj = [[WalmartProductModel alloc] initWithParams:item[@"name"]:item[@"salePrice"]:item[@"customerRating"]:item[@"largeImage"]];
                NSLog(@"item: %@, price: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.rating, obj.imageUrl);
                break;
            }
        }
    }];
    [dataTask resume];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductInfo"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.obj = [[WalmartProductModel alloc] initWithParams:obj.productName:obj.price:obj.rating:obj.imageUrl];        
    }
}
@end
