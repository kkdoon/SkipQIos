//
//  ReviewViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ReviewViewController.h"
#import "WalmartProductModel.h"
#import "ReviewCellViewController.h"
#import "BeaconManager.h"
#import "TrendingListViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController
ReviewCellViewController *selectedCell;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)beaconFound{
    if (self.isViewLoaded && self.view.window) {
        NSLog(@"ProductDetailsController: Beacon detected!");
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
                                 [self performSegueWithIdentifier:@"reviewToTrendingPage" sender:self];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Register for beacon callbacks
    BeaconManager *manager = [BeaconManager getInstance];
    [manager initWithDelegate:self];
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CheckoutProduct"];
    _productList = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self updatePriceToolbar];
    [_cartTableView reloadData];
}

-(void)updatePriceToolbar{
    double price, totalPrice = 0.0;
    int quantity, totalQuantity = 0;
    NSLog(@"Count:%@", @([_productList count]).stringValue);
    for(int i = 0; i < [_productList count]; i++){
        price = [[_productList[i] valueForKey:@"price"] doubleValue];
        quantity = [[_productList[i] valueForKey:@"quantity"] intValue];
        totalPrice += price * quantity;
        totalQuantity += quantity;
    }
    _labelItemCount.text = @(totalQuantity).stringValue;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *totalPriceString = [formatter stringFromNumber:[NSNumber numberWithDouble:totalPrice]];
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%@", totalPriceString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_productList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    static NSString *simpleTableIdentifier = @"ReviewTableCell";    
    ReviewCellViewController *cell = (ReviewCellViewController *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    /*WalmartProductModel *model =  [_productList objectAtIndex:indexPath.row];
    NSArray *words = [model.productName componentsSeparatedByString:@" "];
    NSString *word = [[NSString alloc] init];
    for(int i = 0; i < [words count]; i++){
        if(i <= 3){
            word = [[word stringByAppendingString:words[i]] stringByAppendingString:@" "];
        }else{
            word = [word stringByAppendingString:@"..."];
            break;
        }
    }*/
    
    /*cell.labelProd.text = word;
    cell.labelPrice.text = @([model.price doubleValue]).stringValue;
    cell.labelQuantity.text = @([model.rating doubleValue]).stringValue;
    cell.labelTotalPrice.text = @([model.price doubleValue]).stringValue;*/
    
    NSManagedObject *product = [_productList objectAtIndex:indexPath.row];
    NSArray *words = [[product valueForKey:@"name"] componentsSeparatedByString:@" "];
    NSString *word = [[NSString alloc] init];
    for(int i = 0; i < [words count]; i++){
        if(i <= 3){
            word = [[word stringByAppendingString:words[i]] stringByAppendingString:@" "];
        }else{
            word = [word stringByAppendingString:@"..."];
            break;
        }
    }
    //[cell.labelProd setText:[NSString stringWithFormat:@"%@", [product valueForKey:@"name"]]];
    cell.labelProd.text = word;
    double price = [[product valueForKey:@"price"] doubleValue];
    int quantity = [[product valueForKey:@"quantity"] intValue];
    double totalPrice = price * quantity;
    [cell.labelQuantity setText:[NSString stringWithFormat:@"%@", @(quantity).stringValue]];
    [cell.labelPrice setText:[NSString stringWithFormat:@"$%@", @(price).stringValue]];
    cell.labelTotalPrice.text = [NSString stringWithFormat:@"$%@",@(totalPrice).stringValue];
    
    UIStepper *stepperQty = [[UIStepper alloc] init];
    //stepperQty.tag = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    stepperQty.tag = indexPath.row;
    //UIButton *mNewMsgDwn = [UIButton buttonWithType:UIButtonTypeCustom];
    //mNewMsgDwn.tag = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    //mNewMsgDwn.frame = CGRectMake(0, 0, 10, 10);
    stepperQty.frame = CGRectMake(150.0f, 65.0f, 80.0f, 35.0f);
    stepperQty.minimumValue = 0;
    stepperQty.stepValue = 1;
    stepperQty.value = quantity;
    //mNewMsgDwn.backgroundColor = [UIColor redColor];
    //[mNewMsgDwn setTitle:@"Hello" forState:UIControlStateNormal];
    [stepperQty addTarget:self action:@selector(selection:) forControlEvents:UIControlEventTouchDown];
    [cell.contentView addSubview:stepperQty];
    
    return cell;
}

- (void)selection:(id)sender
{
    UIStepper *b = (UIStepper *)sender;
    double quantity = b.value;
    NSLog(@"name; %@", @(quantity).stringValue);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:b.tag inSection:0];
    ReviewCellViewController *selCell = (ReviewCellViewController *)[_cartTableView cellForRowAtIndexPath:indexPath];
    [selCell.labelQuantity setText:[NSString stringWithFormat:@"%@", @(quantity).stringValue]];
    //double price = [selCell.labelPrice.text doubleValue];
    double price = [[[selCell.labelPrice.text componentsSeparatedByString:@"$"] objectAtIndex:1] doubleValue];
    double totalPrice = price * quantity;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    NSString *totalPriceString = [formatter stringFromNumber:[NSNumber numberWithDouble:totalPrice]];
    selCell.labelTotalPrice.text = [NSString stringWithFormat:@"$%@",totalPriceString];
    NSLog(@"Total Price: %@, price: %@, quantity; %@", @(totalPrice).stringValue, @(price).stringValue, @(quantity).stringValue);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *product = [_productList objectAtIndex:b.tag];
    NSNumber *quantityNum = [[NSNumber alloc] initWithDouble: quantity];
    [product setValue:quantityNum forKey:@"quantity"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    //NSInteger row = b.tag;
    //NSLog(@"%d", row);
    [self updatePriceToolbar];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReviewTableCell";
    selectedCell = (ReviewCellViewController *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    if (selectedCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableCell" owner:self options:nil];
        selectedCell = [nib objectAtIndex:0];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reviewToTrendingPage"]) {
        TrendingListViewController *destView = segue.destinationViewController;
        destView.sectionName = [BeaconManager getSectionName];
    }
}


- (IBAction)clearCart:(id)sender {
    [self clearCartLogic];
}

- (IBAction)checkout:(id)sender {
    //[self clearCartLogic];
}

-(void)clearCartLogic{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error = nil;
    while([_productList count] != 0){
    for(int i = 0; i < [_productList count]; i++){
        [context deleteObject:[_productList objectAtIndex:i]];
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [_productList removeObjectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_cartTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    }
    [self updatePriceToolbar];
}

@end
