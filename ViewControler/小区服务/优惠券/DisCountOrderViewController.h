//
//  DisCountOrderViewController.h
//  梧桐邑
//
//  Created by 陈磊 on 14-6-19.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisCountOrderViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray * discountOrderArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@property (weak, nonatomic) IBOutlet UILabel *pointLable;
@property (nonatomic, strong) NSString *couTitlte;
@property (nonatomic, strong) NSString *couPrice;
@property (nonatomic, strong) NSString *couNum;
@property (nonatomic, strong) NSString *couTotal;

@property (nonatomic, strong) NSString *did;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *diLabel;
@property (weak, nonatomic) IBOutlet UILabel *yingLabel;


- (IBAction)plusClick:(id)sender;
- (IBAction)reduceClick:(id)sender;
- (IBAction)orderClic:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textJifen;


@end
