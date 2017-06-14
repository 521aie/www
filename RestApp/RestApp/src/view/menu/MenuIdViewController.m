//
//  MenuIdViewController.m
//  RestApp
//
//  Created by zishu on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuIdViewController.h"
#import "AlertImageView.h"

@implementation MenuIdViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"商品ID", nil);
    [self initMainView];
    [self loadMenuName:self.menuName menuId:self.menuId];
}

- (void) initMainView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bgView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  5, self.view.frame.size.width - 20, 20)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.nameLabel];
    
    self.idLbel = [[CopyFounctionLabel alloc] initWithFrame:CGRectMake(10,  28, self.view.frame.size.width - 20, 20)];
    self.idLbel.backgroundColor = [UIColor clearColor];
    self.idLbel.font = [UIFont systemFontOfSize:13];
    self.idLbel.textColor = [UIColor darkGrayColor];
    self.idLbel.delegate = self;
    [self.view addSubview:self.idLbel];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 1)];
    self.line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:self.line];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  60, self.view.frame.size.width - 20, 80)];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.font = [UIFont systemFontOfSize:11];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.tipLabel.text = NSLocalizedString(@"1.此号码为二维火商品内部ID，可以复制使用。\n2.当您在口碑商户后台发布优惠券时，可以复制此商品ID并填入完成发券。", nil);
    [self.view addSubview:self.tipLabel];
}

- (void) loadMenuName:(NSString *)menuName menuId:(NSString *)menuId
{
    self.nameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@商品ID（长按可复制）", nil),menuName];
    self.idLbel.text = menuId;
    
    [self layoutMainView];
    [[NSUserDefaults standardUserDefaults] setValue:menuId forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)layoutMainView
{
    CGRect rect = self.nameLabel.frame;
    CGRect nameRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    rect.size.height = nameRect.size.height;
    self.nameLabel.frame = rect;
    
    self.idLbel.frame = CGRectMake(10,  self.nameLabel.frame.origin.y + rect.size.height + 2, self.view.frame.size.width - 20, 20);
    
    self.line.frame = CGRectMake(0,  self.nameLabel.frame.origin.y + rect.size.height + 2 + 20, self.view.frame.size.width , 1);
    
     self.tipLabel.frame = CGRectMake(10,  self.nameLabel.frame.origin.y + rect.size.height + 12, self.view.frame.size.width-20 , 80);
}

 -(void)copyEventFininshed
{
    NSString* url=[[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    [[UIPasteboard generalPasteboard] setPersistent:YES];
    [[UIPasteboard generalPasteboard] setValue:url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
    
    AlertTextView * alertView = [[AlertTextView alloc]initWithContent:NSLocalizedString(@"商品ID已复制成功，可粘贴使用", nil) location:[UIApplication sharedApplication].keyWindow.center];
    [alertView setBackColor:[UIColor blackColor] alpha:0.7  textColor:[UIColor whiteColor]];
    [alertView setViewSizeFont:nil label:220];
    [alertView showAlertView];
    [alertView dismissAfterTimeInterval:3.0f alertFinish:nil];
}

- (void) leftNavigationButtonAction:(id)sender
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
