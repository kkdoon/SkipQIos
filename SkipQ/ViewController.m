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
#import "TrendingListViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
  WalmartProductModel *obj;
  NSMutableArray *trendingList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlert:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Deal of Day"
                                  message:@"Are you interested in exploring deals of day in Electronics section?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             NSLog(@"Done");
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 NSLog(@"No");
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)getTrendingData:(id)sender {
    // Send asynchronous request
    NSString *url = @"http://api.walmartlabs.com/v1/trends?format=json&apiKey=29848w8q74kj8q5c54rbkqna";

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            WalmartProductModel *row;
            trendingList = [NSMutableArray arrayWithObjects: nil];
            
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            NSArray* itemList = allData[@"items"];
            for (NSDictionary* item in itemList)
            {
                NSString *category = item[@"categoryPath"];
                if(category != nil && [category containsString:@"Electronics"]){
                    row = [[WalmartProductModel alloc] initWithParams:item[@"name"]:item[@"salePrice"]:item[@"msrp"]:item[@"customerRating"]:item[@"largeImage"]];
                    [trendingList addObject:row];
                }
                /*NSLog(@"item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);*/
            }
            for(WalmartProductModel *obj in trendingList){
                NSLog(@"Row: item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);
            }
        }
    }];
    [dataTask resume];
}

- (IBAction)getData:(id)sender {
    NSString *upcCode = _labelUic.text;
    // Send asynchronous request
    NSString *url =  [NSString stringWithFormat:@"%@%@", @"http://api.walmartlabs.com/v1/items?apiKey=29848w8q74kj8q5c54rbkqna&upc=", upcCode];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long httpStatusCode = (long)[httpResponse statusCode];
            NSLog(@"response status code: %ld", httpStatusCode);
            if(httpStatusCode == 200){
            // do stuff
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            NSArray* itemList = allData[@"items"];
            
            for (NSDictionary* item in itemList)
            {
                obj = [[WalmartProductModel alloc] initWithParams:item[@"name"]:item[@"salePrice"]:item[@"customerRating"]:item[@"largeImage"]];
                NSLog(@"item: %@, price: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.rating, obj.imageUrl);
                break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[NSThread currentThread] isMainThread]){
                    NSLog(@"In main thread--completion handler");
                    [self performSegueWithIdentifier:@"showProductInfo" sender:self];
                }
                else{
                    NSLog(@"Not in main thread--completion handler");
                }
            });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[NSThread currentThread] isMainThread]){
                        NSLog(@"In main thread--completion handler");
                        [self showHttpErrorMsg];
                    }
                    else{
                        NSLog(@"Not in main thread--completion handler");
                    }
                });
            }
        }else{
            NSLog(@"Error");
        }
    }];
    
    [dataTask resume];
}

-(void)showHttpErrorMsg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"UIC Code Not Found"
                                  message:@"Are you using correct UIC Code. Please check and try again."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductInfo"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.obj = [[WalmartProductModel alloc] initWithParams:obj.productName:obj.price:obj.rating:obj.imageUrl];
    }else if ([segue.identifier isEqualToString:@"trendingTable"]) {
        TrendingListViewController *destViewController = segue.destinationViewController;
        destViewController.trendingList = trendingList;
    }
}
@end
