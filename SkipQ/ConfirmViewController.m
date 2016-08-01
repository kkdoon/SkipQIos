//
//  ConfirmViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ConfirmViewController.h"
#import <CoreData/CoreData.h>

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CheckoutProduct"];
    NSMutableArray *productList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy
                                   ];
    double price, totalPrice = 0.0;
    int quantity, totalQuantity = 0;
    NSLog(@"Count:%@", @([productList count]).stringValue);
    for(int i = 0; i < [productList count]; i++){
        price = [[productList[i] valueForKey:@"price"] doubleValue];
        quantity = [[productList[i] valueForKey:@"quantity"] intValue];
        totalPrice += price * quantity;
        totalQuantity += quantity;
    }
    _labelSubtotal.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", @(totalPrice).stringValue];
    
    NSError *error = nil;
    while([productList count] != 0){
        for(int i = 0; i < [productList count]; i++){
            [managedObjectContext deleteObject:[productList objectAtIndex:i]];
            if (![managedObjectContext save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            [productList removeObjectAtIndex:i];
        }
    }
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

- (IBAction)downloadReceipt:(id)sender {
}
@end
