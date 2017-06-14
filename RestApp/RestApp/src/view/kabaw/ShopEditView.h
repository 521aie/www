//
//  ShopEditView.h
//  RestApp
//
//  Created by zxh on 14-5-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageBox.h"
#import "INavigateEvent.h"
#import "EventConstants.h"
#import "IEditItemListEvent.h"
#import "IEditItemMemoEvent.h"
#import "OptionPickerClient.h"
#import "IEditImageBoxClient.h"
#import "IEditMultiListEvent.h"
#import "MultiCheckHandle.h"
#import "MemoInputClient.h"
#import "FooterListEvent.h"
#import "ImageRemoveHandle.h"
#import "IEditItemRadioEvent.h"
#import "MapLocationView.h"
#import "ObjectUtil.h"
#import "TDFRootViewController.h"
#import "TDFShopInfoService.h"

@class KabawModule,KabawService,MBProgressHUD,SystemService;
@class EditItemText,EditItemList,EditMultiList,EditItemMemo,NavigateTitle2;
@class ShopDetail,IEditItemImageEvent,ShopRemoteShop,CountriesVO;
@interface ShopEditView : TDFRootViewController<INavigateEvent,IEditItemListEvent,IEditItemMemoEvent,OptionPickerClient,IEditMultiListEvent,MultiCheckHandle,MemoInputClient,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,IEditImageBoxClient,IEditItemListEvent,OptionPickerClient,UITextFieldDelegate>
{
     UIImage*shopImage;
    
//    MBProgressHUD *hud;
    
    KabawModule *parent;
    
    KabawService *service;
    
    SystemService *systemService;
    
    NSString *imgFilePathTemp;
    
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, strong) IBOutlet UIView *titleDiv;         //标题容器
@property (nonatomic, strong) NavigateTitle2* titleBox;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet EditItemText *txtBusinessTime;
@property (nonatomic, strong) IBOutlet EditItemText *txtPhone;
@property (nonatomic, strong) IBOutlet EditItemList *lsPerSpend;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsFoodStyle;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsMainBusiness;
@property (nonatomic, strong) IBOutlet EditMultiList *mlsFeatureService;
@property (nonatomic, strong) IBOutlet EditItemMemo *txtIntroduce;
@property (nonatomic, strong) IBOutlet EditImageBox *boxPic;
@property (nonatomic, strong) IBOutlet EditItemList *country;
@property (nonatomic, strong) IBOutlet EditItemList *province;
@property (nonatomic, strong) IBOutlet EditItemList *city;
@property (nonatomic, strong) IBOutlet EditItemList *town;
@property (nonatomic, strong) IBOutlet UILabel *lblLocation;
@property (nonatomic, strong) IBOutlet UIView *eatAddress;
@property (nonatomic, strong) IBOutlet UIView *shopLocationBox;
@property (nonatomic, strong) IBOutlet UITextField *shopAdressTf;
@property (nonatomic, strong) IBOutlet UILabel *lblNoSave;
@property (nonatomic, strong) IBOutlet UILabel *lblNoSave1;
//@property (weak, nonatomic) IBOutlet EditImageBox *publicCodeBox;
//@property (weak, nonatomic) IBOutlet UILabel *shopCodeTip;
@property (nonatomic, strong) EditImageBox *currentImageBox;
@property (nonatomic, strong) ShopDetail* shopDetail;
@property (nonatomic, strong) ShopRemoteShop* shopRemote;
@property (nonatomic, strong) NSMutableArray* countriesVO;
@property (nonatomic, strong) NSMutableArray* provinceVO;
@property (nonatomic, strong) NSMutableArray* cityVO;
@property (nonatomic, strong) NSMutableArray* townVO;
@property (nonatomic, strong) NSMutableArray* shopImgs;
@property (nonatomic, strong) NSMutableArray* publicImgs;
@property (nonatomic, strong) NSMutableArray* shopTags;
@property (nonatomic, strong) NSMutableArray* allTags;
@property (nonatomic, strong) NSMutableArray* currTags;
@property (nonatomic, strong) NSString* perTag;
@property (nonatomic, strong) EditItemList *obj;
@property (nonatomic, strong) NSString* titleName;
@property (nonatomic, strong) NSString* codeTag;
@property (nonatomic, strong) NSString *countryNo; //国家代码
@property (nonatomic, strong) NSString *cityNo; //城市代码
@property (nonatomic, strong) NSString *townNo; //区县代码
@property (nonatomic, strong) NSString *provinceNo; //省份代码
@property (nonatomic, assign) NSInteger currShopTag;
@property (nonatomic, assign) NSInteger backIndex;
@property (nonatomic, assign) NSInteger action;
@property (nonatomic, assign) BOOL changed;



- (IBAction)locationBtnClick:(UIButton *)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parent;

-(void)refreshLongtitude:(NSString *)longtitude latitude:(NSString *)latitude address:(NSString *)address;

- (void)loadDatas;

@end
