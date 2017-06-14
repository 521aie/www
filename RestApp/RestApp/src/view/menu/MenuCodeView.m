//
//  MenuCodeView.m
//  RestApp
//
//  Created by xueyu on 16/6/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "MenuCodeView.h"
#import "QRCodeGenerator.h"
#import "ServiceFactory.h"
#import "XHAnimalUtil.h"
#import "Menu.h"
#import "NSString+Estimate.h"
#import "MailInputBox.h"
#import "PropertyList.h"
#import "UIView+Sizes.h"
#import "AlertBox.h"
#define MENU_CODE_EMAIL @"MENU_CODE_EMAIL"
@interface MenuCodeView ()
@property (nonatomic, assign)MenuKind menuKind;
@end

@implementation MenuCodeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MenuModule *)parentTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].menuService;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCurrentView];
    [self initNavigate];
    [self createData];
}


- (void)initCurrentView
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)createData
{
    if ([ObjectUtil isNotEmpty: self.soureDic]) {
        id headListTemp = self.soureDic [@"headListTemp"];
        NSString *kindStr  =  [NSString stringWithFormat:@"%@",self.soureDic[@"kind"]];
        NSString *eventStr  = [NSString stringWithFormat:@"%@", self.soureDic [@"event"]];
        [self loadDataWithMenu:headListTemp kind:kindStr.intValue event:eventStr.intValue];
    }
}
#pragma mark  Navigate
- (void)initNavigate
{
    self.titleBox = [[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

    self.title = NSLocalizedString(@"菜肴二维码", nil);

  //  [self.titleBox initWithName:NSLocalizedString(@"菜肴二维码", nil) backImg:Head_ICON_BACK moreImg:nil];
}

- (void)onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        if (self.event == 1) {
            [parent showView:SUITMENU_EDIT_VIEW];
        }else{
         [parent showView:MENU_EDIT_VIEW];
        }
        [XHAnimalUtil animal:(UIViewController *)parent type:kCATransitionPush direct:kCATransitionFromLeft];
    }
}

- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 请求
-(void)loadDataWithMenu:(Menu*)menu kind:(MenuKind)kind event:(NSInteger) event{
    self.event = event;
    self.menuKind = kind;
    self.titleBox.lblTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@菜肴码", nil),menu.name];
    self.imgCode.image = nil;
    if ([NSString isBlank:menu.id]) {
        self.imgCode.hidden = YES;
        [self.supplementView setTop:100];
        return;
    }else{
        self.imgCode.hidden = NO;
        [self.supplementView setTop:270];
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
    [service loadMenuCode:menu.id target:self callback:@selector(loadFinish:)];
}

-(void)loadFinish:(RemoteResult *)result{

    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];

    NSDictionary *data = [map objectForKey:@"data"];
    if ([ObjectUtil isEmpty:data]) {
        return;
    }
    self.imgCode.image = [self menuCodeImage:data];
}

-(UIImage *)menuCodeImage:(NSDictionary *)dict{

    UIImage *img = [QRCodeGenerator qrImageForString:[dict objectForKey:@"shortUrl"] imageSize:self.imgCode.bounds.size.width];
    CGSize finalSize=CGSizeMake(400, 400);
    UIGraphicsBeginImageContext(finalSize);
    [img drawInRect:CGRectMake(25,25,350,350)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *menuName = self.menuKind == Kind_Menu?[dict objectForKey:@"menuName"]
:[NSString stringWithFormat:NSLocalizedString(@"%@(套餐)", nil),[dict objectForKey:@"menuName"]];
    [menuName drawInRect:CGRectMake(0, 10, 400, 40) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSParagraphStyleAttributeName:paragraphStyle}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return  newImage;
}
#pragma mark 下载二维码
- (IBAction)downloadMenuCode:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imgCode.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error){
        msg = NSLocalizedString(@"二维码下载失败", nil) ;
    }else{
        msg = NSLocalizedString(@"二维码下载成功", nil) ;
    }
    [AlertBox show:msg];
}



#pragma mark 发送二维码
- (IBAction)sendAllMenuCode:(id)sender {
    [MailInputBox show:1 delegate:self title:NSLocalizedString(@"输入EMAIL地址", nil) val:[PropertyList readValue: MENU_CODE_EMAIL] isPresentMode:YES];
}

-(void) finishInput:(NSInteger)event content:(NSString*)content{
    
    [PropertyList updateValue:content forKey:MENU_CODE_EMAIL];
    [UIHelper showHUD:NSLocalizedString(@"正在发送", nil) andView:self.view andHUD:hud];
    [service sendMenuCodes:content target:self callback:@selector(sendFinish:)];
}

-(void)sendFinish:(RemoteResult *)result{
    
    [hud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [AlertBox show:NSLocalizedString(@"发送成功", nil)];
}
@end
