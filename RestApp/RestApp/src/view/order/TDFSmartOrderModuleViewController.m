//
//  TDFSmartOrderModuleViewController.m
//  RestApp
//
//  Created by 黄河 on 2016/10/25.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFSmartOrderModuleViewController.h"
#import "SmartOrderModel.h"
#import "SystemUtil.h"
#import "UIView+Sizes.h"
@interface TDFSmartOrderModuleViewController ()

@end

@implementation TDFSmartOrderModuleViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSmartOrderModel];
}

-(void)loadSmartOrderModel
{
    SmartOrderModel *orderModule =[[SmartOrderModel alloc]initWithNibName:@"SmartOrderModel" bundle:nil parent:self];
   
    orderModule.back = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:orderModule.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
