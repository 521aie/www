//
//  SeatEditView.m
//  RestApp
//
//  Created by zxh on 14-4-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "JSONKit.h"
#import "ZMTable.h"
#import "AlertBox.h"
#import "Platform.h"
#import "UIHelper.h"
#import "DateUtils.h"
#import "ItemTitle.h"
#import "HelpDialog.h"
#import "SystemUtil.h"
#import "NumberUtil.h"
#import "MessageBox.h"
#import "JsonHelper.h"
#import "ZmTableCell.h"
#import "RemoteEvent.h"
#import "ColorHelper.h"
#import "CalendarBox.h"
#import "SystemEvent.h"
#import "MemoInputBox.h"
#import "EditItemMemo.h"
#import "EditItemView.h"
#import "XHAnimalUtil.h"
#import "EditItemList.h"
#import "MarketModule.h"
#import "RemoteResult.h"
#import "EditItemRadio.h"
#import "RestConstants.h"
#import "EventConstants.h"
#import "ServiceFactory.h"
#import "LifeInfoEditView.h"
#import "NSString+Estimate.h"
#import "EnvelopeModuleEvent.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TDFMemberService.h"
#import "YYModel.h"
#import "TDFOptionPickerController.h"

@implementation LifeInfoEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(MarketModule *)parentTemp;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        service = [ServiceFactory Instance].lifeInfoService;
        systemService = [ServiceFactory Instance].systemService;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
        imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigate];
    [self initNotifaction];
    [self initMainView];
    [self loadData];
}

#pragma navigateTitle.
- (void)initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];
    [self.titleBox initWithName:NSLocalizedString(@"发布生活圈消息", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_PUBLISH];
    
    self.title = NSLocalizedString(@"发布生活圈消息", nil);
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_PUBLISH rightButtonName:NSLocalizedString(@"发布", nil)];
}

-(void)leftNavigationButtonAction:(id)sender{
    [self alertChangedMessage:[UIHelper currChange:self.container]];
}
-(void)rightNavigationButtonAction:(id)sender{
    [super rightNavigationButtonAction:sender];
    [self save];
}



- (void)onNavigateEvent:(NSInteger)event
{
    if (event==1) {
        [parent showView:LIFE_INFO_LIST_VIEW];
        [XHAnimalUtil animal:parent type:kCATransitionPush direct:kCATransitionFromBottom];
    } else {
        [self save];
    }
}

- (void)initMainView
{
    [self.txtContent initLabel:NSLocalizedString(@"详细内容", nil) isrequest:YES delegate:self];
    [self.txtTitle initLabel:NSLocalizedString(@"标题", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
    [self.lsKindCard initLabel:NSLocalizedString(@"发送人群范围", nil) withHit:nil isrequest:YES delegate:self];
    [self.imgUpload initLabel:NSLocalizedString(@"图片", nil) withHit:nil delegate:self];
    self.lsKindCard.tag = 1;
    
    [UIHelper refreshPos:self.container scrollview:self.scrollView];
    [UIHelper clearColor:self.container];
}

#pragma notification 处理.
- (void)initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_EnvelopeEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_EnvelopeEditView_Change object:nil];

}

- (void)loadData
{
    [self clearDo];

    imgFilePathTemp = @"";
//    [self.titleBox editTitle:NO act:self.action];
//    [self.scrollView setContentOffset:CGPointMake(0,0)];
    
    [self.indicator startAnimating];
    [self.indicator setHidden:NO];
    [service listNoteCountData:@"0" target:self callback:@selector(noteCountFinsih:)];
}

#pragma 数据层处理
- (void)clearDo
{
    [self.txtTitle initData:nil];
    [self.lsKindCard initData:NSLocalizedString(@"全部", nil) withVal:@"0"];
    [self.txtContent initData:nil];
    [self.imgUpload initView:nil path:nil];
    
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma 做好界面变动的支持.
- (void)dataChange:(NSNotification *)notification
{
   [self.titleBox editTitle:[UIHelper currChange:self.container] act:ACTION_CONSTANTS_ADD];
}

#pragma 做好界面变动的支持.
- (void)remoteFinsih:(RemoteResult *) result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.callback) {
        self.callback();
    }
}

- (void)uploadFinsih:(RemoteResult *) result
{
    [hud hide:YES];

    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    [self.imgUpload changeImg:imgFilePathTemp img:notificationImage];
}

- (void)noteCountFinsih:(RemoteResult *) result
{
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }
    NSDictionary *map = [JsonHelper transMap:result.content];
    NSString *noteCount = [map objectForKey:@"data"];
    NSString *countInfo = [NSString stringWithFormat:NSLocalizedString(@"将有%@个本店会员通过\"火小二\"应用收到这条消息", nil), noteCount];
    
    [self.lsKindCard initHit:countInfo];
    self.lsKindCard.lblDetail.textColor = [UIColor redColor];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

#pragma save-data
- (BOOL)isValid
{
    if ([NSString isBlank:[self.txtTitle getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"标题不能为空!", nil)];
        return NO;
    }
    
    if ([self.txtTitle getStrVal].length>30) {
        [AlertBox show:NSLocalizedString(@"标题字数不能超过30个字!", nil)];
        return NO;
    }
    
    if ([NSString isBlank:[self.txtContent getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"详细内容不能为空!", nil)];
        return NO;
    }
    
    if ([self.txtContent getStrVal].length>250) {
        [AlertBox show:NSLocalizedString(@"详细内容不能超过250个字!", nil)];
        return NO;
    }
    
    return YES;
}

- (Notification *)transMode
{
    NSString *entityId = [[Platform Instance]getkey:ENTITY_ID];
    
    Notification *notification = [Notification new];
    notification.entityId = entityId;
    notification.name = [self.txtTitle getStrVal];
    notification.memo = [self.txtContent getStrVal];
    notification.kindCardId = [self.lsKindCard getStrVal];
    
    return notification;
}

- (void)save
{
    if ([self isValid]) {
        notificationData = [self transMode];
        NSString *publishTip = [NSString stringWithFormat:NSLocalizedString(@"确定要发布这条消息吗?", nil)];
        [MessageBox show:publishTip client:self];
    }
}

- (void)onItemListClick:(EditItemList *)obj
{
    [SystemUtil hideKeyboard];
    if (obj==self.lsKindCard) {
        [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:self.view andHUD:hud];
        NSMutableDictionary *parma = [[NSMutableDictionary alloc] init];
        parma[@"is_need_all"] = @"false";
        @weakify(self);
        [[TDFMemberService new] listKindCardDataWithParam:parma sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            @strongify(self);
            [hud hide:YES];
            NSMutableArray *kindList = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[KindCard class] json:data[@"data"]]];
            KindCard *allKind = [[KindCard alloc]init];
            allKind.name = NSLocalizedString(@"全部", nil);
            allKind.id = @"0";
            [kindList insertObject:allKind atIndex:0];
            TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:NSLocalizedString(@"指定卡类型", nil)
                                                                                          options:kindList
                                                                                    currentItemId:[self.lsKindCard getStrVal]];
            __weak __typeof(self) wself = self;
            pvc.competionBlock = ^void(NSInteger index) {
                
                [wself pickOption:kindList[index] event:self.lsKindCard.tag];
            };
            
            [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [hud hide:YES];
            [AlertBox show:error.localizedDescription];
        }];
    }
}

- (void)onItemRadioClick:(EditItemRadio*)obj
{
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (void)onItemMemoListClick:(EditItemMemo*)obj
{
    [MemoInputBox show:1 delegate:self title:NSLocalizedString(@"详细内容", nil) val:[self.txtContent getStrVal]];
}

- (void)finishInput:(NSInteger)event content:(NSString*)content
{
    [self.txtContent changeData:content];
    [UIHelper refreshUI:self.container scrollview:self.scrollView];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType
{
    KindCard *kindCard = (KindCard *)selectObj;
    kindCard._id = kindCard.id;
    [self.lsKindCard changeData:kindCard.name withVal:kindCard.id];
    [self.indicator startAnimating];
    [self.indicator setHidden:NO];
     [service listNoteCountData:kindCard.id target:self callback:@selector(noteCountFinsih:)];
    
    return YES;
}

- (void)onConfirmImgClick:(NSInteger)btnIndex
{
    if (btnIndex==1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [AlertBox show:NSLocalizedString(@"相机好像不能用哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if(btnIndex==0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [AlertBox show:NSLocalizedString(@"相册好像不能访问哦!", nil)];
            return;
        }
        NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //添加到集合中
    notificationImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString* entityId=[[Platform Instance] getkey:ENTITY_ID];
    
    imgFilePathTemp = [NSString stringWithFormat:@"%@/notification/%@.png",entityId,[NSString getUniqueStrByUUID]];
    [UIHelper showHUD:NSLocalizedString(@"正在上传", nil) andView:self.view andHUD:hud];

     [systemService uploadImage:imgFilePathTemp image:notificationImage width:1280 heigth:1280 Target:self Callback:@selector(uploadFinsih:)];
}

- (void)onDelImgClick
{
    imgFilePathTemp = @"";
    [self.imgUpload changeImg:nil img:nil];
}

- (void)confirm
{    
    [UIHelper showHUD:NSLocalizedString(@"正在发布", nil) andView:self.view andHUD:hud];
     [service saveNotification:notificationData filePath:imgFilePathTemp target:self callback:@selector(remoteFinsih:)];
}

- (void)showHelpEvent
{
    [HelpDialog show:@"coupon"];
}

@end
