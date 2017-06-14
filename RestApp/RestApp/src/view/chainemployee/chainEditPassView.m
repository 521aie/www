//
//  chainEditPassView.m
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "chainEditPassView.h"
#import "ServiceFactory.h"
#import "MBProgressHUD.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "EditItemText.h"
#import "EditItemView.h"


@implementation chainEditPassView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"密码修改", nil);
    self.needHideOldNavigationBar = YES;
    [self loadData:self.user employee:self.employee];
}

-(void) rightNavigationButtonAction:(id)sender{
    [self save];
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

-(void) loadData:(UserVO*) tempVO employee:(Employee *)employee{
    [self.lblName initData:tempVO.userName withVal:tempVO._id];
    [self.txtPass initData:nil];
    [self.txtPassConfirm initData:nil];
    [self configNavigationBar:YES];
}

-(void)showView{
    [UIHelper ToastNotification:NSLocalizedString(@"保存成功!", nil) andView:self.navigationController.view  andLoading:NO andIsBottom:NO];
    [UIHelper clearChange:self.container];
    [self configNavigationBar:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
