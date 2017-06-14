//
//  MapLocation.h
//  RestApp
//
//  Created by 刘红琳 on 15/11/30.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <AMapSearchKit/AMapSearchKit.h>
#import <UIKit/UIKit.h>
#import "NavigateTitle2.h"
#import "KabawModule.h"
#import "MBProgressHUD.h"
#import <MAMapKit/MAMapKit.h>
#import "NSString+Estimate.h"
#import "ShopDetail.h"
#import "MessageBox.h"
#import "XHAnimalUtil.h"
#import "AlertBox.h"
#import "ShopEditView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "CustomCalloutView.h"
#import "TDFRootViewController.h"
typedef void (^MapCallBackBlock)(NSString *shoplongitude,NSString *shopLatitude,NSString *mapAddress);

@interface MapLocationView : TDFRootViewController<INavigateEvent,MAMapViewDelegate,MessageBoxClient,AMapSearchDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,AMapLocationManagerDelegate>
{
    KabawModule *parent;
    
    MBProgressHUD *hud;
    
    MAMapView *_mapView;
    
    AMapSearchAPI *_search;
    
    AMapLocationManager *locMar;
}
@property (nonatomic, copy)MapCallBackBlock backBlock;

@property (nonatomic, readonly) CustomCalloutView *calloutView;
@property (nonatomic, strong) IBOutlet UIView *titleDiv;
@property (nonatomic, strong) NavigateTitle2* titleBox;  //标题容器
@property (strong, nonatomic) IBOutlet UIView *container;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *annotationArr;
@property (strong, nonatomic) NSMutableDictionary *addressDic;
@property (strong, nonatomic) IBOutlet UILabel *lblWarn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *shoplongitude;
@property (strong, nonatomic) NSString *shopLatitude;
@property (strong, nonatomic) NSString *mapAddress;

@property (strong, nonatomic) IBOutlet UIButton *locationBtn;
@property (nonatomic,assign) int  clickType;
@property (nonatomic,assign) BOOL isloging;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) BOOL isLocation;
@property (strong, nonatomic) AMapLocationManager *locMgr;
@property (strong, nonatomic) NSMutableArray *array;
@property (nonatomic, strong) NSString *shopAddress;
- (IBAction)narrowBtnClick:(id)sender;
- (IBAction)amplifyBtnClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(KabawModule *)parentTemp;
- (IBAction)locationBtnClick:(id)sender;
-(void)loadDataView;
- (void)startLocation;
@end
