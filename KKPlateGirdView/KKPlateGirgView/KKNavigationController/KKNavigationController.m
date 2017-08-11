//
//  KKNavigationController.m
//  KKToydayNews
//
//  Created by finger on 2017/8/6.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKNavigationController.h"

@interface KKNavigationController ()

@end

@implementation KKNavigationController

+(void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    //设置文字样式
    [navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Blod" size:18],NSFontAttributeName, nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- 压入视图

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count>1){
        NSArray *controllers = self.viewControllers;
        NSString *parentTitle = [[[controllers objectAtIndex:controllers.count - 2] navigationItem] title];
        viewController.navigationItem.leftBarButtonItem = [self createBackItemWithTitle:parentTitle];
    }
}

#pragma mark -- 返回按钮

- (UIBarButtonItem *)createBackItemWithTitle:(NSString *)title{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.frame = CGRectMake(0, 0, 12, 20);
    if (title != nil){
        backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        [backButton setTitle:title forState:UIControlStateNormal];
        [backButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    }
    [backButton setImage:[UIImage imageNamed:@"backItem"] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"backItem"] imageWithAlpha:0.5] forState:UIControlStateHighlighted];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,5,0, 0)];
    [backButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin];
    [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backItem;
}

- (void)popSelf{
    [self popViewControllerAnimated:YES];
}

@end
