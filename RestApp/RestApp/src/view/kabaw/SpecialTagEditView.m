//
//  TasteEditView.m
//  RestApp
//
//  Created by zxh on 14-5-9.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SpecialTagEditView.h"
#import "SpecialTagListView.h"
#import "NSString+Estimate.h"
#import "ServiceFactory.h"
#import "TDFKabawService.h"
#import "XHAnimalUtil.h"
#import "RemoteResult.h"
#import "KabawModule.h"
#import "RemoteEvent.h"
#import "HelpDialog.h"
#import "JsonHelper.h"
#import "UIHelper.h"
#import "AlertBox.h"

@implementation SpecialTagEditView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SpecialTagModule *)parentTemp moduleName:(NSString *)moduleNameTemp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parent = parentTemp;
        moduleName = moduleNameTemp;
         service = [ServiceFactory Instance].kabawService;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNotifaction];
    [self initNavigate];
    [self initMainView];
    [self createData];
}

#pragma navigateTitle.
-(void) initNavigate
{
    self.titleBox=[[NavigateTitle2 alloc]initWithNibName:@"NavigateTitle2" bundle:nil delegate:self];
    [self.titleDiv addSubview:self.titleBox.view];

    self.title = NSLocalizedString(@"特色标签", nil);
   // [self.titleBox initWithName:NSLocalizedString(@"特色标签", nil) backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
}

-(void) initMainView
{
    [self.txtName initLabel:NSLocalizedString(@"标签名称", nil) withHit:nil isrequest:YES type:UIKeyboardTypeDefault];
}

-  (void)createData
{
    if ([ObjectUtil isNotEmpty:self.dic]) {
        id delegate  = self.dic [@"delegate"];
        self.delegate  = delegate;
        NSString *actionStr  = self.dic [@"action"];
        SpecialTagVO * obj   = self.dic [@"data"];
        NSArray *dataArry  = self.dic [@"arry"];
        [self loadData:obj action:actionStr.intValue arry:dataArry];
    }
}


#pragma notification 处理.
-(void) initNotifaction
{
    [UIHelper initNotification:self.container event:Notification_UI_SpecialTagEditView_Change];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:Notification_UI_SpecialTagEditView_Change object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:[REMOTE_SPECIAL_TAG_SAVE stringByAppendingString:moduleName] object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:[REMOTE_SPECIAL_TAG_UPDATE stringByAppendingString:moduleName] object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteFinsh:) name:[REMOTE_SPECIAL_TAG_DELETE stringByAppendingString:moduleName] object:nil];
}

-(void) onNavigateEvent:(NSInteger)event
{
    if (event==DIRECT_LEFT) {
        [parent showView:SPECIAL_TAG_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
    } else if (event==DIRECT_RIGHT) {
        [self save];
    }
}


- (void)leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavigationButtonAction:(id)sender
{
    [self save] ;
}


#pragma remote
- (void)loadData:(SpecialTagVO *) objTemp action:(int)action arry:(NSArray *)arry
{
    [self.progressHud hide:YES];
    
    self.action=action;
    self.dataArry =arry;
    self.specialTag=objTemp;
    [self.delView setHidden:action==ACTION_CONSTANTS_ADD];
    if (action==ACTION_CONSTANTS_ADD) {
        self.titleBox.lblTitle.text=NSLocalizedString(@"添加标签", nil);
        [self clearDo];
    } else {
        self.titleBox.lblTitle.text=self.specialTag.specialTagName;
        [self fillModel];
    }
    //[self.titleBox editTitle:NO act:ACTION_CONSTANTS_EDIT];
    if (self.action  == ACTION_CONSTANTS_ADD) {
        [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil) ];
        [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    }
}

#pragma 数据层处理
-(void) clearDo
{
    [self.txtName initData:nil];
}

-(void) fillModel
{
    [self.txtName initData:self.specialTag.specialTagName];
    self.btnDel.hidden = (self.specialTag.tagSource==SPECIALTAG_SYS);
}

#pragma 做好界面变动的支持.
-(void) dataChange:(NSNotification*) notification
{
    if (self.action == ACTION_CONSTANTS_EDIT) {
        [self configNavigationBar: [UIHelper currChange:self.container]];
    }
    
}

#pragma save-data
-(BOOL)isValid
{
    if ([NSString isBlank:[self.txtName getStrVal]]) {
        [AlertBox show:NSLocalizedString(@"标签名称不能为空!", nil)];
        return NO;
    }
    //    NSString *str = [[self.txtName getStrVal] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSInteger a = [self lengthOfChineseWithString:[self.txtName getStrVal]];
    if (a > 4) {
        [AlertBox show:NSLocalizedString(@"不能超过8个字符", nil)];
        return NO;
    }
    for ( SpecialTagVO *Vo  in self.dataArry) {
        if ([Vo.specialTagName isEqualToString:[self.txtName getStrVal]]) {
            [AlertBox show:NSLocalizedString(@"标签名称重复!", nil)];
            return NO;
        }
    }
    return YES;
}

- (NSInteger)lengthOfChineseWithString:(NSString *)text
{
    NSInteger length = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    length -= (length - text.length) / 2;
    length = (length +1) / 2;
    return length;
}

- (int)charNumber:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}


-(SpecialTagVO *) transModel
{
    SpecialTagVO* objUpdate=[SpecialTagVO new];
    objUpdate.specialTagName=[self.txtName getStrVal];
    return objUpdate;
}

-(void)save
{
    if (![self isValid]) {
        return;
    }
    SpecialTagVO* specialTag=[self transModel];
    NSString* tip=[NSString stringWithFormat:NSLocalizedString(@"正在%@", nil),self.action==ACTION_CONSTANTS_ADD?NSLocalizedString(@"保存", nil):NSLocalizedString(@"更新", nil)];
    [UIHelper showHUD:tip andView:self.view andHUD:self.progressHud];

    if (self.action==ACTION_CONSTANTS_ADD) {
//        [service saveSpecialTag:specialTag.specialTagName event:[REMOTE_SPECIAL_TAG_SAVE stringByAppendingString:moduleName]];
        //[service saveSpecialTag:specialTag.specialTagName Target:self callback:@selector(remoteFinsh:)];
        [[TDFKabawService new] saveSpecialTag:specialTag.specialTagName sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud hide: YES];
             [self remoteFinsh:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud  hide: YES];
            [AlertBox show:error.localizedDescription];
        }];
    } else {
        specialTag.specialTagId=self.specialTag.specialTagId;
//        [service updateSpecialTag:specialTag event:[REMOTE_SPECIAL_TAG_UPDATE stringByAppendingString:moduleName]];
//         [service updateSpecialTag:specialTag Target:self callback:@selector(remoteFinsh:)];
         [[TDFKabawService new]  updateSpecialTag:specialTag sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
              [self.progressHud hide:YES];
              [self remoteFinsh:data];
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             [self.progressHud  hide: YES];
             [AlertBox show:error.localizedDescription];
         }];
    }
}

-(IBAction)btnDelClick:(id)sender
{
    [UIHelper alert:self.view andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),self.specialTag.specialTagName]];
}

//删除确认.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {

       [UIHelper showHUD:[NSString stringWithFormat:NSLocalizedString(@"正在删除[%@]", nil),self.specialTag.specialTagName] andView:self.view andHUD:self.progressHud];
        [[TDFKabawService new] deleteSpecialTag:self.specialTag.specialTagId sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
            [self.progressHud  hide: YES];
            [self remoteFinsh:data];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.progressHud hide: YES];
            [AlertBox show:error.localizedDescription];
        }];;

    }
}

-(void)remoteFinsh:(id) data
{
    NSMutableArray *specialTagDataList = [[NSMutableArray alloc]init];
   [specialTagDataList addObject:[[SpecialTagVO alloc]initWithData:@"" name:NSLocalizedString(@"不设定", nil) sortCode:1 source:1]];
    NSArray *specialTagList = data [@"data"];

    if ([ObjectUtil isNotEmpty:specialTagList]) {
        for (NSDictionary *specialTagDic in specialTagList) {
            NSString *specialTagId = [specialTagDic objectForKey:@"specialTagId"];
            NSString *specialTagName = [specialTagDic objectForKey:@"specialTagName"];
            NSInteger sortCode = [[specialTagDic objectForKey:@"sortCode"] integerValue];
            short tagSource = [[specialTagDic objectForKey:@"tagSource"] integerValue];
            SpecialTagVO *specialTagItem = [[SpecialTagVO alloc]initWithData:specialTagId name:specialTagName sortCode:sortCode source:tagSource];
            [specialTagDataList addObject:specialTagItem];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SpecialTagData_Change object:nil];
    if (!parent) {
        if (self.delegate) {
            NSString *actionStr  = [NSString stringWithFormat:@"%d",self.action];
            [self.delegate navitionToPushBeforeJump:actionStr data:specialTagDataList];
        }
       [self.navigationController  popViewControllerAnimated:YES] ;
        [self configNavigationBar:NO];
    }
    else
    {
        [parent showView:SPECIAL_TAG_LIST_VIEW];
        [XHAnimalUtil animalEdit:parent action:self.action];
        [parent.specialTagListView initWithData:specialTagDataList];
    }
}

-(void) showHelpEvent
{
    [HelpDialog show:@"sepcialTag"];
}




@end

