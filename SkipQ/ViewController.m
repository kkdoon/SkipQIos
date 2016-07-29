//
//  ViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ViewController.h"
#import "ProductDetailsController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSString* itemName;
    NSNumber* salePrice;
    NSNumber* customerRating;
    NSString* thumbnailImage;
}
@synthesize receivedData;

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
    /*NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
     NSURLResponse * response = nil;
     NSError * error = nil;
     NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
     returningResponse:&response
     error:&error];*/
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            /*NSString* itemName = nil;
             NSNumber* salePrice = nil;
             NSNumber* customerRating = nil;
             NSString* thumbnailImage = nil;*/
            
            NSArray* itemList = allData[@"items"];
            
            for (NSDictionary* item in itemList)
            {
                itemName = item[@"name"];
                salePrice = item[@"salePrice"];
                customerRating = item[@"customerRating"];
                thumbnailImage = item[@"largeImage"];
                NSLog(@"item: %@, price: %@, rating: %@, imageUrl: %@", itemName, salePrice, customerRating, thumbnailImage);
                break;
            }
        }
    }];
    [dataTask resume];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductInfo"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.productName = [itemName copy];
        destViewController.price = [salePrice copy];
        destViewController.rating = [customerRating copy];
        destViewController.imageUrl = [thumbnailImage copy];
    }
}
@end
