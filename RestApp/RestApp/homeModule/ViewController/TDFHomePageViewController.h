//
//  TDFHomePageViewController.h
//  Pods
//
//  Created by happyo on 2017/3/8.
//
//

#import "TDFRootViewController.h"

@interface TDFHomePageViewController : TDFRootViewController

@property (nonatomic,copy) void (^reSetRootVCFromeMainModuleCallBack)(void);

// 因为系统的viewWillAppear不会调，所以只能手动调用
- (void)viewWillAppearByHand;

- (void)showHomeView;

- (void)showEntryView;

@end
