//
//  TDFOptionSelectController.m
//  TDFTools
//
//  Created by Octree on 16/8/16.
//  Copyright © 2016年 Octree. All rights reserved.
//

#import "TDFOptionSelectController.h"
#import "TDFOptionTableViewController.h"

@interface TDFOptionSelectController ()

@property (nonatomic, readonly) TDFOptionTableViewController *optionViewController;

@end

@implementation TDFOptionSelectController

#pragma mark - Life Cycle

- (instancetype)init {

    if (self = [super init]) {
    
        self.viewControllers = @[[[TDFOptionTableViewController alloc] init]];
    }
    
    return self;
}


+ (instancetype)optionSelectControllerWithOptions:(NSArray *)options selectedIndexes:(NSArray *)selectedIndexes cancelBlock:(TDFOptionSelectCancelBlock)cancel completion:(TDFOptionSelectCompletionBlock)completion {

    TDFOptionSelectController *vc = [[TDFOptionSelectController alloc] init];
    vc.options = options;
    vc.selectedIndexs = selectedIndexes;
    vc.completionBlock = completion;
    vc.cancelBlock = cancel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.82 green:0.00 blue:0.00 alpha:1.00];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{
                                          NSForegroundColorAttributeName: [UIColor whiteColor]
                                          };
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelButtonTapped)];
    
    self.optionViewController.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(confirmButtonTapped)];
    self.optionViewController.navigationItem.rightBarButtonItem = confirmItem;
}


#pragma mark - Action

- (void)cancelButtonTapped {

    __weak __typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(wself) sself = wself;
        
        !sself.cancelBlock ?: sself.cancelBlock();
    }];
}


- (void)confirmButtonTapped {

    __weak __typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(wself) sself = wself;
        
        !sself.completionBlock ?:  sself.completionBlock(sself.selectedIndexs);
    }];
}

#pragma mark - Accessor

- (void)setSelectedIndexs:(NSArray<NSNumber *> *)selectedIndexs {
   
    self.optionViewController.selectedIndexs = selectedIndexs;
}

- (NSArray <NSNumber *> *)selectedIndexs {
    
    return self.optionViewController.selectedIndexs;
}

- (void)setOptions:(NSArray *)options {

    self.optionViewController.options = options;
}

- (NSArray *)options {

    return self.optionViewController.options;
}


- (TDFOptionTableViewController *)optionViewController {
    
    return [self.viewControllers firstObject];
}

@end
