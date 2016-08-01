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
#import "ESSBeaconScanner.h"
#import "ESSEddyStone.h"
#import "BeaconManager.h"
#import "TrendingListViewController.h"

@interface ViewController () <ESSBeaconScannerDelegate> {
    //@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
    ESSBeaconScanner *_scanner;
}

@end
@implementation ViewController{
  WalmartProductModel *obj;
  NSMutableArray *trendingList;
}
static BOOL *isBeaconFound;
static NSString *ConfiguredBeaconNamespaceID = @"ca2393587ea5470e81b8";
static NSString *ConfiguredBeaconInstanceID = @"000000000063";
static NSString *SelectedUrlContains = @"team11.com";
static NSString *SelectedUrl;
static NSString *SectionName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)showAlert:(id)sender {
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
}*/

/*- (IBAction)getTrendingData:(id)sender {
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
                //NSLog(@"item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);
            }
            for(WalmartProductModel *obj in trendingList){
                NSLog(@"Row: item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);
            }
        }
    }];
    [dataTask resume];
}*/

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductInfo"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.obj = [[WalmartProductModel alloc] initWithParams:obj.productName:obj.price:obj.rating:obj.imageUrl];
    }else if ([segue.identifier isEqualToString:@"trendingTable"]) {
        TrendingListViewController *destViewController = segue.destinationViewController;
        destViewController.trendingList = trendingList;
    }
}*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scanner = [[ESSBeaconScanner alloc] init];
    _scanner.delegate = self;
    if(!isBeaconFound){
        [_scanner startScanning];
    }else{
        NSLog(@"Beacon already notified!");
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [_scanner stopScanning];
    //    _scanner = nil;
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner
        didFindBeacon:(id)beaconInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"I Saw an Eddystone!: %@", beaconInfo);
        //[NSThread sleepForTimeInterval:5.0f];
    });
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didUpdateBeacon:(id)beaconInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"I Updated an Eddystone!: %@", beaconInfo);
        ESSBeaconInfo *b= (ESSBeaconInfo *) beaconInfo;
        double dist = [self calculateDistance:[b.txPower intValue]:[b.RSSI doubleValue]];
        NSLog(@"Distance :%@", @(dist).stringValue);
        NSString *beaconNamespace = [NSString stringWithFormat:@"%@", b.beaconID];
        NSRange range = [beaconNamespace rangeOfString:@"<"];
        NSString *namespace = [[beaconNamespace substringFromIndex:range.location +1] substringToIndex:22];
        NSString *instanceBeacon = [beaconNamespace substringFromIndex:22];
        instanceBeacon = [[instanceBeacon substringFromIndex:range.location +1]stringByReplacingOccurrencesOfString:@" " withString:@""];
        instanceBeacon = [instanceBeacon substringToIndex:[instanceBeacon length] -1];
        namespace = [namespace stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"Beacon Str:%@", namespace);
        NSLog(@"Beacon Instance:%@", instanceBeacon);
        
        if(dist <= 15 && [namespace isEqualToString:ConfiguredBeaconNamespaceID] && [instanceBeacon isEqualToString:ConfiguredBeaconInstanceID] && SelectedUrl != nil && [SelectedUrl containsString:SelectedUrlContains]){
            SectionName = [[[SelectedUrl componentsSeparatedByString:@"/"] objectAtIndex: 3] lowercaseString];
            NSString *upper = [[NSString stringWithFormat:@"%c", [SectionName characterAtIndex:0]] uppercaseString];
            SectionName =[upper stringByAppendingString:[SectionName substringFromIndex:1]];
            if (self.isViewLoaded && self.view.window) {
            NSLog(@"View Controller Beacon Found!!!!!");
            //NSLog(@"Beacon URL:%@", SelectedUrl);
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Deal of Day"
                                          message:[NSString stringWithFormat:@"Are you interested in exploring deals of day in %@ section?", SectionName]
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self performSegueWithIdentifier:@"mainToTrendingPage" sender:self];
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
            BeaconManager *manager = [BeaconManager getInstance];
            [BeaconManager setSectionName:SectionName];
            NSLog(@"section name: %@", SectionName);
            [manager invokeBeaconFound];
            isBeaconFound = TRUE;
            [_scanner stopScanning];
            _scanner = nil;
        }else{
             NSLog(@"url: %@, distance: %@", SelectedUrl, @(dist).stringValue);
        }
        //[NSThread sleepForTimeInterval:5.0f];
    });
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindURL:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"I Saw a URL!: %@", url);
            });
    SelectedUrl = [NSString stringWithFormat:@"%@", url];
}

-(double) calculateDistance:(int)txPower:(double)rssi {
    if (rssi == 0) {
        return -1.0; // if we cannot determine distance, return -1.
    }
    
    int pathLoss = txPower - rssi;
    return pow(10, (pathLoss - 41) / 20.0);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mainToTrendingPage"]) {
        TrendingListViewController *destViewController = segue.destinationViewController;
        destViewController.sectionName = SectionName;
        NSLog(@"section: %@", SectionName);
    }
}
@end
