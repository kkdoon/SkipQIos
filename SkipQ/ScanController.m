//
//  scanController.m
//  SkipQ
//
//  Created by nightshader on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanController.h"
#import "WalmartProductModel.h"
#import "ProductDetailsController.h"
#import "ViewController.h"

@interface ScanController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}
@end

@implementation ScanController {
    WalmartProductModel *obj;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            NSString *upcCode = [_label.text substringFromIndex:1];
            NSLog(@"UPC Code: %@", upcCode);
            _highlightView.frame = highlightViewRect;
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
                                
                                [self performSegueWithIdentifier:@"showProduct" sender:self];
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
            [_session stopRunning];
            break;
        }
        else
            _label.text = @"(none)";
    }
    
    _highlightView.frame = highlightViewRect;
    
    
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
                             [self performSegueWithIdentifier:@"backToMainPage" sender:self];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProduct"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.obj = [[WalmartProductModel alloc] initWithParams:obj.productName:obj.price:obj.rating:obj.imageUrl];
    }else if([segue.identifier isEqualToString:@"backToMainPage"]){
        ViewController *destViewController = segue.destinationViewController;
    }
}

@end