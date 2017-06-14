//
//  ShopTemplateEditView.m
//  RestApp
//
//  Created by zxh on 14-4-16.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopTemplateEditView.h"
#import "SettingService.h"
#import "SettingModule.h"
#import "UIHelper.h"
#import "NavigateTitle.h"
#import "RemoteEvent.h"
#import "SettingModuleEvent.h"
#import "EditItemList.h"
#import "EditItemView.h"
#import "JsonHelper.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "RemoteResult.h"
#import "ShopTemplateListView.h"
#import "AlertBox.h"
#import "SystemUtil.h"
#import "ShopTemplate.h"
#import "AlertBox.h"
#import "NameItemVO.h"
#import "GlobalRender.h"
#import "ShopTemplateRender.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "UIView+Sizes.h"
#import "XHAnimalUtil.h"
#import "NavigateTitle2.h"
#import "PrintTemplateVO.h"
#import "HelpDialog.h"
#import "TDFSettingService.h"
#import "TDFOptionPickerController.h"
#import "TDFRootViewController+FooterButton.h"
@implementation ShopTemplateEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        service = [ServiceFactory Instance].settingService;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needHideOldNavigationBar = YES;
    
    self.changed=NO;
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData:self.shopTemplate action:self.action];
    [self generateFooterButtonWithTypes:TDFFooterButtonTypeHelp];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"收银单据", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}

- (void) rightNavigationButtonAction:(id)sender
{
    [self save];
}

-(void) initMainView
{
    [self.lblType initLabel:NSLocalizedString(@"单据类型", nil) withHit:nil];
    [self.lsWidth initLabel:NSLocalizedString(@"纸张宽度", nil) withHit:nil delegate:self];
    [self.lsTemplate initLabel:NSLocalizedString(@"▪︎ 选择模板", nil) withHit:nil isrequest:YES delegate:self];
    
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.imgView.contentMode=UIViewContentModeTopLeft;
    
    self.lsWidth.tag=1;
    self.lsTemplate.tag=2;
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_ShopTemplateEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_ShopTemplateEditView_Change object:nil];
}

#pragma remote
- (void)loadData:(ShopTemplate *)tempVO action:(NSInteger)action
{
    self.printVO=nil;
    self.title=tempVO.kindPrintTemplateName;
    [self clearDo];
    [self fillModel];
    [self.titleBox editTitle:NO act:self.action];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.lsWidth initData:nil withVal:nil];
    [self.lsTemplate initData:nil withVal:nil];
}

- (void)fillModel
{
    [self.lblType initData:[ShopTemplateRender objtainKindName:self.shopTemplate.kind] withVal:[NSString stringWithFormat:@"%d",self.shopTemplate.kind]];
    NSString *itemName = [GlobalRender obtainItem:[ShopTemplateRender listWidth] itemId:[NSString stringWithFormat:@"%d",self.shopTemplate.lineWidth]];
    [self.lsWidth initData:itemName withVal:[NSString stringWithFormat:@"%d",self.shopTemplate.lineWidth]];
    itemName = [NSString isBlank:self.shopTemplate.name]?NSLocalizedString(@"默认", nil):self.shopTemplate.name;
    [self.lsTemplate initData:itemName withVal:[NSString isBlank:self.shopTemplate.name]?NSLocalizedString(@"默认", nil):self.shopTemplate.printTemplateId];
    [self fillImage:[NSString isBlank:self.shopTemplate.filePath]?@"":self.shopTemplate.filePath];
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

-(void) fillImage:(NSString*)path
{
//    if ([NSString isNotBlank:path]) { //太慢了
//        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:path]
//                                                            options:0
//                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
//         {
//             
//         }
//                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//         {
//             if (image && finished) {
//                 float imgHeight=image.size.height;
//                 float imgWidth=image.size.width;
//                 
//                 float heightVal= (imgHeight*300) / imgWidth+20;
//                 [self.imgView setWidth:300];
//                 [self.imgView setHeight:heightVal];
//                 CGSize size = CGSizeMake(300.0f, heightVal);
//                 image=[UIHelper scaleToSize:image size:size];
//                 [self.imgView setImage:image];
//                 
//                 [UIHelper refreshPos:self.container scrollview:self.scrollView];
//                 [UIHelper clearColor:self.container];
//             }
//         }];
//    } else {
//        [self.imgView setImage:nil];
//    }
    if ([NSString isNotBlank: path]) {
         [self.imgView  sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             if (image ) {
                 float imgHeight=image.size.height;
                 float imgWidth=image.size.width;
                 float heightVal= (imgHeight*(SCREEN_WIDTH - 20)) / imgWidth+20;
                 [self.imgView setWidth:SCREEN_WIDTH - 20];
                 [self.imgView setHeight:heightVal];
                 CGSize size = CGSizeMake((SCREEN_WIDTH - 20), heightVal);
                 image=[UIHelper scaleToSize:image size:size];
                 [self.imgView setImage:image];
                 
                 [UIHelper refreshPos:self.container scrollview:self.scrollView];
                 [UIHelper clearColor:self.container];
             }
           
         }];
    }  else{
        [self.imgView setImage:nil];
    }
    
    
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
    [self configNavigationBar:[UIHelper currChange:self.container]];
}

- (void)remoteFinsh:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    self.callBack(YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)remoteTemplateFinsh:(RemoteResult *)result
{
    [self.progressHud hide:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    
    NSDictionary* map=[JsonHelper transMap:result.content];
    NSArray *list = [map objectForKey:@"printTemplates"];
    self.printTemplates=[JsonHelper transList:list objName:@"PrintTemplateVO"];
    
    if (self.printTemplates==nil || self.printTemplates.count==0) {
        [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"当前纸张宽度[%@]下，没有打印模板!", nil),self.lsWidth.lblVal.text]];
        return;
    }
//    
//    [OptionPickerBox initData:self.printTemplates itemId:[self.lsTemplate getStrVal]];
//    [OptionPickerBox show:self.lsTemplate.lblName.text client:self event:self.lsTemplate.tag];
    
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.lsTemplate.lblName.text
                                                                              options:self.printTemplates
                                                                        currentItemId:[self.lsTemplate getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:wself.printTemplates[index] event:self.lsTemplate.tag];
    };

    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
}

#pragma test event
#pragma edititemlist click event.
- (void)onItemListClick:(EditItemList *)obj
{
    [SystemUtil hideKeyboard];
    if (obj.tag==1) {
//        [OptionPickerBox initData:[ShopTemplateRender listWidth] itemId:[obj getStrVal]];
//        [OptionPickerBox show:obj.lblName.text client:self event:obj.tag];
        TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                              options:[ShopTemplateRender listWidth]
                                                                                currentItemId:[obj getStrVal]];
        __weak __typeof(self) wself = self;
        pvc.competionBlock = ^void(NSInteger index) {
            
            [wself pickOption:[ShopTemplateRender listWidth][index] event:obj.tag];
        };

        [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        
    } else {
        if ([self.lsWidth.lblVal.text isEqualToString:NSLocalizedString(@"可不填", nil)]) {
            [AlertBox show:NSLocalizedString(@"请先选择纸张宽度.", nil)];
            return;
        }

        [self showProgressHudWithText:NSLocalizedString(@"正在加载", nil)];
        [[TDFSettingService new] listPrintTemplateVOs:self.shopTemplate.templateType lineWidth:[self.lsWidth getStrVal] sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
            [self.progressHud hide:YES];
          
            NSArray *list = [data objectForKey:@"data"];
            self.printTemplates=[JsonHelper transList:list objName:@"PrintTemplateVO"];
            
            if (self.printTemplates==nil || self.printTemplates.count==0) {
                [AlertBox show:[NSString stringWithFormat:NSLocalizedString(@"当前纸张宽度[%@]下，没有打印模板!", nil),self.lsWidth.lblVal.text]];
                return;
            }
                        
            TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.lsTemplate.lblName.text
                                                                                          options:self.printTemplates
                                                                                    currentItemId:[self.lsTemplate getStrVal]];
            __weak __typeof(self) wself = self;
            pvc.competionBlock = ^void(NSInteger index) {
                
                [wself pickOption:wself.printTemplates[index] event:self.lsTemplate.tag];
            };
            
            [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];

    }
}

- (BOOL)pickOption:(id)item event:(NSInteger)event
{
    id<INameItem> vo=(id<INameItem>)item;
    if (event==1) {
        [self.lsWidth changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        [self.lsTemplate changeData:nil withVal:nil];
        [self.imgView setHeight:0];
        [self.imgView setImage:nil];
        [UIHelper refreshPos:self.container scrollview:self.scrollView];
        [UIHelper clearColor:self.container];
    } else {
        self.printVO=(PrintTemplateVO*)item;
        [self.lsTemplate changeData:[vo obtainItemName] withVal:[vo obtainItemId]];
        if ( [NSString isBlank:[vo obtainItemId]]) {
            [self.lsTemplate changeData:NSLocalizedString(@"默认", nil) withVal:NSLocalizedString(@"默认", nil)];
            self.lsTemplate.lblVal.textColor = [UIColor colorWithRed:16/255.0 green:136/255.0 blue:204/255.0 alpha:1];
        }
       [self fillImage:self.printVO.filePath];
    }
    return YES;
}

-(ShopTemplate*) transMode
{
    ShopTemplate* tempUpdate=[ShopTemplate new];
    if (self.printVO==nil) {
        tempUpdate=self.shopTemplate;
        tempUpdate.lineWidth=[self.lsWidth getStrVal].intValue;
        return tempUpdate;
    }
    if (self.printVO.lineWidth==0) {
        tempUpdate.lineWidth=0;
    } else {
        tempUpdate.lineWidth=[self.lsWidth getStrVal].intValue;
    }
    tempUpdate.printTemplateId=self.printVO._id;
    tempUpdate.name=self.printVO.name;
    tempUpdate.templateType=self.printVO.templateType;
    tempUpdate.printMode=self.printVO.printMode;
    tempUpdate.templateSource=self.printVO.templateSource;
    tempUpdate.kind=self.shopTemplate.kind;
    return tempUpdate;
}


- (BOOL)isVail
{
    if ([NSString isBlank:[self .lsTemplate getStrVal]] ) {
        [AlertBox show:NSLocalizedString(@"模板不能为空!", nil)];
        return NO;
    }
    return YES;
}

-(void)save
{
    if (![self isVail]) {
        return;
    }
    ShopTemplate* objTemp=[self transMode];
    NSString* tip=NSLocalizedString(@"正在更新单据模板", nil);
    [self showProgressHudWithText:tip];
    objTemp.id  =  self.shopTemplate.id;
    [[TDFSettingService new] updateShopTemplate:objTemp sucessBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        [self.progressHud hide:YES];
        self.callBack(YES);
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.progressHud hide:YES];
        [AlertBox show:error.localizedDescription];
    }];
}

-(void) footerHelpButtonAction:(UIButton *)sender
{
    [HelpDialog show:@"shoptemplate"];
}

@end

