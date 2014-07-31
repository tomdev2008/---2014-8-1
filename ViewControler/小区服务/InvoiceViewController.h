//
//  InvoiceViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-7-8.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InvoiceViewControllerDelegate <NSObject>

- (void)changeAddressAndInvoiceInfoWithName:(NSString *)name;

@end

@interface InvoiceViewController : UIViewController

@property (nonatomic) __weak id <InvoiceViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *contentText;

- (IBAction)yesClick:(id)sender;
@property (nonatomic, strong) void (^invoiceBlock) (NSString *content);

@end
