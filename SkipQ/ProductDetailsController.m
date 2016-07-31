//
//  ProductDetailsController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ProductDetailsController.h"
#import "WalmartProductModel.h"
#import "ReviewViewController.h"

@interface ProductDetailsController ()

@end

@implementation ProductDetailsController
NSMutableArray *productList;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Fetch data from CoreData
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CheckoutProduct"];
    persistedCartDataList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];*/
    
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
    double price = [[[_labelPrice.text componentsSeparatedByString:@"$"] objectAtIndex:1] doubleValue];
    double quantity = _stepperQuantity.value;
    double totalPrice = price * quantity;
    _labelQuantity.text = @(quantity).stringValue;
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
}

- (IBAction)addToCart:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"CheckoutProduct" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", _obj.productName];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    NSLog(@"Prod name searched: %@", _obj.productName);
    if([results count] > 0){
        NSLog(@"Reached!");
        NSManagedObject *product = [results objectAtIndex:0];
        NSLog(@"Prod name found: %@", [product valueForKey:@"name"]);
        int quantity = [[product valueForKey:@"quantity"] intValue];
        NSLog(@"Contains: %@", @(quantity).stringValue);
        quantity = quantity + _stepperQuantity.value;
        NSLog(@"New Q: %@", @(quantity).stringValue);
        NSNumber *quantityNum = [[NSNumber alloc] initWithInt:quantity];
        [product setValue:quantityNum forKey:@"quantity"];
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    } else{
        // Create a new managed object
        NSManagedObject *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"CheckoutProduct" inManagedObjectContext:context];
        NSNumber *quantity = [[NSNumber alloc] initWithDouble: _stepperQuantity.value];
        WalmartProductModel *model = [[WalmartProductModel alloc] initWithParams:_obj.productName:_obj.price:quantity:_obj.imageUrl];
        [newProduct setValue:_obj.productName forKey:@"name"];
        [newProduct setValue:_obj.price forKey:@"price"];
        [newProduct setValue:quantity forKey:@"quantity"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else{
            NSLog(@"Saved!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product Added"
                                                            message:@"Product successfully added to cart"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reviewCart:(id)sender {
    [self performSegueWithIdentifier:@"reviewCart" sender:self];
}

- (IBAction)comparePrices:(id)sender {
    //bool isloaded = false;
   dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       /*UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
       activityView.center = CGPointMake(240,160);
       activityView.hidden = true;
       [self.view addSubview: activityView];
       activityView.hidden = FALSE;*/
       //[_loadingBar startAnimating];
       dispatch_async(dispatch_get_main_queue(), ^{
           [_loadingBar startAnimating];
           [self manageButtonDisplay:false];
       });
    NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL
                                                     URLWithString:@"https://api.priceapi.com/jobs"]];
    NSString *params = @"token=BXGAKTHWCVOZYKIYRMZTYTSSWIPKOBLEKHYOBOJMNURLCIJFOWRSXATGDTXFJCCR&country=us&source=google-shopping&currentness=daily_updated&completeness=one_page&key=gtin&values=0077043608067";
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    //[activityView startAnimating];
    if(error == nil){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        long httpStatusCode = (long)[httpResponse statusCode];
        NSLog(@"response status code: %ld", httpStatusCode);
        if(httpStatusCode == 200){
            // do stuff
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            NSLog(@"Job ID: %@", allData[@"job_id"]);
            NSString *jobUrl = [NSString stringWithFormat:@"https://api.priceapi.com/jobs/%@?token=BXGAKTHWCVOZYKIYRMZTYTSSWIPKOBLEKHYOBOJMNURLCIJFOWRSXATGDTXFJCCR", allData[@"job_id"]];
            NSString *jobStatus = @"pending";
            while(![jobStatus isEqualToString:@"finished"]){
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:jobUrl]];
            response = nil;
            error = nil;
            data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if(error == nil){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long httpStatusCode = (long)[httpResponse statusCode];
                NSLog(@"Job Response status code: %ld", httpStatusCode);
                if(httpStatusCode == 200){
                    allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    jobStatus = allData[@"status"];
                    [NSThread sleepForTimeInterval:1.0f];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_loadingBar stopAnimating];
                        [self manageButtonDisplay:true];
                    });
                    break;
                }
            }else{
                NSLog(@"Job Error!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_loadingBar stopAnimating];
                    [self manageButtonDisplay:true];
                });
                break;
            }
         }
          //Job Completed
            NSString *downloadUrl = [NSString stringWithFormat:@"https://api.priceapi.com/products/bulk/%@?token=BXGAKTHWCVOZYKIYRMZTYTSSWIPKOBLEKHYOBOJMNURLCIJFOWRSXATGDTXFJCCR", allData[@"job_id"]];
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
            response = nil;
            error = nil;
            data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if(error == nil){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long httpStatusCode = (long)[httpResponse statusCode];
                NSLog(@"Job Response status code: %ld", httpStatusCode);
                if(httpStatusCode == 200){
                    allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                    NSArray *googleProducts = allData[@"products"];
                    if([googleProducts count] > 0){
                        NSDictionary* item = googleProducts[0];
                        NSArray *offers = item[@"offers"];
                        //NSMutableArray *offerList = [[NSMutableArray alloc] initWithObjects:nil];
                        NSString *offerFinalList = @"";
                        for (NSDictionary* offer in offers)
                        {
                            NSString *offerData = [NSString stringWithFormat:@"shop_name: %@ \t price: %@", offer[@"shop_name"], offer[@"price"]];
                            //[offerList addObject:offerData];
                            if(![offerData containsString:@"Walmart"]){
                                offerFinalList = [offerFinalList stringByAppendingString: [NSString stringWithFormat:@"%@\n", offerData]];
                            }
                          //NSLog(@"shop_name: %@, price: %@", offer[@"shop_name"], offer[@"price"]);
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_loadingBar stopAnimating];
                            [self showPriceCompareResult:offerFinalList];
                            [self manageButtonDisplay:true];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_loadingBar stopAnimating];
                        [self manageButtonDisplay:true];
                    });
                }
            }else{
                NSLog(@"Download Error!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_loadingBar stopAnimating];
                    [self manageButtonDisplay:true];
                });
            }
        }
    }else{
        NSLog(@"Error!");
        //[_loadingBar stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingBar stopAnimating];
            [self manageButtonDisplay:true];
            //activityView.hidden = FALSE;
        });
        
    }
  });
}

-(void)manageButtonDisplay:(bool)val{
    _btnBack.enabled = val;
    _btnCart.enabled = val;
    _btnCompare.enabled = val;
    _btnAddCart.enabled = val;
}

-(void)showPriceCompareResult:(NSString *)offerList{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comparison Result" message:offerList delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    /*int yCol = 10;
    for (NSString* row in list){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, yCol, 100, 20)];
        label.text = row;
        [alert addSubview:label];
        yCol +=20;
    }*/
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reviewCart"]) {
        ReviewViewController *destViewController = segue.destinationViewController;
        //destViewController.productList = productList;
        NSLog(@"%s","Sent!");
    }
}


@end
