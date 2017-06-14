//
//  ChainBusinessView.h
//  RestApp
//
//  Created by iOS香肠 on 16/1/18.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "FooterListView.h"
#import "ChainService.h"
#import "ServiceFactory.h"
#import "BrandVo.h"

@class EditItemText,MBProgressHUD;
@interface ChainBusinessView : TDFRootViewController
{
    MBProgressHUD *hud;
    ChainService *chainService;
}

@property (nonatomic, weak) IBOutlet UIView *container;
@property (nonatomic, weak) IBOutlet EditItemText *txtShopName;
@property (nonatomic, weak) IBOutlet EditItemText *txtLinker;
@property (nonatomic, weak) IBOutlet EditItemText *txtMobile;
@property (strong, nonatomic) IBOutlet EditItemText *txtAddreess;
@property (nonatomic, strong) BrandVo *brandVo;
@property (nonatomic) BOOL changed;

-(void) loadData;
@end
