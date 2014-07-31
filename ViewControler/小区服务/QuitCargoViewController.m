//
//  QuitCargoViewController.m
//  梧桐邑
//
//  Created by 陈磊 on 14-7-28.
//  Copyright (c) 2014年 赵恒. All rights reserved.
//

#import "QuitCargoViewController.h"

@interface QuitCargoViewController ()

@end

@implementation QuitCargoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self._quitView.layer.borderColor = [UIColor colorWithRed:0.68f green:0.69f blue:0.72f alpha:1.00f].CGColor;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self._quitView.frame.size.height/2, self._quitView.frame.size.width, 1)];
    imageView.image = [UIImage imageNamed:@"line.png"];
    [self._quitView addSubview:imageView];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
